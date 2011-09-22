#lang racket/gui

;; In this file: gui for main window

(require "name-clean-handle.rkt"
         "name-clean-gui-help.rkt"
         "name-clean-gui-prefs.rkt"
         "name-clean-helper-functions.rkt")

(provide frame
         btn-rename
         btn-clear
         choose)

; choose a file
(define (choose-file btn evt)
  (choose (get-file-list (hash-ref labels 'select-files) frame (find-system-path 'home-dir) #f #f null '(("Any" "*.*")))))

; choose a directory
(define (choose-dir btn evt)
  (choose (get-directory (hash-ref labels 'select-dir) frame (find-system-path 'home-dir) null)))

; choose sets the content of the text fields
(define (choose dialog)
  (when dialog
    (tables 'clear-do)
    (let* ([input-list (handle-input dialog)]
           [fin (handle-input input-list)]
           [fout (map get-new-path input-list)]
           [input-string (flatten-to-string fin)]
           [output-string (flatten-to-string fout)])
      ; build table
      (for-each (tables 'add-do) fin fout)
      ; set text
      (send text-in set-value input-string)
      (send text-out set-value output-string)
      ; button should definitely have rename label
      (send btn-rename set-label (hash-ref labels 'rename))      
      ; enable buttons
      (send btn-rename enable #t)
      (send btn-clear enable #t))))

; handle rename button
(define (rename-files btn evt)
  (if [equal? (send btn-rename get-label) (hash-ref labels 'rename)]
      (do-rename btn evt)
      (undo-rename btn evt)))

; do renames
(define (do-rename btn evt)
  (let ([rename (lambda (x) (when [not (file-exists? (cdr x))]                           
                              (rename-file-or-directory (car x) (cdr x))))])
    (if (tables 'empty-do?)
        (send message set-label (hash-ref labels 'do-message))
        (begin
          ; backup the table
          (tables 'make-undo)
          ; perform the rename
          (for-each rename (hash->list (tables 'get-do)))
          ; update message
          (send message set-label (hash-ref labels 'done-message))
          ; clear table and text
          (tables 'clear-do)
          (send btn-clear enable #f)
          (send text-in set-value "")
          (send text-out set-value "")
          ; turn the button into undo and enable
          (send btn set-label (hash-ref labels 'undo))          
          (send btn enable #t)))))

; undo renames
(define (undo-rename btn evt)
  (let ([rename (lambda (x) (when [not (file-exists? (car x))]                           
                              (rename-file-or-directory (cdr x) (car x))))])
    (if (tables 'empty-undo?)
        (send message set-label (hash-ref labels 'do-message))
        (begin
          ; perform the rename
          (for-each rename (hash->list (tables 'get-undo)))
          ; update label
          (send message set-label (hash-ref labels 'undone-message))
          ; clear undo-table
          (tables 'clear-undo)
          ; turn button into rename and disable
          (send btn set-label (hash-ref labels 'rename))
          (send btn enable #f)))))

; clear
(define (clear btn evt)
  (tables 'clear-do)
  (send text-in set-value "")
  (send text-out set-value "")
  (send btn-rename enable #f)
  (send btn-clear enable #f))

; quit
(define (quit btn evt)
  (send frame-prefs show #f)
  (send frame show #f))

; editing the text directly does nothing
(define need-telling (make-parameter #t))
(define (no-effect btn evt)
  (when (need-telling)
    (need-telling #f)
    (message-box 
     (hash-ref labels 'direct-edit1)
     (hash-ref labels 'direct-edit2))))

; (function-name sender event)
(define (blank btn evt)
  (message-box "Sorry" "Not done yet")) 

; frame
(define frame 
  (new frame% 
       [label (hash-ref labels 'name)]))
(define message 
  (new message% 
       [parent frame] 
       [label (hash-ref labels 'do-message)]
       [auto-resize #t]))

; top pane - control buttons
(define pane-buttons 
  (new horizontal-pane% 
       [parent frame] 
       [alignment (list 'center 'center)]))
(define btn-select-files 
  (new button% 
       [parent pane-buttons] 
       [label (hash-ref labels 'select-files)] 
       [callback choose-file]))
(define btn-select-dir 
  (new button% 
       [parent pane-buttons] 
       [label (hash-ref labels 'select-dir)] 
       [callback choose-dir]))
(define btn-rename 
  (new button% 
       [parent pane-buttons] 
       [label (hash-ref labels 'rename)] 
       [callback rename-files]
       [enabled #f]))
(define btn-clear 
  (new button% 
       [parent pane-buttons] 
       [label (hash-ref labels 'clear)] 
       [callback clear]
       [enabled #f]))
(define btn-quit 
  (new button% 
       [parent pane-buttons] 
       [label (hash-ref labels 'quit)] 
       [callback quit]))

; bottom pane - text
(define pane-text (new horizontal-pane% [parent frame]))
(define text-in 
  (new text-field% 
       [label (hash-ref labels 'orig-names)] 
       [parent pane-text] 
       [callback no-effect] 
       [style (list 'multiple 'hscroll)] 
       [min-width 400] 
       [min-height 250]))
(define text-out 
  (new text-field% 
       [label (hash-ref labels 'new-names)] 
       [parent pane-text] 
       [callback no-effect] 
       [style (list 'multiple 'hscroll)] 
       [min-width 400] 
       [min-height 250]))

; menu bar
(define menu-bar 
  (new menu-bar% 
       [parent frame]))
; file menu
(define menu-file 
  (new menu% 
       [label (hash-ref labels 'file)] 
       [parent menu-bar]))
(define menu-file-select-files 
  (new menu-item% 
       [label (hash-ref labels 'select-files)] 
       [parent menu-file] 
       [callback choose-file]
       [shortcut #\o]
       [shortcut-prefix (get-default-shortcut-prefix)]))
(define menu-file-select-dir 
  (new menu-item% 
       [label (hash-ref labels 'select-dir)] 
       [parent menu-file] 
       [callback choose-dir]))
(define menu-file-quit
  (new menu-item%
       [label (hash-ref labels 'quit)]
       [parent menu-file]
       [callback quit]
       [shortcut #\q]
       [shortcut-prefix (get-default-shortcut-prefix)]))
; edit menu
(define menu-edit 
  (new menu% 
       [label (hash-ref labels 'edit)] 
       [parent menu-bar]))
(define menu-edit-prefs 
  (new menu-item% 
       [label (hash-ref labels 'prefs)] 
       [parent menu-edit] 
       [callback edit-prefs]
       [shortcut #\,] ; this doesn't seem to work on OSX?!
       [shortcut-prefix (get-default-shortcut-prefix)]))
; help menu
(define menu-help 
  (new menu% 
       [label (hash-ref labels 'help)] 
       [parent menu-bar]))
(define menu-help-about
  (new menu-item%
       [label (hash-ref labels 'about)]
       [parent menu-help]
       [callback about]))
(define menu-help-help
  (new menu-item%
       [label (hash-ref labels 'help)]
       [parent menu-help]
       [callback help]
       [shortcut 'f1]))

