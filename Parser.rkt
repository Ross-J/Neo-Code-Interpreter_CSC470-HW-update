#lang Racket

(require "Tools.rkt")
(provide (all-defined-out))

; Neo-Code to Scheme Parser
(define neo-parser
  (lambda (neo-code)
    (cond
      ((null? neo-code) '())
      ((number? neo-code) (list 'num-exp neo-code))
      ((symbol? neo-code) (list 'var-exp neo-code))
      
      ((equal? (car neo-code) 'bool) (neo-bool-code-parser neo-code))                            
      ((equal? (car neo-code) 'math) (neo-math-code-parser neo-code))
      ((equal? (car neo-code) 'ask) (neo-ask-code-parser neo-code))
      ((equal? (car neo-code) 'function) (neo-function-code-parser neo-code))
      ((equal? (car neo-code) 'call) (neo-call-code-parser neo-code))
      ((equal? (car neo-code) 'local-var) (neo-let-code-parser neo-code)) 
      
       (else (map neo-parser neo-code))
      )
    )
  )
  

; Parser for boolean expressions
(define neo-bool-code-parser
  (lambda (neo-code)
    (if (equal? (length neo-code) 3)
        (list 'bool-exp (cadr neo-code) (neo-parser (caddr neo-code)) '())
        (cons 'bool-exp (cons (cadr neo-code) (map neo-parser (cddr neo-code)))))
  )
)

; Parser for math expressions
(define neo-math-code-parser
  (lambda (neo-code)
    (list 'math-exp (cadr neo-code)
             (neo-parser (caddr neo-code))
             (neo-parser (cadddr neo-code)))
  )
)

; Parser for ask expressions
(define neo-ask-code-parser
  (lambda (neo-code)
    (cons 'ask-exp
             (map neo-parser (cdr neo-code)))  
  )
)

; Parser for function expressions
(define neo-function-code-parser
  (lambda (neo-code)
    (list 'func-exp
             (list 'params (cadr neo-code))
             (list 'body-exp (neo-parser (caddr neo-code))))
  )
)

; Parser for call expression 
(define neo-call-code-parser
  (lambda (neo-code)
    (list 'app-exp
             (neo-parser (cadr neo-code))
             (neo-parser (caddr neo-code)))
  )
)

; Parser for let expression
(define neo-let-code-parser
  (lambda (neo-code)
    (list 'let-exp (elementAt neo-code 1) (neo-parser (elementAt neo-code 2)))
  )
)