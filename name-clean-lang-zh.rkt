#lang racket

(require xml
         xml/plist
         "name-clean-plist.rkt")

(provide write-translation-zh)

(define dict-en
  `(dict
    (assoc-pair "language" "简体中文")
    (assoc-pair "name" "名字 Clean")
    (assoc-pair "do-message" "Select some files to rename")
    (assoc-pair "done-message" "Files renamed! Select more files to rename") 
    (assoc-pair "undone-message" "File names reset! Select some files to rename") 
    (assoc-pair "file" "文件")
    (assoc-pair "select-files" "选择文件")
    (assoc-pair "select-dir" "选择文件夹")
    (assoc-pair "quit" "关闭")
    (assoc-pair "edit" "Edit")
    (assoc-pair "prefs" "Preferences")
    (assoc-pair "app-language" "言语")
    (assoc-pair "translation-message1" "言语改成了！")
    (assoc-pair "translation-message2" "请重新开始应用。")
    (assoc-pair "ok" "好")
    (assoc-pair "rename" "Rename files")
    (assoc-pair "clear" "Clear")
    (assoc-pair "undo" "Undo rename")
    (assoc-pair "orig-names" "原来文件名：")
    (assoc-pair "new-names" "新文件名：")
    (assoc-pair "direct-edit1" "FYI")
    (assoc-pair "direct-edit2" "Editing this text does nothing. One day, maybe.")
    (assoc-pair "help" "帮助")
    (assoc-pair "about" "关于")
    (assoc-pair "help-message" "This application will attempt to strip annoying tags out of filenames.
\ne.g. My TV Show S01E01.XviD.h264.Blu-Ray.(lol-cats).avi
\nbecomes\tMy TV Show S01E01.avi
\nIt will also attempt to recognise season and episode numberings and convert them to SxxExx format.
\ne.g. My TV Show [1x01] Pilot.avi
\nbecomes\tMy TV Show S01E01 Pilot.avi\n\nTo use, simply select some files, check that the suggested renamings are good and then click \"Rename files\".
\nAlternatively, select a folder (directory) and Name Clean will suggest renamings for all files in the folder and its subfolders.
\nIf you aren't happy with the suggested renamings, click \"Clear\" to clear the list and select again.")
    (assoc-pair "about-message" "© C.Bowdon\nc.bowdon@gmail.com")))

(define (write-translation-zh)
  (when (file-exists? "lang-zh.plist")
    (delete-file "lang-zh.plist"))
  (call-with-output-file "lang-zh.plist"
    (lambda (out) (write-plist dict-en out))))