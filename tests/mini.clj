;   Copyright (c) Rich Hickey. All rights reserved.
;   The use and distribution terms for this software are covered by the
;   Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
;   which can be found in the file epl-v10.html at the root of this distribution.
;   By using this software in any fashion, you are agreeing to be bound by
;   the terms of this license.
;   You must not remove this notice, or any other, from this software.

(ns ^{:doc "The core Clojure language."
       :author "Rich Hickey"}
  clojure.core)

(def unquote)
(def unquote-splicing)

;; (def
;;  ^{:arglists '([& items])
;;    :doc "Creates a new list containing the items."
;;    :added "1.0"}
;;   list (. clojure.lang.PersistentList creator))

;; (def
;;  ^{:arglists '([x seq])
;;     :doc "Returns a new seq where x is the first element and seq is
;;     the rest."
;;    :added "1.0"
;;    :static true}

;;  cons (fn* ^:static cons [x seq] (. clojure.lang.RT (cons x seq))))


(defn a [])

(deftest b [])

(defmacro x [])

(defn- p [])
