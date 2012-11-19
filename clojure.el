(require 'semantic/wisent)
(require ';; semantic/wisent/
         clojure-wy)

;; TODO: remove the following line
(setq wisent-clojure-defn-regexp "\\(deftest\\|defn-\\|defn\\|defmacro\\)")
(defvar wisent-clojure-defn-regexp "\\(deftest\\|defn-\\|defn\\|defmacro\\)")

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
