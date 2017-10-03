
type html;
type post;

type action = 
  | Init int
  | AddMetaBoxes (list string);

type metabox = {
  title: string,
  html: (post => html)
};

type config = {
  name: string
};

/*
module type Compile = {
  type t;
  let compile: t => string;
};

module type Index : Compile = {
  type t = ;
  let compile: t => string;
};
*/

