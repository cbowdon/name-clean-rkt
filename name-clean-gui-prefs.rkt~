#lang racket/gui

;; In this file: gui for the preferences window and implementation of preferences changes

(require "name-clean-lang.rkt"
         "name-clean-plist.rkt"
         "name-clean-helper-functions.rkt")

(provide labels
         edit-prefs
         frame-prefs)

; handling the preferences table
(define (prefs-handler)
  (let ([p-table (make-hash)]
        [p-file "Preferences.plist"])
    ; change 
    (define (add x y)
      (hash-set! p-table x y))
    ; find
    (define (ref x)
      (hash-ref p-table x))
    ; use defaults
    (define (default)  
      (update-translation-table)
      (hash-set! p-table 'language "English")
      (update-file))
    ; retrieve from file
    (define (get-from-file)
      (if [not (file-exists? p-file)]
          (default)
          (begin 
            (update-translation-table)
            (set! p-table (plist->hash p-file)))))
    ; write changes to file
    (define (update-file)
      (hash->plist p-table p-file))
    ; interpret requests
    (define (action msg)
      (cond [(eq? msg 'default) (default)]
            [(eq? msg 'get) p-table]
            [(eq? msg 'get-from-file) (get-from-file)]
            [(eq? msg 'update) (update-file)]
            [(eq? msg 'add) add]
            [(eq? msg 'ref) ref]
            [else (error "Invalid message:" msg)]))
    (get-from-file)
    action))

; the (only) instance of prefs-handler
(define preferences-table (prefs-handler))

; on program load, do this:
(define labels (hash-ref translation-table ((preferences-table 'ref) 'language)))

; set language
(define (set-language! choice evt)
  (let* ([seln-num (send choice get-selection)]
         [seln (list-ref (hash-keys translation-table) seln-num)])
    ; change value of language key in prefs table
    ((preferences-table 'add) 'language seln)
    ; update default choice
    (send choice-translations set-selection seln-num)
    ; write to prefs.plist
    (preferences-table 'update)
    ; tell the user to re-open (a bit weak, will change later)
    (let ([new-labels (hash-ref translation-table ((preferences-table 'ref) 'language))])
      (message-box 
       (hash-ref new-labels 'translation-message1) 
       (hash-ref new-labels 'translation-message2)))))

; show prefs window
(define (edit-prefs btn evt)
  (send frame-prefs show #t))

; close prefs
(define (close-prefs btn evt)  
  (send frame-prefs show #f))

; gui
(define frame-prefs 
  (new frame% 
       [label (hash-ref labels 'prefs)]
       [min-width 150]
       [min-height 50]))
(define vpane 
  (new vertical-pane% 
       [parent frame-prefs] 
       [alignment (list 'center 'center)]))
(define choice-translations 
  (new choice%
       [parent vpane]                                 
       [label (hash-ref labels 'app-language)]
       [choices (hash-keys translation-table)]
       [selection (list-index 
                   (hash-keys translation-table) 
                   ((preferences-table 'ref) 'language))]
       [callback set-language!]))
(define btn-close 
  (new button% 
       [parent vpane] 
       [label (hash-ref labels 'ok)] 
       [callback close-prefs]))



