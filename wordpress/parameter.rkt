#lang racket 

;; TODO typed racket

(provide (all-defined-out))

(struct theme
  (src))

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

