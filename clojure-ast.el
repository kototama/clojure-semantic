(require 'cl)

(defun wisent-clojure-find-project-tag
  ()
    "Returns the tag describing the Clojure project. Must be called
within the project.clj buffer."
  (do* ((tags (semantic-fetch-tags) (cdr tags))
       (tag (car tags) (car tags)))
      ((string= (car tag) "project") 
       tag))) 

(defun wisent-clojure-find-project-deps
  (ptag)
  "Returns the list of tags describing the project dependencies vector."
  (let ((properties (car (cdaddr ptag))))
    (do* ((tags properties (cdr tags))
          (tag (car tags) (car tags)))
        ((and (listp tag) (string= (car tag) ":dependencies"))
         (cadr tags)))))

(defun wisent-clojure-ast-parse
  (ast)
  "Parse the semantic AST and returns the content of
the Clojure data as an ELisp object."
  (let ((type (cadr ast)))
    (cond ((eq type 'vector) 
           (mapcar 'wisent-clojure-ast-parse (cadr (caddr ast))))
          ((eq type 'symbol)
           (car ast))
          ((eq type 'string)
           (car ast)))))

(defun wisent-clojure-project-dependencies
  ()
  "Returns a list of lists representing the project dependencies."
  (when (string-match "project.clj$" (buffer-file-name))
    (let* ((ptag (wisent-clojure-find-project-tag))
           (depsdef (wisent-clojure-find-project-deps ptag))
           (deps (wisent-clojure-ast-parse depsdef)))
      deps)))
