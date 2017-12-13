#lang racket

(require shell/pipeline
         (prefix-in p: "parameter.rkt"))

;; reference: https://github.com/aqui18/wordpress-lang/blob/76180de1ecde3d0c73013f0382baf835432cc07d/src/re/install.re

(provide run)

(define (run)
  (let* ([! run-pipeline]
         [props (p:properties-param)]
         [name (p:properties-name props)]
         [path (p:properties-path props)]
         [admin (p:properties-admin props)]
         [plugins (p:properties-plugins props)]
         [database (p:properties-database props)]
         [wp-content (string-append path "/wp-content")]
         [--path (string-append "--path=" path )]
         [--url (string-append "--url=" (p:properties-url props))]
         [--title (string-append "--title=" (p:properties-name props))]
         [--admin_user (string-append "--admin_user=" (p:admin-user admin))]
         [--admin_pass (string-append "--admin_password=" (p:admin-pass admin))]
         [--admin_email (string-append "--admin_email=" (p:admin-email admin))]
         [--dbhost (string-append "--dbhost=" (p:database-host database))]
         [--dbname (string-append "--dbname=" (p:database-name database))]
         [--dbuser (string-append "--dbuser=" (p:database-user database))]
         [--dbpass (string-append "--dbpass=" (p:database-pass database))])
    (! `(rm -rf ,path))
    (! `(wp core download ,--path))
    (! `(wp config create ,--path ,--dbhost ,--dbname ,--dbuser ,--dbpass))
    (! `(wp db reset --yes ,--path))
    (! `(wp core install ,--path ,--url ,--title ,--admin_user ,--admin_pass ,--admin_email))

    ;;TODO build templates
    ;;TODO active theme

    (for-each
      (lambda [p]
        (let ([plugin-src (string-append "./plugins/" p)]
              [plugin-dst (string-append wp-content "/plugins")])
         (if (directory-exists? plugin-src)
           (! `(cp -r ,plugin-src ,plugin-dst))
           (! `(wp plugin install ,p ,--path)))
         (! `(wp plugin activate ,p ,--path)))) 
      plugins)))
