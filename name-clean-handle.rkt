#lang racket
(require "name-clean-rules.rkt")

(provide handle-input
         get-new-path
         split-path-list
         split-path-pair
         flatten-to-string
         is-hidden?
         tables)

(define rules (get-rules rules-file))

; a procedure-object to that controls the tables
(define (handler)
  (let* ([do-table (make-hash)]
         [undo-table (hash-copy do-table)])
    (define (action msg)
      (cond [(eq? msg 'add-do) (lambda (x y) (hash-set! do-table x y))]
            [(eq? msg 'make-undo) (set! undo-table (hash-copy do-table))]
            [(eq? msg 'clear-do) (for-each (lambda (x) (hash-remove! do-table x)) (hash-keys do-table))]
            [(eq? msg 'clear-undo) (for-each (lambda (x) (hash-remove! undo-table x)) (hash-keys undo-table))]
            [(eq? msg 'get-do) do-table]
            [(eq? msg 'get-undo) undo-table]
            [(eq? msg 'empty-do?) (equal? (hash-count do-table) 0)]
            [(eq? msg 'empty-undo?) (equal? (hash-count undo-table) 0)]
            [else (error "Invalid message:" msg)]))
    action))

; the (only) instance of this procedure-object
(define tables (handler))

; return flat list of (delay-cons old-path new-path)
(define (handle-input input)
  (filter
   (lambda (x) (not (false? x)))
   (flatten 
    (cond [(list? input) (map handle-input input)]
          [(file-exists? input) 
           (if [is-hidden? input]
               #f
               input)]
          [(directory-exists? input) (handle-directory input)]
          [else (error "Not a file, list of files or directory:" input)]))))

; handle directory
(define (handle-directory d)
  (map handle-input
       (map (lambda (x) (build-path d x)) 
            (directory-list d))))

; split paths into (directory name extension)
(define (split-path-list x)
  (let-values ([(dir filename bool) (split-path x)])
    (let ([name (path-replace-suffix filename "")]
          [ext (get-ext-string filename)])
      (if [equal? (path->string filename) ext]
          (list dir "" ext)
          (list dir name ext)))))

; hidden files
(define (is-hidden? x)
  (let-values ([(dir filename bool) (split-path x)])
    (equal? (path->string filename) (get-ext-string filename))))

; split paths into (directory name.ext)
(define (split-path-pair x)
  (let-values ([(dir filename bool) (split-path x)])
    (cons dir filename)))

; filename-extension modified to append the "."
(define (get-ext-string x)
  (if (not (filename-extension x))
      ""
      (string-append "." (bytes->string/utf-8 (filename-extension x)))))

; get new path 
(define (get-new-path old-path)  
  (let* ([spl (split-path-list old-path)]
         [new-name-string (apply-rules (path->string (cadr spl)) rules)])
    (cond [(eq? (car spl) 'relative) (string->path (string-append new-name-string (caddr spl)))]
          [else (build-path (car spl) (string->path (string-append new-name-string (caddr spl))))])))

; flatten list to displayable string
(define (flatten-to-string input-list)
  (if (string? input-list)
      input-list
      (string-join (map (compose1 path->string cdr split-path-pair) input-list) "\n"))) 

