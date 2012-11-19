(require 'semantic/wisent)
(require ';; semantic/wisent/
         clojure-wy)

(defvar wisent-clojure-user-defn-list nil
  "A list of names or regex for the user's own Clojure macros that defines functions.")

(defvar wisent-clojure-defn-regexp (regexp-opt (append
                                                '("defn" "defn-" "def" "def-" "defonce"
                                                  "defmulti" "defmethod" "defmacro"
                                                  "defstruct" "deftype" "defprotocol"
                                                  "defrecord" "deftest"
                                                  "slice" "def\\[a-z\\]"
                                                  "defalias" "defhinted" "defmacro-"
                                                  "defn-memo" "defnk" "defonce-"
                                                  "defstruct-" "defunbound" "defunbound-"
                                                  "defvar" "defvar-")
                                                wisent-clojure-user-defn-list)))

(define-lex-simple-regex-analyzer wisent-clojure-lex-deffunc
  "Detect and create functions and macros."
  wisent-clojure-defn-regexp 'DEFN)

;; Define the lexer for this grammar
(define-lex wisent-clojure-lexer
  "Lexical analyzer that handles Clojure buffers.
It ignores whitespaces, newlines and comments."
  semantic-lex-ignore-whitespace
  semantic-lex-ignore-newline
  semantic-lex-ignore-comments
  ;;; our own lexers:
  wisent-clojure-lex-deffunc
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
