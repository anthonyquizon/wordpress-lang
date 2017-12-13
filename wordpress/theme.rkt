#lang racket 

(require (prefix-in r: rastache)
         (prefix-in p: "parameter.rkt")
         (prefix-in h: "helpers.rkt")
         (prefix-in f: "template/functions.tpl.php")
         (prefix-in s: "template/style.tpl.css")
         (prefix-in a: "template/acf.tpl.php"))

(provide run)

(define (theme-path props name)
  (string-append (p:properties-path props) 
                 "/wp-content/themes/" 
                 (p:properties-id props)
                 "/"
                 name))

(define (create-functions-file)
  (let* ([props (p:properties-param)]
         [in (open-input-string f:template)]
         [out (open-output-file (theme-path props))]
         [data #hash{ 
                 (admin_menu . #t)
                 (tpl_name . "woo")
                 (items . (#hash{(item . "hello")}
                           #hash{(item . "there")}))}])
    (r:rast-compile/render in data out)
    (close-output-port out)))

(define (create-style-file)
  (let* ([props (p:properties-param)]
         [in (open-input-string s:template)]
         [out (open-output-file (theme-path props "style.css"))]
         [name (p:properties-name props)]
         [data (make-immutable-hash `((name . ,name)))])
    (r:rast-compile/render in data out)
    (close-output-port out)))

(define (run)
  (h:setup-dir (theme-path (p:properties-param) ""))
  ;(create-functions-file)
  (create-style-file))

