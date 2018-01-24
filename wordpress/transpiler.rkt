#lang racket

(require racket/format
         racket/match) 

(provide rewrite 
         php-call)

(define (intersperse sep xs)
  (string-join (map ~a xs) sep))

(define (list->php xs)
  (define xs^ (map (curry rewrite) xs))
  (intersperse "," xs^))

(define (list->array_php xs)
  (format "array(~a)" (list->php xs)))

(define (hash->array_php xs)
  (define xs^
    (map (lambda (x)
           (match-define `(,k ,v) x)
           (define v^ (rewrite v))
           (format "'~a' => ~a" k v^)) xs))
  (format "array~a" (intersperse "," xs^)))

(define (body->php xs)
  (cond
    [(null? xs) ""]
    [(null? (cdr xs)) (format "return ~a;" (rewrite (car xs)))]
    [else 
      (format "~a; ~a" (rewrite (car xs)) (body->php (cdr xs)))]))
(define (lambda->php args body)
  (define args^ (list->php args))
  (define body^ (body->php body))
  (format "function(~a) { ~a }" args^ body^))

(define (equal?->php a b)
  (format "~a == ~a"  (rewrite a) (rewrite b)))

(define (app->php name args)
  (format "~a(~a);" (rewrite name) (list->php args)))

(define (infix->php op a b)
  (format "(~a ~a ~a)" (rewrite a) op (rewrite b)))

(define (if->php p a)
  (format "if (~a) { ~a }" (rewrite p) (rewrite a)))

(define (if-else->php p a b)
  (format "if (~a) { ~a } else { ~a; }" (rewrite p) (rewrite a) (rewrite b)))

(define (define->php name binding)
  (define name^ (string-replace name "-" "_"))
  ;;add binding and name to environment
  (format "$~a = ~a;" name (rewrite binding)))

(define (define-lambda->php name args body)
  (define args^ (list->php args))
  (define body^ (body->php body))
  (format "function ~a(~a) { ~a }" name args^ body^))

(define (get->php obj key)
  (format "$~a->~a" obj key))

(define (index->php arr key)
  (format "$~a['~a']" arr key))

(define (boolean->php p)
  (if p "true" "false"))

(define (php-call name . args) 
  `(php-call ,name ,@args))

;;TODO filter -> array_values

;;TODO expand -> pass in environment to find fill in define
;; define pass first -> then others
(define (rewrite sexp)
  (match sexp
    [(list 'lambda args body ...) (lambda->php args body)]
    [(list 'equal? a b) (equal?->php a b)]
    [(list '== a b) (equal?->php a b)]
    [(list '+ a b) (infix->php '+ a b)]
    [(list '- a b) (infix->php '- a b)]
    [(list '* a b) (infix->php '* a b)]
    [(list '/ a b) (infix->php '/ a b)]
    [(list 'if p a) (if->php p a)]
    [(list 'if p a b) (if-else->php p a b)]
    [(list 'get obj key) (get->php obj key)]
    [(list 'list-ref arr key) (index->php arr key)]
    [(list 'quote xs) (list->array_php xs)]
    [(list 'list xs ...) (list->array_php xs)]
    [(list 'define (list name args ...) body ...) (define-lambda->php name args body)]
    [(list 'define name binding) (define->php name binding)]
    [(list 'php-call name args ...) #:when (symbol? name) (app->php name args)] 
    [(hash-table xs ...) (hash->array_php xs)] 
    [str #:when (string? str) (format "'~a'" str)]
    [p #:when (boolean? p) (boolean->php p)]
    ['foldl "array_reduce"]
    ['map "array_map"]
    ['displayln "echo"]
    [a a]
    ;;TODO reduce if possible
    )) 

;; lisp -> html template

(module+ tests
  ;;TODO
  )
