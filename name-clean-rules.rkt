#lang racket
(require xml
         "name-clean-commands.rkt")

(provide get-rules
         apply-rules
         test-file)

(define test-file  
  (if [file-exists? rules-file]
      rules-file
      (begin 
        (write-default-commands)
        rules-file)))

; load rules
(define (make-rule rulelist)
  (if (and (list? rulelist)
           (not (empty? rulelist)))
      (let ((action (car rulelist))
            (pattern (regexp (caddr rulelist))))
        (cons action pattern))
      '()))

(define (get-rules path)
  (call-with-input-file path
    (lambda (fin) (stream-filter (lambda (x) (not (empty? x)))
                                 (stream-map make-rule 
                                             (xml->xexpr (document-element (read-xml fin))))))))

; apply rules
(define (apply-one name rule)
  (cond ((eq? (car rule) 'allow) (allow (cdr rule) name))
        ((eq? (car rule) 'delete) (replace (cdr rule) name ""))
        ((eq? (car rule) 'space) (replace (cdr rule) name " "))
        ((eq? (car rule) 'toSintEint) (regexp-replace (cdr rule) name toSintEint))
        (else (replace (cdr rule) name (symbol->string (car rule))))))

(define (apply-rules name rules)
  (cond [(stream-empty? rules) (first-char-upcase (allow-clean name))]
        [(not (equal? (apply-one name (stream-first rules)) name))
         (apply-rules (apply-one name (stream-first rules)) (stream-rest rules))]
        [else 
         (apply-rules name (stream-rest rules))]))

; allow
; (first proc puts ::: around pattern so it is never matched
; second proc removes :::) 
(define (allow rule name)  
  (regexp-replace rule name (lambda (s) (string-append ":::" s ":::")))) 

(define (allow-clean name)
  (regexp-replace* ":::" name ""))

; replace (contains check for allow)
(define (replace rule name repchar)
  (let ((allowed (regexp (string-append "(?<=:::).*" (object-name rule) ".*(?=:::)"))))
    (if (not (regexp-match allowed name))
        (regexp-replace* rule name repchar)
        name)))

; to SintEint notation
(define (format-num str)
  (let ((num (string->number str)))
    (if (< num 10)
        (string-append "0" (number->string num))
        str)))

(define (toSintEint name)
  (let ((nums (filter (lambda (x) (> (string-length x) 0)) 
                      (regexp-split (regexp "[^0-9]+") name))))
    (string-append "S" (format-num (car nums)) "E" (format-num (cadr nums)))))

; Titlecase for first word
(define (first-char-upcase str)
  (let ([x (string->list str)])
    (if (empty? x)
        str
        (list->string (cons (char-upcase (car x)) (cdr x))))))