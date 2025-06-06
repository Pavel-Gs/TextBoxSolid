(defun c:TextBoxSolid (/ ent entData entType insPt txt boxMin boxMax pad angle 
                         p1 p2 p3 p4 solidEnt solidData layerName rotate)

  ;; Helper: 2D rotate point by angle (in radians)
  (defun rotate (pt angle) 
    (list 
      (- (* (cos angle) (car pt)) (* (sin angle) (cadr pt)))
      (+ (* (sin angle) (car pt)) (* (cos angle) (cadr pt)))
    )
  )

  (setq ent (car (entsel "\nSelect TEXT or MTEXT entity: ")))
  (if ent
    (progn
      (setq entData (entget ent))
      (setq entType (cdr (assoc 0 entData)))

      (if (or (= entType "TEXT") (= entType "MTEXT"))
        (progn
          (setq insPt (cdr (assoc 10 entData)))
          (setq angle (cdr (assoc 50 entData))) ; angle in radians

          ;; Use (textbox) to get bounding box
          (setq txt (textbox entData))
          (setq boxMin (car txt))
          (setq boxMax (cadr txt))

          ;; Padding
          (setq pad 0.05)

          ;; Corners of the box (relative to origin)
          (setq p1 (list (- (car boxMin) pad) (- (cadr boxMin) pad))) ; bottom-left
          (setq p2 (list (+ (car boxMax) pad) (- (cadr boxMin) pad))) ; bottom-right
          (setq p3 (list (- (car boxMin) pad) (+ (cadr boxMax) pad))) ; top-left
          (setq p4 (list (+ (car boxMax) pad) (+ (cadr boxMax) pad))) ; top-right

          ;; Rotate + translate
          (setq p1 (mapcar '+ insPt (rotate p1 angle)))
          (setq p2 (mapcar '+ insPt (rotate p2 angle)))
          (setq p3 (mapcar '+ insPt (rotate p3 angle)))
          (setq p4 (mapcar '+ insPt (rotate p4 angle)))

          ;; Draw the solid
          (command "SOLID" p1 p2 p3 p4 "")
          (setq solidEnt (entlast))

          ;; Update solid properties
          (if solidEnt
            (progn
              (setq solidData (entget solidEnt))
              (setq layerName (cdr (assoc 8 entData)))
              (setq solidData 
                    (append 
                      (subst (cons 62 19) (assoc 62 solidData) solidData) ; set color 19
                      (list (cons 8 layerName)) ; match text layer
                    )
              )
              (entmod solidData)
              (entupd solidEnt)

              ;; Bring both to top, with text above solid
              (command "_.draworder" solidEnt "" "front") ; bring solid to front
              (command "_.draworder" ent "" "front")      ; then bring text above it
            )
          )
        )
        (prompt "\nSelected entity is not TEXT or MTEXT.")
      )
    )
    (prompt "\nNo entity selected.")
  )
  (princ)
)
