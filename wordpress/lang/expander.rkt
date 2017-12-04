
;; variable 

;; create [path] [db]
  ;; rm
  ;; mkdir
  ;; config
  ;; install
  ;; db drop
  ;; db create

;; uploads
  
;; plugin
  ;; activate

;; theme 
  ;; run generator to tmp output
  ;; cp tmp into webroot/wp-content/theme
  ;; activate

;; migrate
  ;; search and replace site url
#|

|#


#lang br/quicklang

(define-macro (jsonic-module-begin PARSE-TREE)
              #'(#%module-begin
                 (display "hello")))

(provide (rename-out [jsonic-module-begin #%module-begin]))

