

type cmd = {
  subcmds of subcmd list;
  flags of string list;
}

type configCmd = Create
type subcmd = Config of configCmd
