#lang racket

(require rackunit 
         "name-clean-handle.rkt")

(define args-in
  (list
   ".DS_Store"
   "Commands.xml"
   (build-path "test_folder" "Test File S01E02 XviD.h264.(Oh-Yeah).avi")
   "test_folder"))

(define filenames-in
  (list
   "Commands.xml"
   (build-path "test_folder" "Test File S01E02 XviD.h264.(Oh-Yeah).avi")
   (build-path "test_folder" "Test File S01E02 XviD.h264.(Oh-Yeah).avi")))

(define filenames-out
  (list
   (string->path "Commands.xml")
   (build-path "test_folder" "Test File S01E02.avi")
   (build-path "test_folder" "Test File S01E02.avi")))

(define/provide-test-suite handle-tests  
  
  (test-case
   "Check handle-input with single-filenames" 
   (for-each (lambda (x y) (check-equal? (map get-new-path 
                                              (handle-input x)) 
                                         (list y)))
             (cdr args-in)
             filenames-out))
  
  (test-case
   "Check handle-input and get-new-path with lists"
   (check-equal? (map get-new-path 
                      (handle-input filenames-in))
                 filenames-out))
  
  (test-case
   "Check handle-input walks the tree"
   (check-equal? (handle-input args-in) filenames-in))
  
  (test-case
   "Empty folder"
   (check-equal? (handle-input "test_folder_empty") '())
   (check-equal? (map get-new-path (handle-input "test_folder_empty")) empty))
  
  (test-case
   "Check split-path-list works"
   (check-equal? (split-path-list ".DS_Store") 
                 (list 'relative 
                       ""
                       ".DS_Store"))
   (check-equal? (split-path-list "Commands.xml") 
                 (list 'relative 
                       (string->path "Commands") 
                       ".xml"))
   (check-equal? (split-path-list "test_folder/Test File S01E02 XviD.h264.(Oh-Yeah).avi") 
                 (list (string->path "test_folder/")
                       (string->path "Test File S01E02 XviD.h264.(Oh-Yeah)")
                       ".avi"))
   (check-equal? (split-path-list (string->path "test_folder/.config")) 
                 (list (string->path "test_folder/") 
                       ""
                       ".config")))
  
  (test-case
   "Check split-path-pair works"
   (check-equal? (split-path-pair "Commands.xml")
                 (cons 'relative 
                       (string->path "Commands.xml")))
   (check-equal? (split-path-pair "test_folder/Test File S01E02 XviD.h264.(Oh-Yeah).avi")
                 (cons (string->path "test_folder/")
                       (string->path "Test File S01E02 XviD.h264.(Oh-Yeah).avi")))
   (check-equal? (split-path-pair (string->path "test_folder/.config")) 
                 (cons (string->path "test_folder/") 
                       (string->path ".config"))))
  
  (test-case
   "Check flatten-to-string can produce a newline-separated string from list of pathnames"
   (check-equal? (flatten-to-string "a string") "a string")
   (check-equal? (flatten-to-string filenames-in) "Commands.xml\nTest File S01E02 XviD.h264.(Oh-Yeah).avi\nTest File S01E02 XviD.h264.(Oh-Yeah).avi"))
  
  (test-case
   "Check is-hidden? works for Unix-style hidden files"
   (check-equal? (is-hidden? ".config") #t)
   (check-equal? (is-hidden? "Commands.xml") #f)
   (check-equal? (is-hidden? "test_folder/.DS_Store") #t)
   (check-equal? (is-hidden? "test_foler/test file.txt") #f)))