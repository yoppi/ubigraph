(add-load-path "../lib")
(use srfi-1)
(use ubigraph)

(define *server* (init-ubigraph))

(clear *server*)

(define (init-vertex-style)
  (set-style-vertex "shape" "sphere" *server*)
  (set-style-vertex "color" "#00FF00" *server*)
  (set-style-vertex "size" "0.3" *server*))

(define (init-edge-style)
  (set-style-edge "spline" "true" *server*))

;;========== Main
(define (main args)
  (init-vertex-style)
  (init-edge-style)
  (let ((x (make-vertex *server*))
        (y (make-vertex *server*)))
    (for-each (lambda (_)
                (make-edge x y *server*)
                (sys-nanosleep 500000000)) (iota 50 0))))
