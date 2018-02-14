#lang racket 

(require (prefix-in p: "parameter.rkt")
         (for-syntax (prefix-in p: "parameter.rkt"))
         threading)

(provide (all-defined-out))

(module+ test
  (require rackunit))

;;; TODO create macro to match struct values
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

(define-syntax-rule (with-props (xs ...))
  (~>> (p:current-properties) xs ...))

(define-for-syntax 
  (match-id id)
  (case id 
    ['name '(p:properties-name)]
    ['id '(p:properties-id)]
    ['path '(p:properties-path)]
    ['permalinks '(p:properties-permalinks)]
    ['admin '(p:properties-admin)]
    ['plugins '(p:properties-plugins)]
    ['database '(p:properties-database)]
    ['dbname '(p:properties-database p:database-name)]
    ['dbuser '(p:properties-database p:database-user)]
    ['dbpass '(p:properties-database p:database-pass)]
    ['dbhost '(p:properties-database p:database-host)]
    ['theme '(p:properties-theme)]
    ['theme-src '(p:properties-theme p:theme-src)]
    ['wp-content '(p:properties-path (format "~a/wp-content"))]
    ['wp-config '(p:properties-path (format "~a/wp-config.php"))]
    ['--path '(p:properties-path (format "--path=~a"))]
    ['--url '(p:properties-url (format "--url=~a"))]
    ['--title '(p:properties-name (format "--title=~a"))]
    ['--admin_user '(p:properties-admin p:admin-user (format "--admin_user=~a"))]
    ['--admin_pass '(p:properties-admin p:admin-pass (format "--admin_password=~a"))]
    ['--admin_email '(p:properties-admin p:admin-email (format "--admin_email=~a"))]
    ['--dbhost '(p:properties-database p:database-host (format "--dbhost=~a"))]
    ['--dbname '(p:properties-database p:database-name (format "--dbname=~a"))]
    ['--dbuser '(p:properties-database p:database-user (format "--dbuser=~a"))]
    ['--dbpass '(p:properties-database p:database-pass (format "--dbpass=~a"))]
    [else '(identity)]))

(define-for-syntax 
  (match-ids ids) 
  (map match-id (syntax->datum ids)))

(define-syntax (with-config stx)
    (syntax-case stx ()
      [(_ (id ...) xs ...)
       (with-syntax  
         ([(id-vals ...) (match-ids #'(id ...))])
       #`(let ([id (with-props id-vals)] ...) 
           xs ...))]))

(module+ test
  (before 
    (name "test")
    (check-equal?
      (with-config (name) name)
      "test"))

  (before 
    (path "test-path")
    (check-equal?
      (with-config (path --path) `(,path ,--path))
      '("test-path" "--path=test-path"))))

