#lang wordpress

(page
  [title "Tag Collection"]
  [items (|> (get_field "")
             ()
             )]
  )
