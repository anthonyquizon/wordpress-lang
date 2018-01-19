#lang racket
(require racket/format
         racket/match) 

(define (intersperse sep xs)
  (cond
    [(null? xs) '()]
    [(null? (cdr xs)) xs]
    [else (cons (car xs)
                (cons sep
                      (intersperse sep (cdr xs))))]))

(define (list->php sep xs)
  (define xs^ (map (curry rewrite) xs))
  (define xs^^ (intersperse sep xs^))
  (define f ((curry format) "~a"))
  (string-join (map f xs^^)))

(define (list->array_php xs)
  (format "array(~a)" (list->php "," xs)))

;;TODO parse body without (+ 1 x) != { +; 1; x; }

(define (lambda->php args body)
  (define args^ (list->php "," args))
  (define body^ (list->php ";" body))
  (format "function(~a) { ~a }" args^ body^))

(define (equal?->php a b)
  (format "~a == ~a"  (rewrite a) (rewrite b)))

(define (app->php name args)
  (format "~a(~a);" name (list->php "," args)))


(define (infix->php op a b)
  (format "(~a ~a ~a)" (rewrite a) op (rewrite b)))

(define (if->php p a)
  (format "if (~a) { ~a }" (rewrite p) (rewrite a)))

(define (if-else->php p a b)
  (format "if (~a) { ~a } else { ~a; }" (rewrite p) (rewrite a) (rewrite b)))

(define (define->php name binding)
  ;;TODO make name php safe
  (format "$~a = ~a;" name (rewrite binding)))

;;TODO pass in env 
(define (rewrite sexp)
  (match sexp
    [(list 'lambda args body) (lambda->php args body)]
    [(list 'equal? a b) (equal?->php a b)]
    [(list '== a b) (equal?->php a b)]
    [(list '+ a b) (infix->php '+ a b)]
    [(list '- a b) (infix->php '- a b)]
    [(list '* a b) (infix->php '* a b)]
    [(list '/ a b) (infix->php '/ a b)]
    [(list 'if p a) (if->php p a)]
    [(list 'if p a b) (if-else->php p a b)]
    [(list 'list xs ...) (list->array_php xs)]
    [(list 'foldl xs ...) (rewrite `(array_reduce ,@xs))]
    [(list 'define name binding) (define->php name binding)]
    [(list name args ...) (app->php name args)] ;;TODO check if symbol
    ;;TODO hashtable
    [a a]
    )
  )

;; fold -> fold_left
;; map -> fold_left . []

;; functions -> php_fn
;;  shuffle
;;  preg_replace
;;  get_field


;;eg

;;TODO tests
