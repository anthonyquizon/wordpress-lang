#lang racket 

(require (prefix-in p: "parameter.rkt")
         (for-syntax (prefix-in p: "parameter.rkt"))
         (for-syntax threading))

(provide (all-defined-out))

(module+ test
  (require rackunit))

(define-syntax-rule (name x)
  (let* ([props (p:current-properties)]
         [props^ (struct-copy p:properties props 
                              [name x]
                              [id (string-replace x " " "-")])])
    (p:current-properties props^)))

(define-syntax-rule (url p)
  (let* ([props (p:current-properties)]
         [props^ (struct-copy p:properties props [url p])])
    (p:current-properties props^)))

(define-syntax-rule (path p)
  (let* ([props (p:current-properties)]
         [props^ (struct-copy p:properties props [path p])])
    (p:current-properties props^)))

(define-syntax-rule (permalinks p)
  (let* ([props (p:current-properties)]
         [props^ (struct-copy p:properties props [permalinks p])])
    (p:current-properties props^)))

;;; TODO create macro to match struct values
(define-syntax-rule (admin xs ...)
  (let* ([f (lambda [x acc] 
              (match x
                [`(user ,v) (struct-copy p:admin acc [user v])]
                [`(pass ,v) (struct-copy p:admin acc [pass v])]
                [`(email ,v) (struct-copy p:admin acc [email v])]))]
         [props (p:current-properties)]
         [admin (foldl f (p:properties-admin props) '(xs ...))]
         [props^ (struct-copy p:properties props [admin admin])])
    (p:current-properties props^)))

(define-syntax-rule (database xs ...)
  (let* ([f (lambda [x acc] 
              (match x
                [`(host ,v) (struct-copy p:database acc [host v])]
                [`(name ,v) (struct-copy p:database acc [name v])]
                [`(user ,v) (struct-copy p:database acc [user v])]
                [`(pass ,v) (struct-copy p:database acc [pass v])]))]
         [props (p:current-properties)]
         [db (foldl f (p:properties-database props) '(xs ...))]
         [props^ (struct-copy p:properties props [database db])])
    (p:current-properties props^)))

(define-syntax-rule (theme xs ...)
  (let* ([f (lambda [x acc] 
              (match x
                [`(src ,v) (struct-copy p:theme acc [src v])]))]
         [props (p:current-properties)]
         [theme (foldl f (p:properties-theme props) '(xs ...))]
         [props^ (struct-copy p:properties props [theme theme])])
    (p:current-properties props^)))

(define-syntax-rule (plugins xs ...)
  (let* ([props (p:current-properties)]
         [props^ (struct-copy p:properties props [plugins '(xs ...)])])
    (p:current-properties props^)))


(define-for-syntax 
  (match-id id)
  (define props (p:current-properties))
  (case id 
    ['name (p:properties-name props)]
    ['id (p:properties-id props)]
    ['path (p:properties-path props)]
    ['permalinks (p:properties-permalinks props)]
    ['admin (p:properties-admin props)]
    ['plugins (p:properties-plugins props)]
    ['database (p:properties-database props)]
    ['theme (p:properties-theme props)]
    ['theme-src (~> props p:theme-src p:properties-theme )]
    ['theme-dst (format "~a/wp-content/themes/~a" (p:properties-id props))]
    ['wp-content (format "~a/wp-content" (p:properties-path props))]
    ['--path (format "--path=~a" (p:properties-path props))]
    ['--url (format "--url=~a" (p:properties-url props))]
    ['--title (format "--title=~a" (p:properties-name props))]
    ['--admin_user (format "--admin_user=~a" (~> props p:properties-admin p:admin-user))]
    ['--admin_pass (format "--admin_password=~a" (~> props p:properties-admin p:admin-pass))]
    ['--admin_email (format "--admin_email=~a" (~> props p:properties-admin p:admin-email))]
    ['--dbhost (format "--dbhost=~a" (~> props p:properties-database p:database-host))]
    ['--dbname (format "--dbname=~a" (~> props p:properties-database p:database-name))]
    ['--dbuser (format "--dbuser=~a" (~> props p:properties-database p:database-user))]
    ['--dbpass (format "--dbpass=~a" (~> props p:properties-database p:database-pass))]
    [else null]))

(define-for-syntax 
  (match-ids ids) 
  (map match-id (syntax->datum ids)))

(define-syntax (with-config stx)
    (syntax-case stx ()
      [(_ (id ...) xs ...)
       (with-syntax  
         ([(id-vals ...) (match-ids #'(id ...))])
       #`(begin
           (define id id-vals) ...
           xs ...
           ))]))

(module+ test
  )
