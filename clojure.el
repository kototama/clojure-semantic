(require 'semantic/wisent)
(require ';; semantic/wisent/
         clojure-wy)

(defun wisent-clojure-default-setup ()
  "Hook run to setup Semantic in `clojure-mode'."
  ;; Use the Wisent LALR(1) parser to analyze Java sources.
  (wisent-clojure-wy--install-parser)
  (setq
   ;; Lexical analysis
   ;; semantic-lex-depth nil
   semantic-lex-analyzer 'wisent-clojure2-lexer))

(remove-hook 'clojure-mode-hook 'wisent-clojure-default-setup)
(add-hook 'clojure-mode-hook 'wisent-clojure-default-setup)
