open Core

let defaultWp = "extern/wp-cli.phar"
let defaultPath = "extern/wp-cli.phar"


let exec wp path =
  let cmd = String.concat ~sep:" " [wp; path; "--help"]
  in print_string cmd
  (*in Sys.command cmd*)

let execDefault = exec defaultWp defaultPath
