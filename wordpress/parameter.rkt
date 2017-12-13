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
  (id name url path admin database theme plugins))

(define default-properties
  (properties 
    ""
    "" 
    "" 
    ""
    (admin "" "" "")
    (database "" "" "" "")
    (theme 30 "")
    '()))

(define properties-param 
  (make-parameter default-properties))

