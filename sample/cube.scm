(add-load-path "../lib")
(use srfi-1)
(use ubigraph)

(define *server* (init-ubigraph))
(define *n* 10)

(clear *server*)

(define (idx i j k n)
  (+ (* i n n) (* j n) k))

;;========== Main
(define (main args)
  (for-each (lambda (i)
    (for-each (lambda (j)
      (for-each (lambda (k)
                  (make-vertex *server* (idx i j k *n*))
                  (if (> i 0) 
                    (make-edge (idx i j k *n*) (idx (- i 1) j k *n*) *server*))
                  (if (> j 0)
                    (make-edge (idx i j k *n*) (idx i (- j 1) k *n*) *server*))
                  (if (> k 0)
                    (make-edge (idx i j k *n*) (idx i j (- k 1) *n*) *server*))) 
                (iota *n* 0))) 
              (iota *n* 0))) 
            (iota *n* 0)))
