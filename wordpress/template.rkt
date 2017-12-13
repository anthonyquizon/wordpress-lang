#lang racket

(provide read-syntax)

(define (read-syntax path port)
  (define tpl (port->string port))
  (define module-datum `(module template racket
                          (provide template)
                          (define template ,tpl)))
  (datum->syntax #f module-datum))


