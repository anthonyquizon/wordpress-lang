open Shexp_process.Infix;

module J = Yojson;
module S = Shexp_process;

/* 
  TODO validate posts with theme build

  Read JSON -> ADT structure
  upload posts via wp
*/

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

let upload (config:Config.config) => {
  let postsJson = J.Basic.from_file config.posts.json 
    |> J.Basic.Util.member "posts" 
    |> J.Basic.Util.to_list;

  let posts = List.map Decode.post postsJson;

  /* create WXR file */


  let r = Str.regexp "Success: Created post " ;

  List.iter (fun p => {
    let postRet = S.eval (
      S.run "wp" [
        "post", 
        "create", 
        "--post_type='post'",
        "--post_title=" ^ p.title,
        "--post_status=publish",
        "--path=" ^ config.path] |- S.read_all);

    let postId = Str.replace_first r "" postRet;

    List.iter (fun m => {
      S.eval(S.run "wp" [
        "post", "meta", "set", 
        postId, m.key, m.value,
        "--path=" ^ config.path,
      ])}) p.meta;
  }) posts;

  /* upload uploads folder */
  /* upload sql post table */
  /* upload sql post meta table */
};

