#lang racket

(require rackunit
         rackunit/text-ui
         shell/pipeline
         (prefix-in p: "parameter.rkt"))

(provide setup-db)

(define ! run-pipeline)

(define (setup-db)
  (define props (p:properties-param))
  (define path (p:properties-path props))
  (define database (p:properties-database props))
  (define --path (string-append "--path" path))
  (define --dbhost (string-append "--dbhost=" (p:database-host database)))
  (define --dbname (string-append "--dbname=" (p:database-name-test database)))
  (define --dbuser (string-append "--dbuser" (p:database-user database)))
  (define --dbpass (string-append "--dbpass" (p:database-pass database)))

  (displayln --path)
  (! `(wp config create ,--path ,--dbhost ,--dbname ,--dbuser ,--dbpass))
  (! `(wp db reset --yes ,--path))

  ;;add posts
  )

;;TODO clean up; make DRY
(define (restore-db)
  (define props (p:properties-param))
  (define path (p:properties-path props))
  (define database (p:properties-database props))
  (define --path (string-append "--path" path))
  (define --dbhost (string-append "--dbhost=" (p:database-host database)))
  (define --dbname (string-append "--dbname=" (p:database-name database)))
  (define --dbuser (string-append "--dbuser" (p:database-user database)))
  (define --dbpass (string-append "--dbpass" (p:database-pass database)))

  (! `(wp config create ,--path ,--dbhost ,--dbname ,--dbuser ,--dbpass)))
