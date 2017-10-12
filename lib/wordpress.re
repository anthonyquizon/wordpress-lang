
module J = Yojson;

let wordpress config::configPath => {
  let config = Config.parse configPath;

  switch (Sys.argv) {
    | [|_, "update"|] => Install.update_theme config
    | [|_, "posts"|] => Posts.upload config
    | _ => Install.run config;
  };
};

