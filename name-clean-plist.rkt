#lang racket
(require xml/plist)

(provide hash->dict
         dict->hash
         hash->plist
         plist->hash
         plist-location
         plist-prefix
         preferences-file)

(define plist-prefix "com.bowdon.NameClean.")
(define plist-location (path->string (build-path (find-system-path 'pref-dir) plist-prefix)))
(define preferences-file (string-append plist-location "preferences.plist"))

; internal conversions to/from dict grammar
; currently ignores nested dicts
(define (hash->dict h)
  (let ([hl (hash-map h (lambda (x y) (list 'assoc-pair (symbol->string x) y)))])
    (cons 'dict hl)))

(define (dict->hash dict)
  (define (dict-iter d h)
    (if [empty? d] 
        h
        (let ([item (car d)])
          (cond [(eq? 'dict item) (dict-iter (cdr d) h)]
                [(eq? 'assoc-pair (car item))
                 (begin
                   (hash-set! h (string->symbol (cadr item)) (caddr item))
                   (dict-iter (cdr d) h))]
                [else (dict-iter (cdr d)) h]))))          
  (dict-iter dict (make-hash)))

; writing hash to / reading hash from plist file
; depends on the caller addressing the file appropriately
(define (hash->plist hash-table sfile)
  (when [file-exists? sfile] (delete-file sfile))
  (call-with-output-file sfile
    (lambda (out) (write-plist (hash->dict hash-table) out))))

(define (plist->hash sfile)
  (when [not (file-exists? sfile)] #f)
  (call-with-input-file sfile
    (lambda (in) (dict->hash (read-plist in)))))

(define (read-settings)
  (plist->hash preferences-file))