#lang s-exp wordpress

(name "Hello Example")
(url "local.hello.com")
(path "./output")

(permalinks "/post/%postname%/")

(admin
  [user "admin"]
  [pass "admin"]
  [email "admin@admin.com"])

(database
  [host "127.0.0.1"]
  [name "local_hello_com"]
  [user "root"]
  [pass "root"])

;;TODO copy uploads

(theme
  [src "./theme"])

;; NOTE: searches first in ./plugins folder 
;;       then tries to download via wp cli
(plugins
  ["wordpress-importer" "./plugins/wordpress-importer"]
  "wp-super-cache")

