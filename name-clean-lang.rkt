#lang racket

;; In this file: providing the translations table

(require "name-clean-plist.rkt"
         "name-clean-lang-en.rkt"
         "name-clean-lang-zh.rkt")

(provide translation-table
         update-translation-table)

; a message-passing approach may be useful here also
; keys are strings
; values are language hash tables
(define translation-table (make-hash))

(define (find-translation-files)
  (map (lambda (x) (build-path (find-system-path 'pref-dir) x))
       (filter (lambda (x) (regexp-match (string-append plist-prefix "lang-[a-z][a-z]\\.plist$") x))
               (directory-list (find-system-path 'pref-dir)))))

(define (get-translation plist)
  (let ([translation-hash (plist->hash plist)])
    (hash-set! translation-table 
               (hash-ref translation-hash 'language) 
               translation-hash)))

(define (update-translation-table)
  (when [empty? (find-translation-files)]
    (begin
      (write-translation-en)
      (write-translation-zh)))
  (for-each get-translation (find-translation-files)))