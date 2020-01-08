(TeX-add-style-hook
 "jmwcommon"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("hyperref" "colorlinks=true") ("mdframed" "framemethod=TikZ")))
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "amsmath"
    "amssymb"
    "mathrsfs"
    "xcolor"
    "hyperref"
    "graphicx"
    "siunitx"
    "amsthm"
    "thmtools"
    "mdframed")
   (TeX-add-symbols
    '("abs" 1)
    '("Law" 1)
    '("bvec" 1)
    '("ind" 1)
    '("floor" 1)
    '("norm" 1)
    '("ip" 2)
    '("mailto" 1)
    '("mmref" 1)
    "CC"
    "RR"
    "QQ"
    "ZZ"
    "FF"
    "PP"
    "NN"
    "eps"
    "dt"
    "defeq"
    "del"
    "iso"
    "revimplies"
    "degrees"
    "cbrt"
    "id"
    "epsm"
    "vx"
    "vy"
    "vq"
    "scrB"
    "scrF"
    "EE"
    "LHS"
    "probto"
    "asto"
    "distto"
    "Gauss"
    "meet"
    "Im")
   (LaTeX-add-labels
    "#1")
   (LaTeX-add-environments
    '("mma" 1)
    '("mmp" 1)
    '("lecture" 1)
    "objects")
   (LaTeX-add-xcolor-definecolors
    "lightred")
   (LaTeX-add-amsthm-newtheorems
    "claim"
    "theorem"
    "lemma")
   (LaTeX-add-thmtools-declaretheoremstyles
    "thmbluebox")
   (LaTeX-add-thmtools-declaretheorems
    "theorem"
    "lemma")
   (LaTeX-add-mdframed-mdfdefinestyles
    "mdbluebox"))
 :latex)

