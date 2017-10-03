
type theme_config = {
  name: string
};

type db_config = {
  host: string,
  name: string,
  user: string,
  port: int,
  pass: string
};

type admin_config = {
  user: string,
  pass: string,
  email: string
};

type config = {
  path: string,
  url: string,
  title: string,
  
  admin: admin_config,
  db: db_config,
  theme: theme_config
};

let default_config = {
  path: "./webroot",
  url: "localhost",
  title: "wordpress",
  admin: {
    user: "admin",
    pass: "admin",
    email: "admin@admin.com"
  },
  db: {
    host: "localhost",
    port: 3306,
    name: "local_wordpress_db",
    user: "root",
    pass: "root"
  },
  theme: {
    name: "hello"
  }
};

