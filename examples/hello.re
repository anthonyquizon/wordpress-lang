
let theme = "";

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
  },
  theme: {
    name: "hello",
    src: "./examples/hello"
  }
};

Lib.Wordpress.wordpress config;
