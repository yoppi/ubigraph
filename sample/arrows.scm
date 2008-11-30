(add-load-path "../lib")
(use ubigraph)

(define *server* (init-ubigraph))

(clear *server*)

(define (animate-arrow-position e)
  (define (loop1 i)
    (cond [(>= i 20)]
          [else (set-arrowposition-edge e (number->string (/ i 19.0)) *server*) 
           (sys-nanosleep 50000000)
           (loop1 (+ i 1))]))
  (define (loop2 i)
    (cond [(>= i 20)]
          [else (set-arrowposition-edge e (number->string (- 1.0 (/ i 19.0))) *server*)
           (sys-nanosleep 50000000)
           (loop1 (+ i 1))]))
  (set-arrowreverse-edge e "false" *server*)
  (loop1 0)
  (set-arrowreverse-edge e "true" *server*)
  (loop2 0)
  (set-arrowreverse-edge e "false" *server*))

(define (animate-arrow-length e)
  (define (loop i)
    (cond [(>= i 13)]
          [else (set-arrowlength-edge e (number->string (/ (+ i 1) 7.0)) *server*)
           (sys-nanosleep 50000000)
           (loop (+ i 1))]))
  (set-arrowposition-edge e "0.5" *server*)
  (loop 0))

(define (animate-arrow-radius e)
  (define (loop i)
    (cond [(>= i 20)]
          [else (set-arrowradius-edge e (number->string (/ (+ i 1) 10.0)) *server*)
                (sys-nanosleep 50000000)
                (loop (+ i 1))]))
  (loop 0))

;;========== Main
(define (main args)
  (let ((v1 (make-vertex *server*))
        (v2 (make-vertex *server*)))
    (for-each (lambda (x) (set-shape-vertex x "sphere" *server*)) (list v1 v2))
    (for-each (lambda (x) (set-color-vertex x "#F4FF85" *server*)) (list v1 v2))
    (let ((e12 (make-edge v1 v2 *server*)))
      (set-arrow-edge e12 "true" *server*)
      (animate-arrow-position e12)
      (animate-arrow-length e12)
      (animate-arrow-radius e12))))
