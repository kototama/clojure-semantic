(require 'semantic/wisent)
(require 'semantic/wisent/clojure-wy)

(define-lex-simple-regex-analyzer wisent-clojure-lex-symbol
  "Detect and create symbols tokens."
  ;; Original Java regexp: "[:]?([\\D&&[^/]].*/)?([\\D&&[^/]][^/]*)"
  ":?\\([^[:digit:]/].*/\\)?[^[:digit:]/][^/]*"
  'SYMBOL)

(define-lex-simple-regex-analyzer wisent-clojure-lex-ratio
  "Detect ratio numbers."
  ;; ([-+]?[0-9]+)/([0-9]+)
  "[-+]?[0-9]+/[0-9]+"
  'RATIO)

(define-lex-simple-regex-analyzer wisent-clojure-lex-number
  "Detect and create number tokens."
  (concat "[-+]?" semantic-lex-number-expression) 'NUMBER)

(define-lex-simple-regex-analyzer wisent-clojure-lex-punctuation
  "Detect and create punctuation tokens."
  "\\(\\s.\\|\\s$\\|\\s'\\)" (char-after))

(define-lex wisent-clojure-lexer
  "Clojure lexical analyzer."
  ;; semantic-lex-ignore-whitespace
  ;; semantic-lex-ignore-newline
  wisent-clojure-lex-ratio
  wisent-clojure-lex-number
  ;; wisent-clojure-lex-symbol
  ;; wisent-clojure-lex-punctuation
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
                  "-1.678") 
                )
        )
    (dolist (exp (append  ratios numbers floats))
      (message "Test %s " exp) 
      (message "exp: %s " (wisent-clojure exp)))))

(wisent-clojure-utest)


;; (setq semantic-new-buffer-setup-functions (cons '(clojure-mode . wisent-clojure-setup-parser)  semantic-new-buffer-setup-functions))
