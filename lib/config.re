
module J = Yojson;

type theme_config = {
  name: string,
  src: string
};

type posts_config = {
  json: string,
  uploads: string
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
  theme: theme_config,
  posts: posts_config
};

module Decode = {
  let theme json => 
    J.Basic.Util.{
      name: json |> member "name" |> to_string,
      src: json |> member "src" |> to_string /* TODO delete */
    };

  let posts json => 
    J.Basic.Util.{
      json: json |> member "json" |> to_string,
      uploads: json |> member "uploads" |> to_string /* TODO delete */
    };

  let db json => 
    J.Basic.Util.{
      host: json |> member "host" |> to_string,
      port: json |> member "port" |> to_int,
      name: json |> member "name" |> to_string,
      user: json |> member "user" |> to_string,
      pass: json |> member "pass" |> to_string,
    };

  let admin json => 
    J.Basic.Util.{
      user: json |> member "user" |> to_string,
      pass: json |> member "pass" |> to_string,
      email: json |> member "email" |> to_string
    };
  
  let config json => 
    J.Basic.Util.{
      path: json |> member "path" |> to_string,
      url: json |> member "url" |> to_string,
      title: json |> member "title" |> to_string,
      admin: json |> member "admin" |> admin,
      db: json |> member "db" |> db,
      theme: json |> member "theme" |> theme,
      posts: json |> member "posts" |> posts
    };
};

let parse file => {
  J.Basic.from_file file |> Decode.config;
};

