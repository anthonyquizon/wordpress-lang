#lang racket 

;; TODO typed racket

(provide (all-defined-out))

(struct acf-field_text 
  (key label name))

(struct acf-field_image
  (key label name))

(struct acf-field_select
  (key label name choices))

(struct acf-field_repeater
  (key label name choices))

(struct acf_location
  (operator parameter value))

(struct acf
  (id title location fields))

(struct theme
  (src posts_per_page scripts))

(struct database
  (host name user pass))

(struct admin
  (user pass email))

(struct properties 
  (id name url path admin database theme plugins acf))

(define default-properties
  (properties 
    ""
    "" 
    "" 
    ""
    (admin "" "" "")
    (database "" "" "" "")
    (theme "" 30 "")
    '()
    '()
    ))

(define properties-param 
  (make-parameter default-properties))

