
let wordpress config => {
  switch (Sys.argv) {
    | [|_, _, "update"|] => Wpcli.update_theme config;
    | _ => Wpcli.new_install config;
  }
};

