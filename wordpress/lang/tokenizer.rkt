#lang br/quicklang

(require brag/support
         racket/contract)

(define (wp-token? x)
  (or (eof-object? x) (string? x) (token-struct? x)))

(define (make-tokenizer port)
  (define (next-token)
    (define wp-lexer
      (lexer 
        [(eof) eof]
        [(from/to "#" "\n") (next-token)]
        ;[any-char (token 'CHAR-TOK lexeme)]
        ))
    (wp-lexer port))
  next-token)

(provide (contract-out 
           [make-tokenizer (input-port? . -> . (-> wp-token?))]))

