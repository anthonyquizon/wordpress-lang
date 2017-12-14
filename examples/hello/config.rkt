#lang s-exp wordpress

(name "Hello Example")
(url "Hello Example")
(path "./output")

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
  [src "./theme"])

;; NOTE: searches first in ./plugins folder 
;;       then tries to download via wp cli
(plugins
  "wordpress-importer"
  "wp-super-cache")

