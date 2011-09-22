#lang racket

(require rackunit
         "name-clean-helper-functions.rkt")

(define/provide-test-suite helper-function-tests  
  (test-case
   "Get list index test"
   (let ([nums (list 0 1 2 3 4)]
         [l1 (list 'a 'b 'c 'd 'e)]
         [l2 (list 'a (list 'b 'c) 'd 'e)]
         [s1 (stream-cons 'a (stream-cons 'b 'c))])
     (check-equal? (map (lambda (x) (list-index l1 x)) l1) nums)
     (check-equal? (list-index l2 'a) 0)
     (check-equal? (list-index l2 (list 'b 'c)) 1)
     (check-equal? (list-index l2 'd) 2)
     (check-equal? (list-index l2 'e) 3)
     (check-equal? (list-index s1 'a) 0)
     (check-equal? (list-index s1 'b) 1))))

