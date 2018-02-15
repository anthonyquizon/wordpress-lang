#lang racket

(require shell/pipeline
         (prefix-in db: db)
         (prefix-in h: "helpers.rkt")
         (prefix-in p: "parameter.rkt")
         (prefix-in s: "syntax.rkt"))

(provide build 
         create-test-db
         setup-files
         setup-db
         setup-install
         setup-theme
         setup-plugins)

(define ! run-pipeline)
(define current-id (make-parameter 0))

(define (build)
  (setup-files)
  (setup-db)
  (setup-install)
  (setup-theme)
  (setup-plugins))
  
(define (create-test-db posts)
  (s:with-config (--path)
    (replace-config)
    (! `(wp db reset --yes ,--path)) 
    (setup-install)
    (insert! posts)))

(define (replace-config)
  (s:with-config (wp-config)
    (! `(mv ,wp-config ,(format "~a.bak" wp-config)))
    (setup-db)))

(define (restore-install)
  (s:with-config (wp-config)
    (! `(rm ,wp-config))
    (! `(mv ,(format "~a.bak" wp-config)  ,wp-config))))

(define (setup-files)
  (s:with-config (path --path)
   (! `(rm -rf ,path))
   (! `(wp core download ,--path))))

(define (setup-db-mysql)
  (s:with-config (dbname dbuser dbpass dbhost)
    (define mysql-conn
      (db:mysql-connect #:user dbuser
                        #:server dbhost
                        #:password dbpass))

    (define query (format "CREATE DATABASE IF NOT EXISTS ~a" dbname))
    (db:query-exec mysql-conn query)))

(define (setup-db)
  (s:with-config (--path --dbhost --dbname --dbpass --dbuser)
    (setup-db-mysql)
    (! `(wp config create ,--path ,--dbhost ,--dbname ,--dbuser ,--dbpass))))

(define (setup-install)
  (s:with-config (permalinks --path --url --title --admin_user --admin_pass --admin_email)
    (! `(wp core install ,--path ,--url ,--title ,--admin_user ,--admin_pass ,--admin_email))
    (! `(wp rewrite structure ,permalinks ,--path))))

(define (setup-plugins)
  (s:with-config (wp-content plugins --path)
    (for-each
      (lambda [p]
        (let ([plugin-src (format "./plugins/~a" p)]
              [plugin-dst (format "~a/plugins" wp-content)])
          (if (directory-exists? plugin-src)
            (! `(cp -r ,plugin-src ,plugin-dst))
            (! `(wp plugin install ,p ,--path)))
          (! `(wp plugin activate ,p ,--path)))) 
      plugins)))

(define (setup-theme)
  (s:with-config (id path --path theme-src)
    (define theme-dst (format "~a/wp-content/themes/~a" path id))
    (! `(rm -rf ,theme-dst))
    (! `(cp -r ,theme-src ,theme-dst))
    (! `(wp theme activate ,id ,--path))))

(define (post-prop->flag props key default)
  (define prop (hash-ref props key default))
  (h:set-flag (format "post_~a" key) prop))


(define (insert! posts) 
  (s:with-config (--path)
    (define (f props)
      (define --post-type (post-prop->flag props 'type "post"))
      (define --post-title (post-prop->flag props 'title "post title"))
      (define --post-status (post-prop->flag props 'status "publish"))
      (define --post-content (post-prop->flag props 'content "lorem ipsum content"))
      (define --post-excerpt (post-prop->flag props 'excerpt "lorem ipsum excerpt"))
      (define cmd `(wp post create 
                       ,--path 
                       ,--post-type 
                       ,--post-title 
                       ,--post-status 
                       ,--post-content 
                       ,--post-excerpt))

      (displayln cmd) 
      (! cmd))

    (for-each f posts)))

