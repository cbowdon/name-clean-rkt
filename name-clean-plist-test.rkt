#lang racket

(require rackunit
         xml/plist
         "name-clean-plist.rkt")

(define test-table (make-hash))
(hash-set! test-table 'language "English")
(hash-set! test-table 'other "Other")

(define/provide-test-suite plist-tests
  
  (test-case
   "Does hash->dict work?"
   (let ([d (hash->dict test-table)]) 
     (check-equal? (plist-dict? d) #t)
     (check-eq? (car d) 'dict)
     (check-eq? (caadr d) 'assoc-pair)
     ;(check-equal? (cadr (cadr d)) "language")
     ;(check-equal? (caddr (cadr d)) "English")
     ))
  
  (test-case
   "Does dict->hash work?"
   (let* ([d (hash->dict test-table)]
          [h (dict->hash d)])
     (check-equal? (hash-ref h 'language) "English")))
  
  
  (test-case
   "Try serializing"
   (define-values (in out) (make-pipe))
   (let* ([d (hash->dict test-table)]
          [h (dict->hash d)])
     (begin 
       (write-plist d out)
       (close-output-port out)
       (define test-hash (dict->hash (read-plist in)))
       (check-equal? h test-hash))))
  
  (test-case
   "Do hash->plist and plist->hash work?"
   (let ([tfile "Test.plist"])
     (hash->plist test-table tfile)
     (let ([h (plist->hash tfile)])
       (delete-file tfile)
       (check-equal? h test-table)))))

