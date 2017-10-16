
module J = Yojson;

type theme_config = {
  name: string,
  src: string
};

type posts_db_config = {
  user: string,
  host: string,
  name: string
};

type posts_ssh_config = {
  user: string,
  host: string,
  path: string
};

type posts_remote_config = {
  db: posts_db_config,
  ssh: posts_ssh_config
};

type posts_config = {
  json: string,
  uploads: string,
  remote: posts_remote_config
};

type db_config = {
  host: string,
  name: string,
  user: string,
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

  let posts_db json => 
    J.Basic.Util.{
      user: json |> member "user" |> to_string,
      host: json |> member "host" |> to_string,
      name: json |> member "name" |> to_string
    };

  let posts_ssh json => 
    J.Basic.Util.{
      user: json |> member "user" |> to_string,
      host: json |> member "host" |> to_string,
      path: json |> member "path" |> to_string
    };

  let posts_remote json => 
    J.Basic.Util.{
      db: json |> member "db" |> posts_db,
      ssh: json |> member "ssh" |> posts_ssh
    };

  let posts json => 
    J.Basic.Util.{
      json: json |> member "json" |> to_string,
      uploads: json |> member "uploads" |> to_string,
      remote: json |> member "remote" |> posts_remote
    };

  let db json => 
    J.Basic.Util.{
      host: json |> member "host" |> to_string,
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

