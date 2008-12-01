(add-load-path "../lib")
(use srfi-1)
(use ubigraph)

(define *server* (init-ubigraph))

(clear *server*)

(define (set-defalt-vertex-style)
  (set-style-vertex "shape" "none" *server*))

(define (set-leaf-vertex-style v)
  (set-shape-vertex v "sphere" *server*)
  (set-color-vertex v "#80219C" *server*)
  (set-size-vertex v "3.0" *server*))

(define (init-edge-style)
  (set-style-edge "oriented" "true" *server*)
  (set-style-edge "color" "#C5892F" *server*))

(define (subtree parent n)
  (let* ((v (make-vertex *server*))
        (e (make-edge parent v *server*)))
    (set-width-edge e (number->string (+ 1.0 n)) *server*)
    (cond [(> n 0)
           (for-each (lambda (i) 
                       (subtree v (- n 1))) (iota 2 0))]
          [else (set-leaf-vertex-style v)
                (sys-nanosleep 20000000)])
    v))

;;========== Main
(define (main args)
  (set-defalt-vertex-style)
  (init-edge-style)
  (let ((root (make-vertex *server*)))
    (set-label-vertex root "root" *server*)
    (subtree root 8)))
