#lang racket
(provide list-index
         get-alt-shortcut-prefix)

; get list index
(define (list-index a-list val)
  (define (index-iter lst count)
    (cond [(empty? lst) #f]
          [(equal? (stream-first lst) val) count]
          [else (index-iter (stream-rest lst) (+ count 1))]))
  (index-iter a-list 0))

; ronseal
(define (get-alt-shortcut-prefix)
  (let ([os (system-type 'os)])
    (cond [(eq? os 'macosx) (list 'option)]          
          [else (list 'alt)])))

