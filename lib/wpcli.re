open Shexp_process;
open Shexp_process.Infix;

let new_install (config:Config.config) => {
  eval (
      run "rm" ["-rf", config.path] >>
      run "mkdir" ["-p", config.path] >>
      run "wp" ["core", "download", "--path=" ^ config.path] >> 
      /* TODO theme */
      run "wp" [
      "config", "create", 
      "--path=" ^ config.path, 
      "--dbhost=" ^ config.db.host ^ ":" ^ (string_of_int config.db.port),
      "--dbname=" ^ config.db.name,
      "--dbuser=" ^ config.db.user,
      "--dbpass=" ^ config.db.pass
      ] >> 
      run "wp" [
      "core", "install", 
      "--path=" ^ config.path, 
      "--url=" ^ config.url, 
      "--title=" ^ config.title,
      "--admin_user=" ^ config.admin.user,
      "--admin_password=" ^ config.admin.pass,
      "--admin_email=" ^ config.admin.email
      ])
};
