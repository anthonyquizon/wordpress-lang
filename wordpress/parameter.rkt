#lang racket 

;; TODO typed racket

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

(struct theme
  (posts_per_page scripts))

(struct database
  (host name user pass))

(struct admin
  (user pass email))

(struct properties 
  (name url path admin database theme plugins))

(define properties-param 
  (make-parameter 
    (properties 
      "" 
      "" 
      ""
      (admin "" "" "")
      (database "" "" "" "")
      (theme 30 "")
      '())))

