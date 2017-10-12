
type id = string;
type url = string;
type title = string;
type filepath = string;

/*
module type COMPILE = {
  type t;
  val compile : t -> string
};
type compile a = (module COMPILE with type t = a);
*/

type menuPage = 
  | Jetpack 
  | Edit 
  | Comments 
  | Themes 
  | Plugins 
  | Tools 
  | GeneralOptions;

type postType = 
  | Post;

type postSupports = 
  | Editor;

/* TODO sync with front end 
        generate id with [metabox id]-[postValue]-[number]
*/
type postValue = 
  | Image 
  | Checkbox  
  | TextField 
  | TextArea;

type metabox = 
  | Metabox title id postType (list (id, postValue));

type actionAdminMenu =
  | RemoveMenuPage menuPage;

type actionInit =
  | RemoveMenuPage menuPage
  | RemovePostTypeSupport postType postSupports;

type action = 
  | Init (list actionInit)
  | AdminMenu (list actionAdminMenu)
  | AddMetaBoxes (list metabox)
  | SavePost (list string)
  | AdminEnqueueScripts (list string)
  | RestAPIInit /* TODO function */
  | External filepath;

type theme = Theme (list action)

