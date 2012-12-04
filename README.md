clojure-semantic
================

Experiments with Emacs semantic.el, CEDET and Clojure.

If you want to give it a try:

* Open clojure.wy
* M-x semantic-mode
* C-c C-c
* Open clojure.el
* M-x eval-buffer

## What does work (more or less)?
### Basic variables and functions completion

Open a clojure file and try:

* M-x semantic-complete-jump

### Speedbar 

Add the following line to your ~/.emacs.d/init.el file:

    (eval-after-load "speedbar"
      (lambda ()
        (speedbar-add-supported-extension ".clj")
        (speedbar-add-supported-extension ".cljs")))

Open a clojure file and try:

* M-x speedbar
