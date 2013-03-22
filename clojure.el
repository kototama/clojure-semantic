(require 'semantic/wisent)
(require ';; semantic/wisent/
         clojure-wy)

(defcustom wisent-clojure-user-def-macros nil
  "A list of names for the user's own Clojure macros that defines variables."
  :type '(repeat string)
  :group 'wisent-clojure)

(defvar wisent-clojure-def-regexp (regexp-opt (append
                                               '("def" "def-" "defonce" "defonce-"
                                                 "defstruct-" "defunbound"
                                                 "defunbound-"
                                                 "defvar" "defvar-"
                                                 "defrecord"
                                                 "defstruct" "deftype" "defprotocol"
                                                 "defalias" "defhinted")
                                               wisent-clojure-user-def-macros)))

(defcustom wisent-clojure-user-defn-macros nil
  "A list of names for the user's own Clojure macros that defines functions."
  :type '(repeat string)
  :group 'wisent-clojure)

(defvar wisent-clojure-defn-regexp (regexp-opt (append
                                                '("defn" "defn-" 
                                                  "defmulti" "defmethod" "defmacro"
                                                  "deftest"
                                                  "defmacro-"
                                                  "defn-memo" "defnk")
                                                wisent-clojure-user-defn-macros)))

(define-lex-simple-regex-analyzer wisent-clojure-lex-deffunc
  "Detect functions and macros."
  wisent-clojure-defn-regexp 'DEFN)

(define-lex-simple-regex-analyzer wisent-clojure-lex-defvar
  "Detect variables."
  wisent-clojure-def-regexp 'DEF)

(define-lex-simple-regex-analyzer wisent-clojure-lex-defproject
  "Detect projects definition."
  "defproject" 'DEFPROJECT)

(define-lex-regex-analyzer wisent-clojure-lex-reader
  "Detect reader macros or metadata symbol."
  "\\(#[^ ]\\|\\^\\|`\\|'\\|~@\\|~\\|\\\\.\\|@\\)"
  (let* ((matched (match-string-no-properties 0))
         (token-type (cond ((string= matched "^") 'METADATA)
                           ((string= matched "`") 'BACKQUOTE)
                           ((string= matched "'") 'QUOTE)
                           ((string= (substring matched 0 1) "\\") 'CHARACTER)
                           ((string= matched "~") 'UNQUOTE)
                           ((string= matched "~@") 'UNQUOTE_SPLICING)
                           ((string= matched "@") 'DEREF)
                           ((string= matched "#^") 'META_READER)
                           ((string= matched "#'") 'VAR_READER)
                           ((string= matched "#{") 'SET_READER)
                           ((string= matched "#(") 'FN_READER)
                           ((string= matched "#=") 'EVAL_READER)
                           ((string= matched "#!") 'COMMENT_READER)
                           ((string= matched "#<") 'UNREADABLE_READER)
                           ((string= matched "#_") 'DISCARD_READER)
                           (t 'UNKNOWN_READER))))
   (semantic-lex-push-token
    (semantic-lex-token
     token-type
     (match-beginning 0) (match-end 0)))))

(define-lex-regex-analyzer wisent-clojure-lex-clj-symbol
  "Detect Clojure symbols."
  "\\([^][(){}\"\n\t ]+\\)"
  (let* ((matched (match-string-no-properties 0))
         (token-type (cond ((string= matched "ns") 'NS)
                           (t 'SYMBOL))))
   (semantic-lex-push-token
    (semantic-lex-token
     token-type
     (match-beginning 0) (match-end 0)))))

;; Define the lexer for this grammar
(define-lex wisent-clojure-lexer
  "Lexical analyzer that handles Clojure buffers.
It ignores whitespaces, newlines and comments."
  semantic-lex-ignore-whitespace
  semantic-lex-ignore-newline
  semantic-lex-ignore-comments
  ;;; our own lexers:
  wisent-clojure-lex-reader
  wisent-clojure-lex-defproject
  wisent-clojure-lex-deffunc
  wisent-clojure-lex-defvar 
  wisent-clojure-lex-clj-symbol
  ;;;; Auto-generated analyzers.
  wisent-clojure-wy--<number>-regexp-analyzer
  wisent-clojure-wy--<string>-sexp-analyzer
  wisent-clojure-wy--<block>-block-analyzer
  semantic-lex-default-action)

(defun wisent-clojure-default-setup ()
  "Hook run to setup Semantic in `clojure-mode'."
  (wisent-clojure-wy--install-parser)
  (setq
   ;; Lexical analysis
   ;; semantic-lex-depth nil
   semantic-lex-analyzer 'wisent-clojure-lexer))

(add-to-list 'semantic-new-buffer-setup-functions
        (cons 'clojure-mode 'wisent-clojure-default-setup))

