# Wordpress DSL


## TODO
* copy client js after build/update
* uploads
  * upload database
  * upload uploads folder

## WP Language Example
```

# comment
as theme
  name: "<theme-name>"
  path: "./<theme>/"

as db
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

### Remote Example
```
# comment
as theme
  name: "theme-name"
  path: "./theme/"

as db
  Host: "host"
  Name: "name"
  User: <input> # do not save secret credentials in script
  Pass: <input> # prompt user instead

# TODO sync

run in "../webroot"
  create db
  plugin "wordpress-importer"
  plugin "post-types-order"
  theme theme
```

### Content Example
```
as db
  Host: "host"
  Name: "name"
  User: <input>
  Pass: <input>

# TODO sync

# TODO number meta

```
