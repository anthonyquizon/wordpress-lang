#lang s-exp wordpress

(path "./output/webroot")

#|
(db
  [host ""]
  [name ""]
  [user <input>]
  [pass <input>])

(theme
  [name "theme-name"]
  [path "./theme/"]
  [post_per_page, 9999]
  [scripts "js/app.dist.js"])

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
