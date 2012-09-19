(require 'semantic/wisent)
(require 'semantic/wisent/clojure-wy)

(define-lex-simple-regex-analyzer wisent-clojure-lex-symbol
  "Detect and create symbols tokens."
  "[^]0-9(){}#[][^](){}#[]*"
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

(define-lex wisent-clojure-lexer
  "Clojure lexical analyzer."
  semantic-lex-ignore-whitespace
  ;; ;; semantic-lex-ignore-newline
  ;; ;; semantic-lex-ignore-comments
  wisent-clojure-lex-unquote
  wisent-clojure-lex-quote
  wisent-clojure-lex-syntaxquote
  wisent-clojure-lex-meta
  wisent-clojure-lex-deref 
  wisent-clojure-lex-quote
  wisent-clojure-lex-ratio
  wisent-clojure-lex-number
  wisent-clojure-lex-symbol
  ;; generated:
  wisent-clojure-wy--<string>-sexp-analyzer
  wisent-clojure-wy--<block>-block-analyzer
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
                   "qualified/symbol"
                   ))
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
                 "(list 'a 'b 'c)"
                 "(list1 (list2 'a b))"))
        (vectors '("[:a]")))
    (dolist (exp (append symbols ratios numbers floats strings
                         lists vectors))
      (message "Test %s " exp) 
      (message "Exp: %s "(wisent-clojure exp)))))

(wisent-clojure-utest)


;; (setq semantic-new-buffer-setup-functions (cons '(clojure-mode . wisent-clojure-setup-parser)  semantic-new-buffer-setup-functions))
