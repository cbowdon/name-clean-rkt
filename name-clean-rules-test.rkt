#lang racket

;; In this file: test cases for the renaming rules (effectively tests "Commands.xml")

(require rackunit "name-clean-rules.rkt")

(define rules (get-rules rules-file))

(define white-list
    (list   
     "Season"
     "McStroke"
     "MacDonalds"
     "DeLorean"
     "S99E99"))
  
  (define black-list
    (list
     "[test]"
     "XviD"
     "TotALLy mAD"
     "[2009]"
     "2009"))
  
  (define real-names-bad
    (list
     "Test Space End "
     "Wall-E 2009 XviD"
     "Zombieland.XviD.Blu.Ray"
     "Family Guy [2009]"
     "Kiss.Kiss.Bang.Bang.2009.XviD.(cool)"
     "Dexter 1x01"
     "Arrested Development [2.03]"
     "Family Guy [8x10] McStroke"
     "Family Guy [8.10] McStroke HD"
     "Family Guy [8.10] McStroke HD XviD"
     "District9-720p"
     "spooks [1x01]"
     "Bridesmaids.2011.BRRip.XviD.Ac3.Feel-Free"
     "Pirates of the Caribbean On Stranger Tides (2011) DVDRip XviD-MAXSPEED www.torentz.3xforum.ro"
     "[SomETAgs] Forgot What Program It Was 2011"
     "Red.Cliff.2009.ENGLiSH.HardSubbed.DVDRip.XViD-DaPoO"
     "www.huarenmovie.com@【喜羊羊与灰太狼之兔年顶呱呱】"
     "末日危途.The.Road.2009.DVD-RMVB-人人影视原创听译中文字幕"
     "三个白痴 3 Idiots -人人影视原创翻译中英双语字幕"
     "Bad Teacher[2011]R5 XviD-ExtraTorrentRG"
     "[isoHunt] Huge_Marvel_Comics_Collection.6164385.TPB"
     "秘社.The.Secret.Circle.S01E01.Chi_Eng.HDTVrip.720X400-YYeTs人人影视"
     "超级8.Super.8.2011.DVDSCR-RMVB-人人影视原创翻译中英双语字幕"
     "加勒比海盗4：惊涛怪浪.Pirates.Of.The.Caribbean.On.Stranger.Tides.2011.BD-MP4-人人影视原创翻译中英双语字幕"
     "Archer.S03E01.Heart.of.Archness.Part1.720p.HDTV.X264.2011-bits1bytes2"
     "The.Walking.Dead.S02E03.Save.the.Last.One.HDTV.XviD-FQM.[VTV]"
     "The.Walking.Dead.S02E07.Pretty.Much.Dead.Already.HDTV.XviD-FQM.[VTV]"))
  
  (define real-names-good
    (list
     "Test Space End"
     "Wall-E"
     "Zombieland"
     "Family Guy"
     "Kiss Kiss Bang Bang"
     "Dexter S01E01"
     "Arrested Development S02E03"
     "Family Guy S08E10 McStroke"
     "Family Guy S08E10 McStroke"
     "Family Guy S08E10 McStroke"
     "District9"
     "Spooks S01E01"
     "Bridesmaids"
     "Pirates of the Caribbean On Stranger Tides"
     "Forgot What Program It Was"
     "Red Cliff"
     "喜羊羊与灰太狼之兔年顶呱呱"
     "末日危途 The Road"
     "三个白痴 3 Idiots"
     "Bad Teacher"
     "Huge Marvel Comics Collection"
     "秘社 The Secret Circle S01E01"
     "超级8 Super 8 " ; OMG MASSIVE CHEAT RIGHT HERE
     "加勒比海盗4：惊涛怪浪 Pirates Of The Caribbean On Stranger Tides"
     "Archer S03E01 Heart of Archness Part1"
     "The Walking Dead S02E03 Save the Last One"
     "The Walking Dead S02E07 Pretty Much Dead Already"))
  
(define/provide-test-suite rules-tests
  
  (test-case 
   "Check all rules provides correct types"
   (stream-for-each (lambda (x) (check-pred symbol? (car x))) rules)
   (stream-for-each (lambda (x) (check-pred regexp? (cdr x))) rules))
  
  (test-case
   "White-list: all should be allowed"
   (for-each check-equal? 
             (map (lambda (x) (apply-rules x rules)) white-list) 
             white-list))
  
  (test-case
   "Black-list: all should be deleted"
   (for-each check-equal? 
             (map (lambda (x) (apply-rules x rules)) black-list) 
             (map (lambda (x) "") black-list)))
  
  (check-equal? (apply-rules "Piers Morgan" rules) "Pillock")
  
  (test-case
   "Real names test"
   (map check-equal? 
        (map (lambda (x) (apply-rules x rules)) real-names-bad) 
        real-names-good)))