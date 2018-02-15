#lang racket

(require rackunit
         rackunit/text-ui
         shell/pipeline
         net/http-client
         threading
         json
         (prefix-in p: "parameter.rkt")
         (prefix-in s: "syntax.rkt"))

(provide check-files-equal?
         setup-dir
         set-flag
         endpoint
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
  (p:current-properties p:default-properties))

(define (setup-dir dir)
  (run-pipeline `(rm -r ,dir)) 
  (run-pipeline `(mkdir -p ,dir)))

(define (endpoint uri #:data [data #f] #:method [method #"GET"])
  (s:with-config (host)
     (define-values (status headers in)
       (http-sendrecv host uri
                      #:method method
                      #:data data))
     ;;TODO display error
     (displayln (port->string in))
     (~> in port->string string->jsexpr)))

(define (set-flag flag value)
  (string->symbol (format "--~a='~a'" flag value)))

