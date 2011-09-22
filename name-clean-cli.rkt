#lang racket
(require "name-clean-handle.rkt")

; provided for test purposes
(provide parse-cmd-line)

; process command-line arguments
(define (proc-args proc args)
  (let* ([paths (if (list? args)
                    (map string->path args)
                    (string->path args))]
         [filenames-in (handle-input paths)]
         [filenames-out (map get-new-path filenames-in)])
    (for-each proc filenames-in filenames-out)))

; print nicely to current output
(define (print x y) 
  (let-values ([(path1 name1 bool1) (split-path x)]
               [(path2 name2 bool2) (split-path y)])
    (printf "~a \n---> ~a \n" name1 name2)))

; params
(define rename-mode (make-parameter #f))
(define verbose-mode (make-parameter #f))

; parse flags for params
(define (parse-flags cmd)
  (cond [(equal? cmd "-v") (verbose-mode #t)]
        [(equal? cmd "-r") (rename-mode #t)]
        [else #f]))  

; help message for params
(define help-message 
  (string-append "-v\tverbose-mode: print suggested new names \n\t(default: OFF)\n"
                 "-r\trename-mode: do renaming operation \n\t(default: OFF)\n"))

; strip flags from cmd-line before continuing
(define (remove-flags cmd-line)
  (filter (lambda (x) (not (regexp-match "^-[a-z]$" x))) cmd-line))

; parse command line flags and arguments
(define (parse-cmd-line cur-cmd-line)
  (let ([ccl (vector->list cur-cmd-line)])
    (if (empty? ccl)
        (display help-message)
        (begin (for-each parse-flags ccl)
               (when (verbose-mode)
                 (proc-args print (remove-flags ccl)))
               (when (rename-mode)               
                 (proc-args rename-file-or-directory (remove-flags ccl)))))))

; run main loop
(parse-cmd-line (current-command-line-arguments))
