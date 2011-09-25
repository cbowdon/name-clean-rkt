#lang racket

(require xml
         xml/plist
         "name-clean-plist.rkt")

(provide write-translation-zh)

(define dict-en
  `(dict
    (assoc-pair "language" "简体中文")
    (assoc-pair "name" "文件名清洁助手")
    (assoc-pair "do-message" "选择您想清洁的文件")
    (assoc-pair "done-message" "成功") 
    (assoc-pair "undone-message" "还原完成") 
    (assoc-pair "file" "文件")
    (assoc-pair "select-files" "选择文件")
    (assoc-pair "select-dir" "选择文件夹")
    (assoc-pair "quit" "关闭")
    (assoc-pair "edit" "修改")
    (assoc-pair "prefs" "设置")
    (assoc-pair "app-language" "言语")
    (assoc-pair "translation-message1" "言语改成了！")
    (assoc-pair "translation-message2" "请重新开始应用。")
    (assoc-pair "ok" "好")
    (assoc-pair "rename" "清洁文件名")
    (assoc-pair "clear" "清空")
    (assoc-pair "undo" "还原文件名")
    (assoc-pair "orig-names" "原文件名：")
    (assoc-pair "new-names" "新文件名：")
    (assoc-pair "direct-edit1" "FYI")
    (assoc-pair "direct-edit2" "Editing this text does nothing. One day, maybe.")
    (assoc-pair "help" "帮助")
    (assoc-pair "about" "关于")
    (assoc-pair "help-message" "本程序主要应用于去掉原文件名中无用的部分：
\n举例 从 My TV Show S01E01.XviD.h264.Blu-Ray.(lol-cats).avi
\n到 My TV Show S01E01.avi
\n同时本程序也可以识别剧集的命名规则：
\n举例 从 My TV Show [1x01] Pilot.avi
\n到 My TV Show S01E01 Pilot.avi
\n应用时您只需选择需要清洁的文件, 查看“新文件名”框内的预览是否正确, 然后点击“清洁文件名”。
\n或者, 您也可以直接选择您需要清洁的文件所在的文件夹, 本程序将自动将该文件夹内全部的文件名进行清洁。
\n如果您不满意清洁后的文件名, 您可以点击“还原文件名”, 重新选择您希望清洁的文件。")
    (assoc-pair "about-message" "© C.Bowdon\nc.bowdon@gmail.com")))

(define (write-translation-zh)
  (when (file-exists? "lang-zh.plist")
    (delete-file "lang-zh.plist"))
  (call-with-output-file "lang-zh.plist"
    (lambda (out) (write-plist dict-en out))))