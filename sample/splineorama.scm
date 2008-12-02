(add-load-path "../lib")
(use srfi-1)
(use srfi-27)
(use ubigraph)

(define *server* (init-ubigraph))

(clear *server*)

(define (init-style-vertex)
  (set-style-vertex "shape" "sphere" *server*)
  (set-style-vertex "color" "#FFFF00" *server*))

(define (init-style-edge)
  (set-style-edge "spline" "true" *server*))

(define (set-dashed-style e)
  (set-stroke-edge e "dashed" *server*)
  (set-width-edge e "2.0" *server*))

(define (range from to)
  (define (loop i ret)
    (cond [(= i to) (reverse ret)]
          [else (loop (+ i 1) (cons i ret))]))
  (loop from '()))

;;========== Main
(define (main args)
  (init-style-vertex)
  (init-style-edge)
  (let ((n 40))
    (for-each (lambda (i)
                (make-vertex *server* i)
                (set-color-vertex i (number->string i) *server*)) (iota n 0))
    (set-size-vertex 0 "5.0" *server*)
    (for-each (lambda (i)
      (for-each (lambda (j)
        (when (< (random-real) (/ 4.0 n))
          (let ((e (make-edge i j *server*)))
            (set-dashed-style e)
            (set-color-edge e (number->string i) *server*))))
                (range (+ i 1) n)))
              (range 0 n))
    (for-each (lambda (i)
      (make-edge 0 i *server*)) (iota (- n 1) 1))))
