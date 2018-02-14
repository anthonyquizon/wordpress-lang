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
  (id name url path permalinks admin database theme plugins))

(define default-properties
  (properties 
    ""
    "" 
    "" 
    "" 
    ""
    (admin "" "" "")
    (database "" "" "" "")
    (theme "")
    '()
    ))

(define current-properties 
  (make-parameter default-properties))

