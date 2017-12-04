#lang brag

wp-program: (CHAR-TOK | wp-prop)*
wp-prop: "\t" CHAR-TOK "\n"

;wp-program: (wp-var | wp-in | wp-proc)*
;wp-in: PATH
;wp-proc: CHAR-TOK (wp-arg)*
;wp-arg: CHAR-TOK
;wp-var: CHAR-TOK ":" CHAR-TOK
;wp-string: SEXP-TOK

