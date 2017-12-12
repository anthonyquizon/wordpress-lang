#lang racket

(provide (except-out (all-from-out racket)
                     #%module-begin)
         (rename-out [module-begin #%module-begin]))

(struct properties 
  (path 
    
    )
  )

;;syntax -> return function with wp as input

(define-syntax-rule (module-begin expr ...)
  (#%module-begin
    (display '(expr ...))
   ;;TODO run all props
   ;;TODO run wp 
   ))
