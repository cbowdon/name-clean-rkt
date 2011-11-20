#lang racket

(require xml)

(define master-file "protected/MasterRules.xml")


;(define default-commands
; (xexpr->xml

(define (get-master-rules file)
  (filter (lambda (x) (and (not (string? x)) (not (empty? x))))
          (call-with-input-file file
            (lambda (fin) (xml->xexpr (document-element (read-xml fin)))))))

(define x (get-master-rules master-file))
