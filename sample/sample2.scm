(add-load-path "../lib")
(use ubigraph)

;;========== Main
(define (main args)
  (let ((server (init-ubigraph)))
    (make-vertex server)))
