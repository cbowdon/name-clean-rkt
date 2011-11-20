#lang racket

(require xml
         xml/plist
         "name-clean-plist.rkt")

(provide write-translation-en)

(define dict-en
  `(dict
    (assoc-pair "language" "English")
    (assoc-pair "name" "Name Clean")
    (assoc-pair "do-message" "Select some files to rename")
    (assoc-pair "done-message" "Files renamed! Select more files to rename") 
    (assoc-pair "undone-message" "File names reset! Select some files to rename")
    (assoc-pair "file" "File")
    (assoc-pair "select-files" "Select file(s)")
    (assoc-pair "select-dir" "Select directory")
    (assoc-pair "quit" "Quit")
    (assoc-pair "edit" "Edit")
    (assoc-pair "prefs" "Preferences")
    (assoc-pair "app-language" "Language")
    (assoc-pair "translation-message1" "Language changed!")
    (assoc-pair "translation-message2" "Please restart the application.")
    (assoc-pair "ok" "Ok")
    (assoc-pair "rename" "Rename files")
    (assoc-pair "undo" "Undo rename")
    (assoc-pair "clear" "Clear")
    (assoc-pair "orig-names" "Original filenames:")
    (assoc-pair "new-names" "New filenames:")
    (assoc-pair "direct-edit1" "FYI")
    (assoc-pair "direct-edit2" "Editing this text does nothing. One day, maybe.")
    (assoc-pair "help" "Help")
    (assoc-pair "about" "About")
    (assoc-pair "help-message" "This application will attempt to strip annoying tags out of filenames.
\ne.g. My TV Show S01E01.XviD.h264.Blu-Ray.(lol-cats).avi
\nbecomes\tMy TV Show S01E01.avi
\nIt will also attempt to recognise season and episode numberings and convert them to SxxExx format.
\ne.g. My TV Show [1x01] Pilot.avi
\nbecomes\tMy TV Show S01E01 Pilot.avi\n\nTo use, simply select some files, check that the suggested renamings are good and then click \"Rename files\".
\nAlternatively, select a folder (directory) and Name Clean will suggest renamings for all files in the folder and its subfolders.
\nIf you aren't happy with the suggested renamings, click \"Clear\" to clear the list and select again.")
    (assoc-pair "about-message" "© C.Bowdon\nc.bowdon@gmail.com")))

(define (write-translation-en)  
  (when (file-exists? "lang-en.plist")
    (delete-file "lang-en.plist"))  
  (call-with-output-file "lang-en.plist"
    (lambda (out) (write-plist dict-en out))))