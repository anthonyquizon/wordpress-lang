
module J = Yojson;

let wordpress () => {
  let config = Config.parse Sys.argv.(1);

  switch (Sys.argv) {
    | [|_, _, "update"|] => Install.update_theme config
    | [|_, _, "posts"|] => {
      Posts.upload config
    }
    | _ => Install.run config;
  };
};

