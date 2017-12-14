#lang racket

(require racket/cmdline
         (prefix-in s: "syntax.rkt")
         (prefix-in p: "parameter.rkt")
         (prefix-in e: "execute.rkt"))

(provide (except-out 
           (all-from-out racket) #%module-begin)
         (rename-out 
           [module-begin #%module-begin])
         (rename-out 
           [s:name name]
           [s:url url]
           [s:path path]
           [s:admin admin]
           [s:database database]
           [s:theme theme]
           [s:plugins plugins]))

(define-syntax-rule (module-begin expr ...)
  (#%module-begin
    expr ...
    ;;TODO command line args
    ;;     build
    ;;     theme
    ;;     watch theme
    (e:build)))



