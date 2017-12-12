#lang racket 

(require (prefix-in p: "parameter.rkt"))
(provide (all-defined-out))

(define-syntax-rule (name p)
  (let* ([props (p:properties-param)]
         [props^ (struct-copy p:properties props [name p])])
    (p:properties-param props^)))

(define-syntax-rule (url p)
  (let* ([props (p:properties-param)]
         [props^ (struct-copy p:properties props [url p])])
    (p:properties-param props^)))

(define-syntax-rule (path p)
  (let* ([props (p:properties-param)]
         [props^ (struct-copy p:properties props [path p])])
    (p:properties-param props^)))

;;; TODO create macro to match struct values
(define-syntax-rule (admin xs ...)
  (let* ([f (lambda [x acc] 
              (match x
                [`(user ,v) (struct-copy p:admin acc [user v])]
                [`(pass ,v) (struct-copy p:admin acc [pass v])]
                [`(email ,v) (struct-copy p:admin acc [email v])]))]
         [props (p:properties-param)]
         [admin (foldl f (p:properties-admin props) '(xs ...))]
         [props^ (struct-copy p:properties props [admin admin])])
    (p:properties-param props^)))

(define-syntax-rule (database xs ...)
  (let* ([f (lambda [x acc] 
              (match x
                [`(host ,v) (struct-copy p:database acc [host v])]
                [`(name ,v) (struct-copy p:database acc [name v])]
                [`(user ,v) (struct-copy p:database acc [user v])]
                [`(pass ,v) (struct-copy p:database acc [pass v])]))]
         [props (p:properties-param)]
         [db (foldl f (p:properties-database props) '(xs ...))]
         [props^ (struct-copy p:properties props [database db])])
    (p:properties-param props^)))

;;; TODO scripts multiple arity
(define-syntax-rule (theme xs ...)
  (let* ([f (lambda [x acc] 
              (match x
                [`(posts_per_page ,v) (struct-copy p:theme acc [posts_per_page v])]
                [`(scripts ,v) (struct-copy p:theme acc [scripts v])]))]
         [props (p:properties-param)]
         [theme (foldl f (p:properties-theme props) '(xs ...))]
         [props^ (struct-copy p:properties props [theme theme])])
    (p:properties-param props^)))

(define-syntax-rule (plugins xs ...)
  (let* ([props (p:properties-param)]
         [props^ (struct-copy p:properties props [plugins '(xs ...)])])
    (p:properties-param props^)))


