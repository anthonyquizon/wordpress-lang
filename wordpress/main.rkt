#lang racket


(require (prefix-in s: "syntax.rkt"))
(require (prefix-in p: "parameter.rkt"))

(provide (except-out 
           (all-from-out racket) #%module-begin)
         (rename-out 
           [module-begin #%module-begin])
         (rename-out 
           [s:name name]
           [s:path path]
           ;[s:database database]
           ;[s:theme theme]
           ;[s:plugins plugins] 
           )
         )

(define-syntax-rule (module-begin expr ...)
  (#%module-begin
    expr ...
     ;;TODO run all props
     ;;TODO run wp 
     (let ([props (p:properties-param)])
      (displayln (p:properties-path props)))))

