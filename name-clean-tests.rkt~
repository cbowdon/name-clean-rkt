#lang racket

;; In this file: unified unit-testing

(require rackunit
         rackunit/text-ui
         "name-clean-rules-test.rkt"
         "name-clean-handle-test.rkt"
         "name-clean-plist-test.rkt"
         "name-clean-helper-functions-test.rkt"
         "name-clean-gui-main-test.rkt")

(define-test-suite all-tests
  rules-tests
  handle-tests
  plist-tests
  helper-function-tests
  gui-tests)

(run-tests all-tests)
