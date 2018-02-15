#lang racket

(require shell/pipeline
         (prefix-in db: db)
         (prefix-in h: "helpers.rkt")
         (prefix-in p: "parameter.rkt")
         (prefix-in s: "syntax.rkt"))

(provide build 
         create-test-db
         replace-config
         restore-config
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
  

(define (clean-initial-posts)
  (s:with-config (--path) 
    (displayln "deleting hello world post")
    (! `(wp post delete 1 ,--path))))

(define (create-test-db posts terms)
  (s:with-config (--path)
    (replace-config)
    (! `(wp db reset --yes ,--path)) 
    (setup-install)
    (setup-theme)
    (setup-plugins)
    (clean-initial-posts)
    (insert-posts posts)
    (insert-terms terms)))


(define (replace-config)
  (s:with-config (wp-config)
    (! `(mv ,wp-config ,(format "~a.bak" wp-config)))
    (setup-db)))

(define (restore-config)
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

(define (install-plugin plugin)
  (s:with-config (--path wp-content)
    (define dst (format "~a/plugins" wp-content))

    (match plugin
      [(list name src) 
       (if (directory-exists? src)
         (begin 
           (! `(cp -r ,src ,dst))
           (! `(wp plugin activate ,name ,--path)))
         (displayln (format "Cannot find ~a in ~a" name src)))]
      [name 
        (! `(wp plugin install ,name ,--path)) 
        (! `(wp plugin activate ,name ,--path))])))

(define (setup-plugins)
  (s:with-config (plugins)
    (for-each install-plugin plugins)))

(define (setup-theme)
  (s:with-config (id path --path theme-src)
    (define theme-dst (format "~a/wp-content/themes/~a" path id))
    (! `(rm -rf ,theme-dst))
    (! `(cp -r ,theme-src ,theme-dst))
    (! `(wp theme activate ,id ,--path))))

(define (post-prop->flag props key default)
  (define prop (hash-ref props key default))
  (h:set-flag (format "post_~a" key) prop))

(define (insert-posts posts) 
  (s:with-config (--path)
    (define (f props)
      (define --import_id (format "--import_id=~a" (hash-ref props 'ID "1234")))
      (define --post_type (post-prop->flag props 'type "post"))
      (define --post_title (post-prop->flag props 'title "post title"))
      (define --post_status (post-prop->flag props 'status "publish"))
      (define --post_tax_input (post-prop->flag props 'tax_input ""))
      (define --post_content (post-prop->flag props 'content "lorem ipsum content"))
      (define --post_excerpt (post-prop->flag props 'excerpt "lorem ipsum excerpt"))
      (define cmd `(wp post create 
                       ,--path 
                       ,--import_id
                       ,--post_type 
                       ,--post_title 
                       ,--post_tax_input
                       ,--post_status 
                       ,--post_content 
                       ,--post_excerpt))

      (displayln cmd) 
      (! cmd))

    (for-each f posts)))

(define (insert-terms terms) 
  (s:with-config (--path)
    (define (f term)
      (define ID (hash-ref term 'ID))
      (define taxonomy (hash-ref term 'taxonomy))
      (define name (hash-ref term 'name))
      (define cmd `(wp post term add ,--path ,ID ,taxonomy ,name))

      (displayln cmd) 
      (! cmd))

    (for-each f terms)))
