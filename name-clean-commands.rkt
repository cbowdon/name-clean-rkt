#lang racket

(require xml)

(provide copy-master-rules-file
         rules-file-loc)

(define master-rules-file-name "MasterRules.xml")
(define rules-file-name ".NameCleanRules.xml")
(define rules-file-loc (build-path (find-system-path 'home-dir) rules-file-name))

; find directory where resources are kept
(define (get-resources-dir)
  (let ([system (system-type 'os)]
        [exe-dir (path-only (find-system-path 'run-file))])
    (cond [(eq? system 'macosx) 
           (apply build-path (append (drop-right (explode-path exe-dir) 1) '("Resources")))]
          [(eq? system 'windows) exe-dir]
          [(eq? system 'unix) (find-system-path 'home-dir)])))

; copy from resources directory into rules-file-loc
(define (copy-master-rules-file)
  (let ([master (build-path (get-resources-dir) master-rules-file-name)])
    (if [file-exists? master]
        (copy-file master rules-file-loc)
        (write-default-commands))))

; predicate for when to write new commands
; not complete yet though - we shouldn't overwrite a file the user has changed themselves.
; what to do?
(define (overwrite?)
  (or (not (file-exists? rules-file-loc))
       (< (file-or-directory-modify-seconds rules-file-loc) (file-or-directory-modify-seconds find-executable-path))))


; write the hard-coded defaults
(define (write-default-commands)
  (when (not (file-exists? rules-file-loc))
    (call-with-output-file rules-file-loc
      (lambda (out)
        (write-xml/content default-commands out)))))

; the hard-coded defaults
(define default-commands
  (xexpr->xml
   (add-between 
    '(Commands
      "\n"
      (toSintEint () "[Ss][0-9]+[Ee][0-9]+")
      (toSintEint () "\\[[0-9]+\\.[0-9]+\\]")
      (toSintEint () "\\[[0-9]+x[0-9]+\\]")
      (toSintEint () "[0-9]+x[0-9]+")
      "\n"     
      (delete () "www\\..+\\.(ro|com|ru|cn)")
      "\n"     
      (space () "\\.")
      (space () "(?=\\[)")
      (space () "\\_")
      "\n"
      (allow () "S[0-9][0-9]?E[0-9][0-9]?")
      (allow () "Season|season")
      (allow () "Episode|episode")
      (allow () " [0-9][0-9]? ")
      (allow () "Ma?c[A-Z][a-z][a-z]+")
      (allow () "DeLorean")
      (allow () " I ")
      (allow () " II ")
      (allow () " III ")
      (allow () " IV ")
      (allow () " V ")
      (allow () " VI ")
      (allow () " VII ")
      (allow () " VIII ")
      (allow () " IX ")
      (allow () " X ")
      "\n"
      (delete () "^\\[.+\\]")
      (delete () "[A-Za-z]+[0-9]+([a-z]+[0-9]+)+")
      (delete () "[A-Z]+[a-z]?[0-9]")
      (delete () "[a-z][0-9][0-9]+")
      (delete () "www\\.[A-Za-z]\\.")
      (delete () "@")
      (delete () "\\[.+\\]")
      (delete () "(19|20)[0-9][0-9]")
      (delete () "\\[[^0-9]+\\]")
      (delete () "\\([^0-9]+\\)")
      (delete () "^(1080)|(720)p")
      (delete () "[0-9][0-9][0-9][0-9]?[Xx][0-9][0-9][0-9][0-9]?")     
      (delete () "([Xx]|[Hh])[Vv][Ii][Dd]")
      (delete () "(HDTV|hdtv|WEB|web)[Rr][Ii][Pp]")
      (delete () "[Hh][Dd][Tt][Vv]")
      (delete () " ?HD")
      (delete () "Blu(\\.|\\-|\\_| )*Ray")
      (delete () "[Xx]264")
      (delete () "[A-Z]*[a-z]+[A-Z]+[a-z]*.*")
      (delete () "[A-Z][A-Z]+")
      (delete () "\\.[A-Za-z]+")
      (delete () "\\..*")
      (delete () "[Dd][Vv][Dd][Rr][Ii][Pp]")
      (delete () "(dvd|DVD)")
      (delete () "[A-Za-z][Rr][Ii][Pp]")
      (delete () " [Ii][Pp]")
      (delete () "[0-9][0-9][0-9][0-9][0-9]+")
      (delete () "[A-Z][a-z]+\\-[A-Z][a-z]+")
      (delete () "深影字幕组")
      (delete () "人人影视原创")
      (delete () "听译")
      (delete () "翻译中英双语字幕")
      (delete () "中文字幕")
      (delete () "中英双语字幕")
      (delete () "(Chi Eng|Eng Chi)")
      "\n"
      (Pillock () "Piers Morgan")
      "\n"
      (delete () "\\(\\)")
      (delete () "\\[\\]")
      (delete () "【")
      (delete () "】")
      (delete () " \\-")
      (space () "  +")
      (delete () "\\- ?$")
      (delete () "^ ")
      (delete () " $")
      "\n")
    "\n")
   ))