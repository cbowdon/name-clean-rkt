#lang racket

(require rackunit 
         "name-clean-cli.rkt")

(display "\nVisual checks required\n")

(define possible-args
  (list
   '()
   (list "test_folder")
   (list "-v" "test_folder")
   (list "-v" "test_folder" "Commands.xml")))

(test-case
 "Simplest use"
 (for-each (lambda (x) (begin (printf "\nTEST CMD LINE:\n\t~a\nOUTPUT:\n" x)
                              (parse-cmd-line (list->vector x)))) 
           possible-args))