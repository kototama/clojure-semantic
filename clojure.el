(require 'semantic/wisent)
(require ';; semantic/wisent/
         clojure-wy)

(defvar wisent-clojure-user-def-macros nil
  "A list of names for the user's own Clojure macros that defines variables.")

;; TODO: move that to a var
(setq wisent-clojure-def-regexp (regexp-opt (append
                                                '("def" "def-" "defonce" "defonce-"
                                                  "defstruct-" "defunbound"
                                                  "defunbound-"
                                                  "defvar" "defvar-"
                                                  "defrecord"
                                                  "defstruct" "deftype" "defprotocol"
                                                  "defalias" "defhinted")
                                                wisent-clojure-user-def-macros)))

(defvar wisent-clojure-user-defn-macros nil
  "A list of names for the user's own Clojure macros that defines functions.")

;; TODO: move that to a var
(setq wisent-clojure-defn-regexp (regexp-opt (append
                                                '("defn" "defn-" 
                                                  "defmulti" "defmethod" "defmacro"
                                                  "deftest"
                                                  "defmacro-"
                                                  "defn-memo" "defnk")
                                                wisent-clojure-user-defn-macros)))

(define-lex-simple-regex-analyzer wisent-clojure-lex-deffunc
  "Detect and create functions and macros."
  wisent-clojure-defn-regexp 'DEFN)

(define-lex-simple-regex-analyzer wisent-clojure-lex-defvar
  "Detect and create variables."
  wisent-clojure-def-regexp 'DEF)

;; Define the lexer for this grammar
(define-lex wisent-clojure-lexer
  "Lexical analyzer that handles Clojure buffers.
It ignores whitespaces, newlines and comments."
  semantic-lex-ignore-whitespace
  semantic-lex-ignore-newline
  semantic-lex-ignore-comments
  ;;; our own lexers:
  wisent-clojure-lex-deffunc
  wisent-clojure-lex-defvar
  ;;;; Auto-generated analyzers.
  wisent-clojure-wy--<number>-regexp-analyzer
  wisent-clojure-wy--<string>-sexp-analyzer
  ;; Must detect keywords before other symbols
  wisent-clojure-wy--<keyword>-keyword-analyzer
  wisent-clojure-wy--<symbol>-regexp-analyzer
  wisent-clojure-wy--<punctuation>-string-analyzer
  wisent-clojure-wy--<block>-block-analyzer
  semantic-lex-default-action) 

(defun wisent-clojure-default-setup ()
  "Hook run to setup Semantic in `clojure-mode'."
  (wisent-clojure-wy--install-parser)
  (setq
   ;; Lexical analysis
   ;; semantic-lex-depth nil
   semantic-lex-analyzer 'wisent-clojure-lexer))

(remove-hook 'clojure-mode-hook 'wisent-clojure-default-setup)
(add-hook 'clojure-mode-hook 'wisent-clojure-default-setup)

;; various override
(define-mode-local-override semantic-sb-tag-children-to-expand
  clojure-mode (tag)
  "Doc goes here"
  (message "[clojure] tag : %s" tag))

(define-mode-local-override semantic-ia-insert-tag-default
  clojure-mode (tag)
  "Overrides the semantic function"
  )
