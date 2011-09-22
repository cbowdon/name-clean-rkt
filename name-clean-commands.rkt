#lang racket

(require xml)

(provide write-default-commands)

(define (write-default-commands)
  (when (not (file-exists? "Commands.xml"))
    (call-with-output-file "Commands.xml"
      (lambda (out)
        (write-xml/content default-commands out)))))

(define default-commands
  (xexpr->xml
   '(Commands
     ()
     "\n\n  "
     (toSintEint () "[Ss][0-9]+[Ee][0-9]+")
     "\n  "
     (toSintEint () "\\[[0-9]+\\.[0-9]+\\]")
     "\n  "
     (toSintEint () "\\[[0-9]+x[0-9]+\\]")
     "\n  "
     (toSintEint () "[0-9]+x[0-9]+")
     "\n  \n  "
     (delete () "www\\..+\\.(ro|com|ru|cn)")
     "\n\n  "
     "\n  "
     (space () "\\.")
     "\n  "
     (space () "(?=\\[)")
     "\n  "
     (space () "\\_")
     "\n\n  "
     "\n  "
     (allow () "S[0-9][0-9]?E[0-9][0-9]?")
     "\n  "
     (allow () "Season|season")
     "\n  "
     (allow () "Episode|episode")
     "\n  "
     (allow () " [0-9][0-9]? ")
     "\n  "
     (allow () "Ma?c[A-Z][a-z][a-z]+")
     "\n  "
     (allow () "DeLorean")
     "\n  "
     (allow () " I ")
     "\n  "
     (allow () " II ")
     "\n  "
     (allow () " III ")
     "\n  "
     (allow () " IV ")
     "\n  "
     (allow () " V ")
     "\n  "
     (allow () " VI ")
     "\n  "
     (allow () " VII ")
     "\n  "
     (allow () " VIII ")
     "\n  "
     (allow () " IX ")
     "\n  "
     (allow () " X ")
     "\n    \n  "
     "\n  "
     (delete () "Blu(\\.|\\-|\\_| )*Ray")
     "\n  "
     (delete () "^\\[.+\\]")
     "\n  "
     (delete () "x264")
     "\n  "
     (delete () "[A-Z][a-z]?[0-9]")
     "\n  "
     (delete () "[a-z][0-9][0-9]+")
     "\n  "
     (delete () "www\\.[A-Za-z]\\.")
     "\n  "
     (delete () "@")
     "\n  "
     (delete () "\\[.+\\]")
     "\n  "
     (delete () "(19|20)[0-9][0-9]")
     "\n  "
     (delete () "^(1080)|(720)p")
     "\n  "
     (delete () "\\[[^0-9]+\\]")
     "\n  "
     (delete () "\\([^0-9]+\\)")
     "\n  "
     (delete () "[A-Z]*[a-z]+[A-Z]+[a-z]*.*")
     "\n  "
     (delete () "([Xx]|[Hh])[Vv][Ii][Dd]")
     "\n  "
     (delete () " ?HD")
     "\n  "
     (delete () "[A-Z][A-Z]+")
     "\n  "
     (delete () "hdtv")
     "\n  "
     (delete () "\\.[A-Za-z]+")
     "\n  "
     (delete () "\\..*")
     "\n  "
     (delete () "(dvd)|(DVD)")
     "\n  "
     (delete () "[A-Za-z][Rr][Ii][Pp]")
     "\n  "
     (delete () " [Ii][Pp]")
     "\n  "
     (delete () "[0-9][0-9][0-9][0-9][0-9]+")
     "\n  "
     (delete () "[A-Z][a-z]+\\-[A-Z][a-z]+")
     "  \n  "
     (delete () "人人影视原创")
     "\n  "
     (delete () "听译")
     "\n  "
     (delete () "翻译中英双语字幕")
     "\n  "
     (delete () "中文字幕")
     "\n  "
     (delete () "中英双语字幕")
     "\n\n  "
     "\n  "
     (Pillock () "Piers Morgan")
     "\n\n  "
     "\n  "
     (delete () "\\(\\)")
     "\n  "
     (delete () "\\[\\]")
     "\n  "
     (delete () "【")
     "\n  "
     (delete () "】")
     "\n  "
     (delete () " \\-")
     "\n  "
     (space () "  +")
     "\n  "
     (delete () "\\- ?$")
     "\n  "
     (delete () "^ ")
     "\n  "
     (delete () " $")
     "\n      \n")))