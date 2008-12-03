#!/usr/bin/env gosh

;;; 
;;; install - Install the ubigraph library
;;; Copyright (c) 2008 yoppi <y.hirokazu@gmail.com>
;;;
;;; Permission is hereby granted, free of charge, to any person obtaining a copy
;;; of this software and associated documentation files (the "Software"), to deal
;;; in the Software without restriction, including without limitation the rights
;;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;;; copies of the Software, and to permit persons to whom the Software is
;;; furnished to do so, subject to the following conditions:
;;;
;;; The above copyright notice and this permission notice shall be included in
;;; all copies or substantial portions of the Software.
;;;
;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
;;; THE SOFTWARE.
;;;

(use file.util)

(define *default-destdir* (gauche-site-library-directory))

(define (install-directory from to)
  (if (file-is-directory? from)
    (directory-fold from
                    (lambda (file knil)
                      (let ((target (sys-dirname
                                      (string-scan file from 'after))))
                        (install-file file
                                      (string-append to target))))
                    #t
                    :lister
                    (lambda (dir knil)
                      (let ((target (string-scan dir from 'after)))
                        (make-installed-directory
                          (build-path to (rxmatch-after (#/^\/*/ target))))
                        (directory-list dir
                                        :children? #t
                                        :add-path? #t))))))

(define (install-file file dir)
  (let ((target (build-path dir (sys-basename file))))
    (print #`"installing ,|file| => ,|target|")
    (copy-file file
               target
               :if-exists :supersede
               :safe #t)
    (sys-chmod target #o644)))

(define (make-installed-directory dir)
  (print #`"making installed directory ,|dir|")
  (make-directory* dir)
  (sys-chmod dir #o755))

(define (main args)
  (install-directory "lib" *default-destdir*))
