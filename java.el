(require 'semantic/wisent)
(require ;; semantic/wisent/
         'java-wy)

(defun wisent-java-default-setup2 ()
  "Hook run to setup Semantic in `java-mode'."
  ;; Use the Wisent LALR(1) parser to analyze Java sources.
  (wisent-java-wy--install-parser)
  (setq semantic-lex-analyzer 'wisent-clojure2-lexer)
  ;; (semantic-make-local-hook 'wisent-pre-parse-hook)
  ;; (setq
  ;;  ;; Lexical analysis
  ;;  semantic-lex-number-expression semantic-java-number-regexp
  ;;  semantic-lex-depth nil
  ;;  semantic-lex-analyzer 'wisent-java-lexer
  ;;  ;; Parsing
  ;;  semantic-tag-expand-function 'semantic-java-expand-tag
  ;;  ;; Environment
  ;;  semantic-imenu-summary-function 'semantic-format-tag-prototype
  ;;  semantic-imenu-expandable-tag-classes '(type variable)
  ;;  imenu-create-index-function 'semantic-create-imenu-index
  ;;  semantic-type-relation-separator-character '(".")
  ;;  semantic-command-separation-character ";"
  ;;  ;; speedbar and imenu buckets name
  ;;  semantic-symbol->name-assoc-list-for-type-parts
  ;;  ;; in type parts
  ;;  '((type     . "Classes")
  ;;    (variable . "Variables")
  ;;    (function . "Methods"))
  ;;  semantic-symbol->name-assoc-list
  ;;  ;; everywhere
  ;;  (append semantic-symbol->name-assoc-list-for-type-parts
  ;;          '((include  . "Imports")
  ;;            (package  . "Package")))
  ;;  ;; navigation inside 'type children
  ;;  senator-step-at-tag-classes '(function variable)
  ;;  ;; Remove 'recursive from the default semanticdb find throttle
  ;;  ;; since java imports never recurse.
  ;;  semanticdb-find-default-throttle
  ;;  (remq 'recursive (default-value 'semanticdb-find-default-throttle))
  ;;  )
  ;; Setup javadoc stuff
  ;; (semantic-java-doc-setup)
  )

(add-hook 'java-mode-hook 'wisent-java-default-setup2)
;; (add-hook 'java-mode-hook 'wisent-java-default-setup-exp)


;; Execute that to activate the parser for the clojure-mode
;; (setq semantic-new-buffer-setup-functions (cons '(clojure-mode . wisent-java-default-setup)  semantic-new-buffer-setup-functions))
