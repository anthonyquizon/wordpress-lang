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
  [src "./theme"] ;;copy source files first
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
  ;(group 
    ;[key "acf-group"]
    ;[title "ACF Title"]
    ;[location 
      ;(== post_type "post")]
    ;[fields
      ;(text 
        ;[key "field_1232121421"] 
        ;[label "Field Foo"] 
        ;[name "field_foo"])]
      ;(image 
        ;[key "field_23421312"] 
        ;[label "Field Bar"] 
        ;[name "field_bar"])))

;; NOTE: searches first in ./plugins folder 
;;       then tries to download via wp cli
(plugins
  "wordpress-importer"
  "wp-super-cache")

