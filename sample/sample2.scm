(add-load-path "../lib")
(use ubigraph)

;;========== Main
(define (main args)
  (let ((server (init-ubigraph)))
    (let* ((v1 (make-vertex server))
          (v2 (make-vertex server))
          (e12 (make-edge v1 v2 server)))
      (for-each (lambda (x) (set-size-vertex x "3.0" server)) (list v1 v2))
      (set-shapedetail-vertex v1 "30" server)
      (set-shape-vertex v1 "torus" server)
      (set-)))
  )
