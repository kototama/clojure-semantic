;;; clojure-wy.el --- Generated parser support file

;; Copyright (C) 

;; Author: Pierre Allix <pal@elan-pallix>
;; Created: 2012-11-21 11:46:09+0100
;; Keywords: syntax
;; X-RCS: $Id$

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of
;; the License, or (at your option) any later version.

;; This software is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; PLEASE DO NOT MANUALLY EDIT THIS FILE!  It is automatically
;; generated from the grammar file clojure.wy.

;;; History:
;;

;;; Code:

(eval-when-compile (require 'semantic/bovine))

;;; Prologue
;;

;;; Declarations
;;
(defconst wisent-clojure-wy--keyword-table
  (semantic-lex-make-keyword-table
   '(("throw" . THROW))
   '(("throw" summary "throw")))
  "Table of language keywords.")

(defconst wisent-clojure-wy--token-table
  (semantic-lex-make-type-table
   '(("<no-type>"
      (DEF)
      (DEFN))
     ("number"
      (NUMBER_LITERAL))
     ("string"
      (STRING_LITERAL))
     ("symbol"
      (NS . "\\`ns\\'")
      (IDENTIFIER))
     ("punctuation"
      (METADATA . "^")
      (DISCARD_READER . "#_")
      (UNREADABLE_READER . "#<")
      (COMMENT_READER . "#!")
      (EVAL_READER . "#=")
      (FN_READER . "#(")
      (SET_READER . "#{")
      (VAR_READER . "#'")
      (META_READER . "#^"))
     ("close-paren"
      (RBRACK . "]")
      (RBRACE . "}")
      (RPAREN . ")"))
     ("open-paren"
      (LBRACK . "[")
      (LBRACE . "{")
      (LPAREN . "("))
     ("block"
      (BRACK_BLOCK . "(LBRACK RBRACK)")
      (BRACE_BLOCK . "(LBRACE RBRACE)")
      (PAREN_BLOCK . "(LPAREN RPAREN)")))
   '(("keyword" :declared t)
     ("number" :declared t)
     ("string" :declared t)
     ("symbol" :declared t)
     ("punctuation" :declared t)
     ("block" :declared t)))
  "Table of lexical tokens.")

(defconst wisent-clojure-wy--parse-table
  (progn
    (eval-when-compile
      (require 'semantic/wisent/comp))
    (wisent-compile-grammar
     '((PAREN_BLOCK BRACE_BLOCK BRACK_BLOCK LPAREN RPAREN LBRACE RBRACE LBRACK RBRACK META_READER VAR_READER SET_READER FN_READER EVAL_READER COMMENT_READER UNREADABLE_READER DISCARD_READER METADATA IDENTIFIER NS STRING_LITERAL NUMBER_LITERAL THROW DEFN DEF)
       nil
       (sexpr
        ((PAREN_BLOCK)
         (semantic-parse-region
          (car $region1)
          (cdr $region1)
          'list 1)))
       (list
        ((DEF metadata_def_opt IDENTIFIER)
         (wisent-raw-tag
          (semantic-tag-new-variable $3 nil nil)))
        ((DEFN IDENTIFIER arguments_block)
         (wisent-raw-tag
          (semantic-tag-new-function $2 nil $3)))
        ((NS metadata_def_opt IDENTIFIER)
         (wisent-raw-tag
          (semantic-tag-new-package $3 nil))))
       (metadata_def_opt
        (nil)
        ((metadata_def)))
       (metadata_def
        ((METADATA BRACE_BLOCK)))
       (arguments_block
        ((BRACK_BLOCK)
         (semantic-bovinate-from-nonterminal
          (car $region1)
          (cdr $region1)
          'arguments_list)))
       (arguments_list
        ((LBRACK arguments_def_opt RBRACK)
         (identity $2)))
       (arguments_def_opt
        (nil)
        ((arguments_def)
         (identity $1)))
       (arguments_def
        ((argument)
         (list $1))
        ((argument arguments_def)
         (cons $1 $2)))
       (argument
        ((IDENTIFIER)
         (wisent-cook-tag
          (wisent-raw-tag
           (semantic-tag-new-variable $1 nil nil))))))
     '(sexpr list arguments_list)))
  "Parser table.")

(defun wisent-clojure-wy--install-parser ()
  "Setup the Semantic Parser."
  (semantic-install-function-overrides
   '((parse-stream . wisent-parse-stream)))
  (setq semantic-parser-name "LALR"
        semantic--parse-table wisent-clojure-wy--parse-table
        semantic-debug-parser-source "clojure.wy"
        semantic-flex-keywords-obarray wisent-clojure-wy--keyword-table
        semantic-lex-types-obarray wisent-clojure-wy--token-table)
  ;; Collect unmatched syntax lexical tokens
  (semantic-make-local-hook 'wisent-discarding-token-functions)
  (add-hook 'wisent-discarding-token-functions
            'wisent-collect-unmatched-syntax nil t))


;;; Analyzers
;;
(require 'semantic/lex)

(define-lex-block-type-analyzer wisent-clojure-wy--<block>-block-analyzer
  "block analyzer for <block> tokens."
  "\\s(\\|\\s)"
  '((("(" LPAREN PAREN_BLOCK)
     ("{" LBRACE BRACE_BLOCK)
     ("[" LBRACK BRACK_BLOCK))
    (")" RPAREN)
    ("}" RBRACE)
    ("]" RBRACK))
  )

(define-lex-regex-type-analyzer wisent-clojure-wy--<symbol>-regexp-analyzer
  "regexp analyzer for <symbol> tokens."
  "\\(\\sw\\|\\s_\\)+"
  '((NS . "\\`ns\\'"))
  'IDENTIFIER)

(define-lex-regex-type-analyzer wisent-clojure-wy--<number>-regexp-analyzer
  "regexp analyzer for <number> tokens."
  semantic-lex-number-expression
  nil
  'NUMBER_LITERAL)

(define-lex-string-type-analyzer wisent-clojure-wy--<punctuation>-string-analyzer
  "string analyzer for <punctuation> tokens."
  "\\(\\s.\\|\\s$\\|\\s'\\)+"
  '((METADATA . "^")
    (DISCARD_READER . "#_")
    (UNREADABLE_READER . "#<")
    (COMMENT_READER . "#!")
    (EVAL_READER . "#=")
    (FN_READER . "#(")
    (SET_READER . "#{")
    (VAR_READER . "#'")
    (META_READER . "#^"))
  'punctuation)

(define-lex-sexp-type-analyzer wisent-clojure-wy--<string>-sexp-analyzer
  "sexp analyzer for <string> tokens."
  "\\s\""
  'STRING_LITERAL)

(define-lex-keyword-type-analyzer wisent-clojure-wy--<keyword>-keyword-analyzer
  "keyword analyzer for <keyword> tokens."
  "\\(\\sw\\|\\s_\\)+")


;;; Epilogue
;;





(provide 'clojure-wy)

;; We cannot require the corresponding Lisp implementation, since
;; this would lead to a recursion.  Thus we blindly assume that
;; everything's available there.

;; Local variables:
;; byte-compile-warnings: (not unresolved)
;; End:

;;; clojure-wy.el ends here
