(add-load-path "../lib")
(use srfi-1)
(use srfi-13)
(use ubigraph)

(define *server* (init-ubigraph))
(define *dim* 3) ; Number of dimensions for hypercube
;(define *active-vertex* (make-vertex *server*))
(define *r* (expt 2 *dim*))

(clear *server*)

(define (invisible-graph)
  (set-visible-vertex "false" *server*)
  (set-visible-edge "false" *server*))

(define (reveal-graph)
  (set-visible-vertex "true" *server*)
  (set-visible-edge "true" *server*))

(define (init-vertex-style)
  (set-style-vertex "shape" "sphere" *server*)
  (set-style-vertex "color" "#F4FF85" *server*)
  (set-style-vertex "size" "0.25" *server*))

(define (integer->binary n)
  (define (loop i ret)
    (cond [(<= i 0)
           (if (string-null? ret) "0" ret)]
          [else (loop (quotient i 2) (string-join (list (number->string (remainder i 2)) ret) ""))]))
  (loop n ""))

(define (power))

(define (init-graph)
  (define (loop1 i)
    (cond [(>= i *r*)]
          [else (make-vertex *server* i)
                (set-label-vertex i (integer->binary i) *server*)
                (loop1 (+ i 1))]))
  (define (loop2)
    (for-each (lambda (i)
      (for-each (lambda (j)
                  (let* ((k (expt 2 j))
                         (e (+ (* i *r*) (+ i k))))
                    (when (eq? (logand i k) 0)
                      (make-edge i (+ i k) *server* e)
                      (set-strength-edge e (number->string (expt (/ 1.0 (+ j 1)) 1.5)) *server*))))
                (iota *dim* 0)))
              (iota *r* 0)))
  (loop1 0)
  (loop2))

;;========== Main
(define (main args)
  (invisible-graph)
  (init-vertex-style)
  ;(set-color-vertex *active-vertex* "#FF4B30" *server* )
  (init-graph)
  (reveal-graph))
