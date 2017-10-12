open Shexp_process.Infix;

module S = Shexp_process;

let run (config:Config.config) => {
  S.eval (
    S.run "rm" ["-rf", config.path] >>
    S.run "mkdir" ["-p", config.path] >>
    S.run "wp" ["core", "download", "--path=" ^ config.path] >> 
    S.run "wp" [
    "config", "create", 
    "--path=" ^ config.path, 
    "--dbhost=" ^ config.db.host ^ ":" ^ (string_of_int config.db.port),
    "--dbname=" ^ config.db.name,
    "--dbuser=" ^ config.db.user,
    "--dbpass=" ^ config.db.pass
    ] >> 
    S.run "wp" ["db", "drop", "--yes", "--path=" ^ config.path] >> 
    S.run "wp" ["db", "create", "--path=" ^ config.path] >> 
    S.run "wp" [
    "core", "install", 
    "--path=" ^ config.path, 
    "--url=" ^ config.url, 
    "--title=" ^ config.title,
    "--admin_user=" ^ config.admin.user,
    "--admin_password=" ^ config.admin.pass,
    "--admin_email=" ^ config.admin.email
    ] >>
    S.run "wp" [
      "plugin", 
      "install", 
      "wordpress-importer", 
      "--activate",
      "--path=" ^ config.path
    ] >>
    /* TODO move */
    S.run "cp" [
      "-r", 
      config.theme.src, 
      config.path ^ "/wp-content/themes/" ^ config.theme.name
    ] >>
    S.run "wp" [
      "theme", "activate", config.theme.name,
      "--path=" ^ config.path
    ]);
};

let update_theme (config:Config.config) => {
  let dst = config.path ^ "/wp-content/themes/" ^ config.theme.name;

  S.eval (
    S.run "rm" ["-rf", dst] >>
    S.run "cp" ["-r", config.theme.src, dst]);
};
