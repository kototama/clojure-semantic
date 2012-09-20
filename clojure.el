(require 'semantic/wisent)
(require 'semantic/wisent/clojure-wy)

;; TODO: problem with whitespaces + symbols

(define-lex-simple-regex-analyzer wisent-clojure-lex-symbol
  "Detect and create symbols tokens."
  "[^] \n\t0-9(){}[][^] \t\n(){}[]*"
  'SYMBOL)

(define-lex-simple-regex-analyzer wisent-clojure-lex-ratio
  "Detect ratio numbers."
  ;; ([-+]?[0-9]+)/([0-9]+)
  "[-+]?[0-9]+/[0-9]+"
  'RATIO)

(define-lex-simple-regex-analyzer wisent-clojure-lex-number
  "Detect and create number tokens."
  (concat "[-+]?" semantic-lex-number-expression) 'NUMBER)

(define-lex-simple-regex-analyzer wisent-clojure-lex-quote
  "Detect a quote"
  "'" 'QUOTE)

(define-lex-simple-regex-analyzer wisent-clojure-lex-deref
  "Detect a deref"
  "@" 'DEREF)

(define-lex-simple-regex-analyzer wisent-clojure-lex-meta
  "Detect a meta"
  "\\^" 'META)

(define-lex-simple-regex-analyzer wisent-clojure-lex-syntaxquote
  "Detect a syntaxquote"
  "`" 'SYNTAXQUOTE)

(define-lex-simple-regex-analyzer wisent-clojure-lex-unquote
  "Detect an unquote"
  "~" 'UNQUOTE)

(define-lex-simple-regex-analyzer wisent-clojure-lex-meta-reader
  ""
  "#^" 'META_READER)

(define-lex-simple-regex-analyzer wisent-clojure-lex-var-reader
  ""
  "#'" 'VAR_READER)

(define-lex-simple-regex-analyzer wisent-clojure-lex-regex-reader
  ""
  "#\\\".*\\\"" 'REGEX_READER)

(define-lex-simple-regex-analyzer wisent-clojure-lex-fn-reader
  ""
  "#(" 'FN_READER)

(define-lex-simple-regex-analyzer wisent-clojure-lex-set-reader
  ""
  "#{" 'SET_READER)

(define-lex-simple-regex-analyzer wisent-clojure-lex-eval-reader
  ""
  "#=" 'EVAL_READER)

(define-lex-simple-regex-analyzer wisent-clojure-lex-comment-reader
  ""
  "#!" 'COMMENT_READER)

(define-lex-simple-regex-analyzer wisent-clojure-lex-unreadable-reader
  ""
  "#!" 'UNREADABLE_READER)

(define-lex-simple-regex-analyzer wisent-clojure-lex-discard-reader
  ""
  "#_" 'DISCARD_READER)


(define-lex wisent-clojure-lexer
  "Clojure lexical analyzer."
  semantic-lex-ignore-whitespace
  semantic-lex-ignore-newline
  semantic-lex-ignore-comments
  wisent-clojure-lex-discard-reader
  wisent-clojure-lex-unreadable-reader
  wisent-clojure-lex-comment-reader
  wisent-clojure-lex-eval-reader
  wisent-clojure-lex-fn-reader
  wisent-clojure-lex-set-reader
  wisent-clojure-lex-regex-reader
  wisent-clojure-lex-meta-reader
  wisent-clojure-lex-var-reader
  wisent-clojure-lex-unquote
  wisent-clojure-lex-quote
  wisent-clojure-lex-syntaxquote
  wisent-clojure-lex-meta
  wisent-clojure-lex-deref 
  wisent-clojure-lex-quote
  wisent-clojure-lex-ratio
  wisent-clojure-lex-number
  wisent-clojure-wy--<string>-sexp-analyzer
  wisent-clojure-wy--<block>-block-analyzer
  wisent-clojure-lex-symbol
  semantic-lex-default-action
  
  )

(defun wisent-clojure (input)
  "Parse some text"
  (with-temp-buffer
    (wisent-clojure-setup-parser)
    (semantic-lex-init)
    (insert input)
    (let* ((wisent-lex-istream (semantic-lex-buffer))
	   (answer (wisent-parse semantic--parse-table 'wisent-lex)))
      answer)))

(defun wisent-clojure-utest ()
  "Test"
  (interactive)
  (let ((symbols '("asymbol"
                   "list1"
                   ":asymbol"
                   "a-symbol"
                   ":key"
                   "::key"
                   "qualified/symbol"))
        (ratios '("1/9"
                  "+1/4"
                  "-1/5"
                  ))
        (numbers '("1"
                   "43"))
        (floats '("3.14156"
                  "-1.678"))
        (strings '("\"hello\""))
        (lists '("(42)"
                 "(take)"
                 "(list a b c)"
                 "(list1 (list2 a b))"))
        (vectors '("[:a]"
                   "(vec1 (vec2 a b))")))
    (dolist (exp (append symbols ratios numbers floats strings
                         lists vectors))
      (message "Test %s " exp) 
      (message "Exp: %s "(wisent-clojure exp)))))

(wisent-clojure-utest)


;; (setq semantic-new-buffer-setup-functions (cons '(clojure-mode . wisent-clojure-setup-parser)  semantic-new-buffer-setup-functions))
