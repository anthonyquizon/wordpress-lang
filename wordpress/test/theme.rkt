#lang racket

(require rackunit
         rackunit/text-ui
         (prefix-in under-test: "../theme.rkt")
         (prefix-in h: "../helpers.rkt")
         (prefix-in p: "../parameter.rkt"))

(define tests
  (test-suite
    "Theme"
    (test-case 
      "style.css"
      (around 
        (let ([theme (p:theme "fixtures/theme" 30 "")])
         (p:properties-param 
          (struct-copy 
            p:properties 
            p:default-properties 
            [id "foo"] 
            [name "foo"] 
            [path "./output"] 
            [theme theme])))
        (begin
          (under-test:run)
          (h:check-files-equal? 
            "./output/wp-content/themes/foo/style.css"
            "./golden/style.css"))
        (h:reset-properties)))))

(module+ test
  (run-tests tests))
