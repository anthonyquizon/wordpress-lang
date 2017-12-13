#lang racket

(require rackunit
         rackunit/text-ui
         shell/pipeline
         (prefix-in p: "parameter.rkt"))

(provide check-files-equal?
         setup-dir
         reset-properties)

(define (check-files-equal? a b)
  (call-with-input-file 
    a
    (lambda [in-a]
      (call-with-input-file
        b
        (lambda [in-b]
          (check-equal? 
            (port->string in-a)
            (port->string in-b)))))))

(define (reset-properties)
  (p:properties-param p:default-properties))

(define (setup-dir dir)
  (run-pipeline `(rm -r ,dir)) 
  (run-pipeline `(mkdir -p ,dir)))

