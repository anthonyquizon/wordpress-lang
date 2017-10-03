open Shexp_process;
open Shexp_process.Infix;

let new_install (config:Config.config) => {
  eval (
      run "rm" ["-rf", config.path] >>
      run "mkdir" ["-p", config.path] >>
      run "wp" ["core", "download", "--path=" ^ config.path] >> 
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
      ] >>
      /* TODO move */
      run "cp" ["-r", config.theme.src, config.path ^ "/wp-content/themes/" ^ config.theme.name] >>
      run "wp" [
        "theme", "activate", config.theme.name,
        "--path=" ^ config.path
      ])
};

let update_theme (config:Config.config) => {
  let dst = config.path ^ "/wp-content/themes/" ^ config.theme.name;
  eval (
    run "rm" ["-rf", dst] >>
    run "cp" ["-r", config.theme.src, dst]
  );
};
