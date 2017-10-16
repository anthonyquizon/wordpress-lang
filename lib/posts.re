open Shexp_process.Infix;

module J = Yojson;
module S = Shexp_process;

type key = string;
type url = string;

type meta = {
  key: string,
  value: string,
  file: bool
};

type post = {
  title: string,
  meta: list meta
};

module Decode = {
  let meta json => 
    J.Basic.Util.{
      key: json |> member "key" |> to_string,
      value: json |> member "value" |> to_string,
      file: json |> member "file" |> to_bool
    };

  let post json => 
    J.Basic.Util.{
      title: json |> member "title" |> to_string,
      meta: json |> member "meta" |> to_list |> List.map meta
    };
};

module WXR = {
  let media x => {
    Cow.Xml.(
      tag "item" (list [
        tag "wp:post_type" (string "attachment"),
        tag "wp:attachment_url" (string ("http://local.hello.com/wp-content/uploads/" ^ x)),
        tag "wp:post_meta" (list [
          tag "wp:meta_key" (string "_wp_attached_file"),
          tag "wp:meta_value" (string x)
        ])
      ])
    );
  };

  let meta x => {
    Cow.Xml.(
      tag "wp:postmeta" (list [
        tag "wp:meta_key" (string x.key),
        tag "wp:meta_value" (string x.value)
      ])
    );
  };

  let post x => {
    Cow.Xml.(
        tag "item" 
          (List.append [
            tag "title" (string x.title),
            tag "wp:status" (string "publish"),
            tag "wp:post_type" (string "post")
          ] (List.map meta x.meta) |> list));
  };

  let posts ps ms => {
    let attrs = [
      ("version", "2.0"),
      ("xmlns:wp", "http://wordpress.org/export/1.2/")
    ];
    Cow.Xml.(
        tag "rss" attrs::attrs (list [
          tag "channel" (list [
            tag "wp:wxr_version" (float 1.2),
            list (List.append 
              (List.map post ps) 
              (List.map media ms))
          ])]));
  };
};

let contents path => {
  let excludes = [ ".DS_Store" ];
  let excludeFn x => not (List.fold_left (fun acc x' => x == x' || acc) false excludes); 

  let rec contents' path => 
    switch (Sys.is_directory path) {
      | true => Sys.readdir path
        |> Array.to_list
        |> List.filter excludeFn 
        |> List.map (Filename.concat path)
        |> List.map contents'
        |> List.flatten
        | _ => [path]
    };

  contents' path;
};

let write_tmp str => {
  let tmp = Filename.temp_file "wordpress-upload" ".xml";
  let out = open_out tmp;
  Printf.fprintf out "%s" str;
  close_out out; 

  tmp;
};

let upload (config:Config.config) => {
  let remote = config.posts.remote;

  let posts = J.Basic.from_file config.posts.json 
    |> J.Basic.Util.member "posts" 
    |> J.Basic.Util.to_list
    |> List.map Decode.post;
  
  let r = Str.regexp config.posts.uploads;
  let media = contents config.posts.uploads 
           |> List.map (Str.replace_first r "");

  let wxr = WXR.posts posts media |> Cow.Xml.to_string;
  let tmp_file = write_tmp wxr;

  S.eval (
    S.run "cp" ["-r", config.posts.uploads, config.path ^ "/wp-content/uploads/"] >>
    S.run "wp" ["import", tmp_file, "--authors=create", "--path=" ^ config.path] >>
    S.run "scp" [ "-r", config.posts.uploads, remote.ssh.user ^ "@" ^ remote.ssh.host ^ ":" ^ remote.ssh.path ]
    );

  S.eval(
    S.run "mysqldump"  ["--host=" ^ config.db.host, "--user=" ^ config.db.user, "--password=" ^ config.db.pass, config.db.name, "wp_posts", "wp_postmeta"] 
      |- S.run "mysql" ["--host="^ remote.db.host, "--user=" ^ remote.db.user, "-p", remote.db.name]);
};

