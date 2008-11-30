(add-load-path "../lib")
(use ubigraph)

(define *server* (init-ubigraph))

(clear *server*)

(define (invisible-graph)
  (set-visible-vertex 0 "false" *server*)
  (set-visible-edge 0 "false" *server*))

(define (reveal-graph)
  (set-visible-vertex 0 "true" *server*)
  (set-visible-edge 0 "true" *server*))

;;========== Main
(define (main args)
  (invisible-graph)
  (make-vertex *server*)
  (sys-sleep 5)
  (reveal-graph)
