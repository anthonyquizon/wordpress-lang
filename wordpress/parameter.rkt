#lang racket 

(provide (all-defined-out))

(struct acf-text 
  (key label name))

(struct acf-image
  (key label name))

(struct acf-select
  (key label name choices))

(struct acf-repeater
  (key label name choices))

(struct acf-group
  (id title position layout fields))

(struct acf (groups))

(struct plugins (names))

(struct theme
  (posts_per_page scripts))

(struct database
  (host name user pass))

(struct properties 
  (name path database theme plugins))

(define properties-param 
  (make-parameter 
    (properties 
      "" 
      ""
      (database "" "" "" "")
      (theme 30 "")
      (plugins '()))))

