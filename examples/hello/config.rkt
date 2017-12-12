#lang s-exp wordpress

(name "hello-example")
(path "./output/webroot")

(database
  [host "localhost"]
  [name "local_hello_com"]
  [user "root"]
  [pass "root"])

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

(plugin
  "wordpress-importer"
  "post-types-order"
  "super-cache")
|#
