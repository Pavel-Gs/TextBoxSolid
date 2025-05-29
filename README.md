# AUTOCAD LISP script

Automatically place "solid" object behind TEXT (or mText).
- "solid" has a rectangular shape with a small padding
- "solid" will be placed on the same layer as text
- the color of the "solid" will be #19
- follows the rotation and the length of the text


## How to use
### `Load through CAD`
1) Use command "APPLOAD" and locate the desired *.lsp file
2) Use command "TextBoxSolid" and select the text

### `Setup auto load`
- locate icad.lsp
- in my case: "C:\Program Files\MicroSurvey\MSCAD2016"
- add (load "...")
- in my case: (load "C:/Program Files/MicroSurvey/MSCAD2016/TextBoxSolid.lsp")
