(add-load-path "../lib")
(use ubigraph)

(define *server* (init-ubigraph))

(clear *server*)

(define (animate-arrow-position e)
  ())

;;========== Main
(define (main args)
  (let ((v1 (make-vertex *server*))
        (v2 (make-vertex *server*)))
    (for-each (lambda (x) (set-shape-vertex x "sphere" *server*)) (list v1 v2))
    (for-each (lambda (x) (set-color-vertex x "#F4FF85" *server*)) (list v1 v2))
    (let ((e12 (make-edge v1 v2 *server*)))
      (set-arrow-edge e12 "true" *server*)
      (set-width-edge e12 "4" *server*)
      (animate-arrow-position e12))))
