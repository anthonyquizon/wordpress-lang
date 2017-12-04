# Wordpress DSL


## TODO
* copy client js after build/update
* uploads
  * upload database
  * upload uploads folder

## WP Language Examples
### Install
```
# comment
theme of
  name: "theme-name"
  path: "./theme/"

db of
  Host: ""
  Name: ""
  User: ""
  Pass: ""

run in "../webroot"
  create db
  plugin "wordpress-importer"
  plugin "post-types-order"
  theme theme

```

### Remote Content Sync
```
# comment
theme of
  name: "theme-name"
  path: "./theme/"

db of
  Host: "host"
  Name: "name"
  User: <input> # do not save secret credentials in script
  Pass: <input> # prompt user instead

# TODO sync
```

### Content Generation Example
```
db of
  Host: "host"
  Name: "name"
  User: <input>
  Pass: <input>

# TODO sync

# TODO number meta

```

### Admin JSON serialization / post 

### Server side react rendering


