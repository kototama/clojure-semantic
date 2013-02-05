;;; clojure-wy.el --- Generated parser support file

;; Copyright (C) 

;; Author: Pierre Allix <pal@elan-pallix>
;; Created: 2013-02-05 18:47:17+0100
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
  (semantic-lex-make-keyword-table 'nil 'nil)
  "Table of language keywords.")

(defconst wisent-clojure-wy--token-table
  (semantic-lex-make-type-table
   '(("<no-type>"
      (UNREADABLE_READER)
      (DISCARD_READER)
      (UNREADABLE_READER)
      (COMMENT_READER)
      (EVAL_READER)
      (FN_READER)
      (SET_READER)
      (VAR_READER)
      (META_READER)
      (METADATA)
      (NS)
      (SYMBOL)
      (DEF)
      (DEFN))
     ("number"
      (NUMBER_LITERAL))
     ("string"
      (STRING_LITERAL))
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
   '(("number" :declared t)
     ("string" :declared t)
     ("block" :declared t)))
  "Table of lexical tokens.")

(defconst wisent-clojure-wy--parse-table
  (progn
    (eval-when-compile
      (require 'semantic/wisent/comp))
    (wisent-compile-grammar
     '((PAREN_BLOCK BRACE_BLOCK BRACK_BLOCK LPAREN RPAREN LBRACE RBRACE LBRACK RBRACK STRING_LITERAL NUMBER_LITERAL DEFN DEF SYMBOL NS METADATA META_READER VAR_READER SET_READER FN_READER EVAL_READER COMMENT_READER UNREADABLE_READER DISCARD_READER)
       nil
       (sexpr
        ((PAREN_BLOCK)
         (semantic-parse-region
          (car $region1)
          (cdr $region1)
          'list_content_opt 1))
        ((SYMBOL)))
       (list_content_opt
        (nil)
        ((list_content)))
       (list_content
        ((DEF metadata_defs_opt SYMBOL list_content_opt)
         (wisent-raw-tag
          (semantic-tag-new-variable $3 nil nil)))
        ((DEFN metadata_defs_opt SYMBOL doc_string_opt metadata_defs_opt fn_content_def)
         (wisent-raw-tag
          (semantic-tag-new-function $3 nil
                                     (car $6)
                                     :arity
                                     (cadr $6))))
        ((NS metadata_defs_opt SYMBOL)
         (wisent-raw-tag
          (semantic-tag-new-package $3 nil))))
       (doc_string_opt
        (nil)
        ((STRING_LITERAL)))
       (metadata_defs_opt
        (nil)
        ((metadata_defs)))
       (metadata_defs
        ((metadata_def))
        ((metadata_defs metadata_def)))
       (metadata_def
        ((BRACE_BLOCK))
        ((METADATA BRACE_BLOCK))
        ((METADATA SYMBOL)
         (list $2)))
       (fn_content_simple_arity
        ((BRACK_BLOCK)
         (semantic-parse-region
          (car $region1)
          (cdr $region1)
          'argument 1)))
       (fn_content_multi_arity
        ((PAREN_BLOCK)
         (list
          (semantic-parse-region
           (car $region1)
           (cdr $region1)
           'fn_content_simple_arity 1)))
        ((PAREN_BLOCK fn_content_multi_arity)
         (append
          (list
           (semantic-parse-region
            (car $region1)
            (cdr $region1)
            'fn_content_simple_arity 1)
           (list $2)))))
       (fn_content_def
        ((fn_content_simple_arity)
         (list $1 nil))
        ((fn_content_multi_arity)
         (list
          (car $1)
          $1)))
       (argument
        ((SYMBOL)
         (wisent-raw-tag
          (semantic-tag-new-variable $1 nil nil)))
        ((metadata_def SYMBOL)
         (wisent-raw-tag
          (semantic-tag-new-variable $2
                                     (car $1)
                                     nil)))))
     '(sexpr list_content_opt argument fn_content_simple_arity)))
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

(define-lex-regex-type-analyzer wisent-clojure-wy--<number>-regexp-analyzer
  "regexp analyzer for <number> tokens."
  semantic-lex-number-expression
  nil
  'NUMBER_LITERAL)

(define-lex-sexp-type-analyzer wisent-clojure-wy--<string>-sexp-analyzer
  "sexp analyzer for <string> tokens."
  "\\s\""
  'STRING_LITERAL)


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
