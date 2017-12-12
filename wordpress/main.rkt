#lang racket

(provide (except-out (all-from-out racket)
                     #%module-begin)
         (rename-out 
           [module-begin #%module-begin]
           [name-syntax name]
           [path-syntax path]
           [database-syntax database]
           [theme-syntax theme]))

(struct theme
  (posts_per_page scripts))

(struct database
  (host name user pass))

(struct properties 
  (name path database theme))

(define properties-param 
  (make-parameter 
    (properties 
      "" 
      ""
      (database "" "" "" "")
      (theme 30 "")
      )))

(define-syntax-rule (name-syntax p)
  (let* ([props (properties-param)]
         [props^ (struct-copy properties props [name p])])
    (properties-param props^)))

(define-syntax-rule (path-syntax p)
  (let* ([props (properties-param)]
         [props^ (struct-copy properties props [path p])])
    (properties-param props^)))

;; TODO create macro to match struct values
(define-syntax-rule (database-syntax xs ...)
  (let* ([f (lambda [x acc] 
              (match x
                [`(host ,v) (struct-copy database acc [host v])]
                [`(name ,v) (struct-copy database acc [name v])]
                [`(user ,v) (struct-copy database acc [user v])]
                [`(pass ,v) (struct-copy database acc [pass v])]))]
         [props (properties-param)]
         [database (foldl f (properties-database props) '(xs ...))]
         [props^ (struct-copy properties props [database database])])
    (properties-param props^)))

;; TODO scripts multiple arity
(define-syntax-rule (theme-syntax xs ...)
  (let* ([f (lambda [x acc] 
              (match x
                [`(posts_per_page ,v) (struct-copy theme acc [posts_per_page v])]
                [`(scripts ,v) (struct-copy theme acc [scripts v])]))]
         [props (properties-param)]
         [theme (foldl f (properties-theme props) '(xs ...))]
         [props^ (struct-copy properties props [theme theme])])
    (properties-param props^)))

(define-syntax-rule (module-begin expr ...)
  (#%module-begin
    expr ...
     ;;TODO run all props
     ;;TODO run wp 
     (displayln "hello")
     (let ([props (properties-param)])
      (displayln (properties-path props)))))

