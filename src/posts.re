open Shexp_process.Infix;

module J = Yojson;
module S = Shexp_process;

type key = string;
type url = string;

type meta = {
  key: string,
  value: string,
  file: option bool
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
      file: json |> member "file" |> to_bool_option
    };

  let post json => 
    J.Basic.Util.{
      title: json |> member "title" |> to_string,
      meta: json |> member "meta" |> to_list |> List.map meta
    };
};

module WXR = {
  let mediaIdOffs = 100;

  let isFile m => switch m.file {
    | Some true => true
    | _ => false
  };

  let matchMedia ms m => {
    List.find (fun (_, value) => m.value == value) ms;
  };

  let media url (i, value) => {
    Cow.Xml.(
      tag "item" (list [
        tag "wp:post_type" (string "attachment"),
        tag "wp:post_id" (int i),
        tag "wp:attachment_url" (string (url ^ "/wp-content/uploads/" ^ value)),
        tag "wp:post_meta" (list [
          tag "wp:meta_key" (string "_wp_attached_file"),
          tag "wp:meta_value" (string value)
        ])
      ])
    );
  };

  let meta ms x => {
    Cow.Xml.(
      tag "wp:postmeta" (list [
        tag "wp:meta_key" (string x.key),
        tag "wp:meta_value" (switch (isFile x) {
          | false => (string x.value)
          | true => {
            let (i, _) = matchMedia ms x;
            int i;
          }
          })
      ]) 
    );
  };

  let post ms x => {
    Cow.Xml.(
        tag "item" 
          (List.append [
            tag "title" (string x.title),
            tag "wp:status" (string "publish"),
            tag "wp:post_type" (string "post")
          ] (List.map (meta ms) x.meta) |> list));
  };

  let collectMedia ps => {
    List.fold_left (fun acc p => {
      let metas = List.filter isFile p.meta 
               |> List.mapi (fun i x => (i + mediaIdOffs, x.value));

      List.append acc metas;
    }) [] ps; 
  };

  let posts ps url => {
    let ms = collectMedia ps;
    let xmlMedia = List.map (media url) ms;
    let xmlPosts = List.map (post ms) ps;
    let attrs = [
      ("version", "2.0"),
      ("xmlns:wp", "http://wordpress.org/export/1.2/")
    ];
    Cow.Xml.(
        tag "rss" attrs::attrs (list [
          tag "channel" (list [
            tag "wp:wxr_version" (float 1.2),
            list (List.append xmlMedia xmlPosts)
            ])
        ]));
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

module Local = {
  let upload (config:Config.config) => {
    let posts = J.Basic.from_file config.posts.json 
      |> J.Basic.Util.member "posts" 
      |> J.Basic.Util.to_list
      |> List.map Decode.post;

    let wxr = WXR.posts posts config.posts.url |> Cow.Xml.to_string;
    let tmp_file = write_tmp wxr;

    S.eval (
        S.run "cp" ["-r", config.posts.uploads, config.path ^ "/wp-content/uploads/"] >>
        S.run "wp" ["import", tmp_file, "--authors=create", "--path=" ^ config.path]);
  };
};

module Remote = {
  let upload (config:Config.config) => {
    let remote = config.posts.remote;

    let posts = J.Basic.from_file config.posts.json 
      |> J.Basic.Util.member "posts" 
      |> J.Basic.Util.to_list
      |> List.map Decode.post;

    let r = Str.regexp config.posts.uploads;
    let wxr = WXR.posts posts remote.url |> Cow.Xml.to_string;
    let tmp_file = write_tmp wxr;

    S.eval (
        S.run "cp" ["-r", config.posts.uploads, config.path ^ "/wp-content/uploads/"] >>
        S.run "wp" ["import", tmp_file, "--authors=create", "--path=" ^ config.path] >>
        S.run "scp" [ "-r", config.posts.uploads, remote.ssh.user ^ "@" ^ remote.ssh.host ^ ":" ^ remote.ssh.path ^ "/wp-content/uploads" ]);

    S.eval(
        S.run "mysqldump"  ["--host=" ^ config.db.host, "--user=" ^ config.db.user, "--password=" ^ config.db.pass, config.db.name, "wp_posts", "wp_postmeta"] 
        |- S.run "mysql" ["--host="^ remote.db.host, "--user=" ^ remote.db.user, "-p", remote.db.name]);
  };
};
