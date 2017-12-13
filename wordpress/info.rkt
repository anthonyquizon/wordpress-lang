#lang info

(define collection "wordpress")
(define deps '("base"
               "shell-pipeline"  
               "git://github.com/rcherrueau/rastache.git?path=rastache"))
(define build-deps 
  '("scribble-lib" 
    "racket-doc" 
    "rackunit-lib"))
(define pkg-desc "TODO")
(define version "0.0")

