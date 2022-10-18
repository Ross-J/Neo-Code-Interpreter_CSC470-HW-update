#lang Racket

(require "Parser.rkt")
(require "Runner.rkt")
(require "Tools.rkt")
;(require "Variable_Env.rkt")



(define env '((a 1) (b 2) (c 5)))


;(define sample-code '(call (function () (ask (bool > a b) (math - a b) (math + a b))) (a)))
;(define sample-code '(call (function(x) (local-vars ((a 1) (b 2) (c 3)) (math + a b))) (5)))



(define sample-code '(call (function (a)
                    (local-vars ((x 5) (y 6) (z 9))
                    ((call (function (b)(math + a (math * b x)))) (2)))) (3)))
(display (neo-parser sample-code))
(define parsed-neo-code (neo-parser sample-code))
(run-neo-parsed-code parsed-neo-code env)




