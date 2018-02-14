#lang racket

(require shell/pipeline
         (prefix-in p: "parameter.rkt")
         (prefix-in s: "syntax.rkt"))

(provide build 
         setup-files
         setup-db
         setup-install
         setup-theme
         setup-plugins)

(define ! run-pipeline)

(define (build)
  (setup-files)
  (setup-db)
  (setup-install)
  (setup-theme)
  (setup-plugins))

(define (setup-files)
  (s:with-config (path --path)
   (! `(rm -rf ,path))
   (! `(wp core download ,--path))))

(define (setup-db)
  (s:with-config (--path --dbhost --dbname --dbpass --dbuser)
    (! `(wp config create ,--path ,--dbhost ,--dbname ,--dbuser ,--dbpass))))

(define (setup-install)
  (s:with-config (permalinks --path --url --title --admin_user --admin_pass --admin_email)
    (! `(wp core install ,--path ,--url ,--title ,--admin_user ,--admin_pass ,--admin_email))
    (! `(wp rewrite structure ,permalinks ,--path))))

(define (setup-plugins)
  (s:with-config (wp-content plugins --path))
    (for-each
      (lambda [p]
        (let ([plugin-src (format "./plugins/~a" p)]
              [plugin-dst (format "~a/plugins" wp-content)])
         (if (directory-exists? plugin-src)
           (! `(cp -r ,plugin-src ,plugin-dst))
           (! `(wp plugin install ,p ,--path)))
         (! `(wp plugin activate ,p ,--path)))) 
      plugins))

(define (setup-theme)
  (s:with-config (id --path theme-src theme-dst)
    (! `(rm -rf ,theme-dst))
    (! `(cp -r ,theme-src ,theme-dst))
    (! `(wp theme activate ,id ,--path))))

