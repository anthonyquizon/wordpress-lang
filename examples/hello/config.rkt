#lang s-exp wordpress

(name "Hello Example")
(url "Hello Example")
(path "./output")

;;TODO author
;;TODO description
;;TODO license
;;TODO text domain
;;TODO version

(admin
  [user "admin"]
  [pass "admin"]
  [email "admin@admin.com"])

(database
  [host "127.0.0.1"]
  [name "local_hello_com"]
  [user "root"]
  [pass "root"]
  ;;TODO import cached db
  )

(theme
  [posts_per_page 9999]
  [scripts "js/app.dist.js"])

#|
(admin
  [remove_from_menu 
    "jetpack"
    "page"
    "comments"
    "themes"
    "plugins"
    "tools"
    "options-general"]
  [remove_from_post "editor"]
  [scripts "js/admin.dist.js" ]
  [metabox "Images" "post" ]
  [metabox "Stories" "post"]
  [metadata
    "meta-foo"
    "meta-bar"
    "meta-baz-n"
    ;;looped meta - 0 ... meta-baz-n 
    ("meta-baz" of "meta-baz-n")])

(api
  
  )
|#

;(acf
  ;[group 
    ;[id "acf-group"]
    ;[title "ACF Title"]
    ;[fields
      ;(text 
        ;[id "field_1232121421"] 
        ;[label "Field Foo"] 
        ;[name "field_foo"])]])

;; search first in ./plugins folder 
;; else try to download via wp cli

(plugins
  "wordpress-importer"
  "wp-super-cache")

