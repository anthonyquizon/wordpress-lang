
let default = Lib.Config.default_config;
let config = {
  ...default,
  path: "./output/hello",
  url: "local.hello.com",
  title: "hello",
  db: {
    ...default.db,
    name: "local_hello_com",
    user: "root",
    pass: "root"
  }
};

Lib.Wordpress.wordpress config;
