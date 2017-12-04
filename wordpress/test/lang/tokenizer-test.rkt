#lang br/quicklang

(require rackunit
         brag/support 
         "./../../lang/tokenizer.rkt")

(check-equal? 
  (apply-tokenizer-maker make-tokenizer "#comment\n")
  empty)

