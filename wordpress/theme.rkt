#lang racket 

(require (prefix-in t: "transpiler.rkt")
         (prefix-in p: "parameter.rkt"))
(provide page)

(define (page-header-comment name)
  (format "/* Template Name: ~a */" name))

;;TODO change to macro
(define (page name terms)
  (define props (p:properties-param))
  (define path (p:properties-path props))
  (define header (page-header-comment name))
  (define filename (format "page-~a.php" (string-replace name " " "-")))
  (define body (t:rewrite terms)) ;;TODO the_post
  (define output (format "<?php ~a ~a ?>" header body))

  (with-output-to-file 
    (string-append path "/" filename)
    (lambda (out) (printf output))))

(define (image_src id)
  (t:php-call "wp_get_attachment_image_src" id))

(define (image id)
  (define formats '("thumbnail" "medium" "large" "full"))
  (define f (lambda (x acc)
      (define image (image_src id x))
      `(("src" . ,(list-ref image 0))
        ("width" . ,(list-ref image 1))
        ("height" . ,(list-ref image 2)))))

  (make-hash (foldl f '() formats)))

