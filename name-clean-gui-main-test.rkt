#lang racket/gui

;; In this file: tests for gui controls

(require rackunit
         "name-clean-gui-main.rkt"
         "name-clean-gui-prefs.rkt"
         "name-clean-handle.rkt")

(define args-in
  (list
   "Preferences.plist"
   ".DS_Store"
   (build-path "test_folder" "Test File S01E02 XviD.h264.(Oh-Yeah).avi")
   "test_folder"))


(define/provide-test-suite gui-tests  
  
  (test-case
   "When no files selected, rename and clear buttons should be unavailable"
   (check-equal? (tables 'empty-do?) #t)
   (check-equal? (tables 'empty-undo?) #t)
   (check-equal? (send btn-rename is-enabled?) #f)
   (check-equal? (send btn-clear is-enabled?) #f))
  
  (test-case
   "When files selected, rename button should have appropriate label and be enabled"
   (choose args-in)
   (check-equal? (tables 'empty-do?) #f)
   (check-equal? (tables 'empty-undo?) #t)
   (check-equal? (send btn-rename is-enabled?) #t)
   (check-equal? (send btn-rename get-label) (hash-ref labels 'rename)))
  
  (test-case
   "When files selected, clear button should be enabled"
   (check-equal? (tables 'empty-do?) #f)
   (check-equal? (tables 'empty-undo?) #t)
   (check-equal? (send btn-clear is-enabled?) #t))
  
  (test-case
   "If cleared before rename, both buttons should be disabled; label should be rename"
   (send btn-clear command (new control-event% [event-type 'button]))
   (check-equal? (tables 'empty-do?) #t)
   (check-equal? (tables 'empty-undo?) #t)
   (check-equal? (send btn-rename is-enabled?) #f)
   (check-equal? (send btn-rename get-label) (hash-ref labels 'rename))
   (check-equal? (send btn-clear is-enabled?) #f))
  
  (test-case
   "New choices should replace old"
   ; add args
   (choose args-in)
   (check-equal? (tables 'empty-do?) #f)
   (check-equal? (tables 'empty-undo?) #t)
   (let ([n-args (hash-count (tables 'get-do))])
     ; drop first (non-rejected) arg and try again
     (choose (cdr args-in))
     (check-equal? (- n-args 1) (hash-count (tables 'get-do)))))
  
  (test-case
   "After the rename, button should have undo label and be enabled"
   (send btn-rename command (new control-event% [event-type 'button]))
   (check-equal? (tables 'empty-do?) #t)
   (check-equal? (tables 'empty-undo?) #f) 
   (check-equal? (send btn-rename is-enabled?) #t)
   (check-equal? (send btn-rename get-label) (hash-ref labels 'undo))
   (check-equal? (send btn-clear is-enabled?) #f))
  
  (test-case
   "After undoing the rename, rename and clear buttons should be disabled" 
   (send btn-rename command (new control-event% [event-type 'button]))
   (check-equal? (tables 'empty-do?) #t)
   (check-equal? (tables 'empty-undo?) #t)
   (check-equal? (send btn-rename is-enabled?) #f)
   (check-equal? (send btn-rename get-label) (hash-ref labels 'rename))
   (check-equal? (send btn-clear is-enabled?) #f)))