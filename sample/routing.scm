(add-load-path "../lib")
(use srfi-1)
(use srfi-13)
(use srfi-27)
(use ubigraph)

(define *server* (init-ubigraph))
(define *dim* 7) ; Number of dimensions for hypercube
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

(define (set-active-vertex v)
  (set-color-vertex v "#FF4B30" *server*))

(define (set-init-vertex v)
  (set-shape-vertex v "sphere" *server*)
  (set-color-vertex v "#F4FF85" *server*)
  (set-size-vertex v "0.25" *server*))

(define (integer->binary n)
  (define (loop i ret)
    (cond [(<= i 0)
           (if (string-null? ret) "0" ret)]
          [else (loop (quotient i 2) 
                      (string-join (list (number->string (remainder i 2)) ret) ""))]))
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
                      (set-strength-edge e 
                                         (number->string (expt (/ 1.0 (+ j 1)) 1.5)) *server*))))
                (iota *dim* 0)))
              (iota *r* 0)))
  (loop1 0)
  (loop2))

(define (animate-arrow e rev)
  (let ((pos (cond [(string=? rev "true") 1.0] 
                   [(string=? rev "false") 0.0]
                   [else (error "animate-arrow needs 
                                \"true\" or \"false\", but got;" rev)])))
    (set-arrowposition-edge e (number->string pos) *server*)
    (set-arrowreverse-edge e rev *server*)
    (set-arrow-edge e "true" *server*)
    (for-each (lambda (i)
                (let ((a (if (string=? rev "true") (- 1.0 (/ i 19.0)) (/ i 19.0))))
                  (set-arrowposition-edge e (number->string a) *server*)
                  (sys-nanosleep 50000000))) (iota 20 0))
    (set-arrow-edge e "false" *server*)))


;;========== Main
(define (main args)
  (invisible-graph)
  (init-vertex-style)
  (init-graph)
  (reveal-graph)
  (let ((pos 0))
    (for-each (lambda (i) 
      (let ((next-pos (random-integer *r*))
            (v-from pos))
        (set-active-vertex pos)
        (set-active-vertex next-pos)
        (for-each (lambda (j)
                    (let* ((k (expt 2 j))
                           (diff (- (logand next-pos k) (logand pos k)))
                           (v-to (+ v-from diff))
                           (e (if (<= v-from v-to) 
                                (+ (* v-from *r*) v-to)
                                (+ (* v-to *r*) v-from))))
                      (cond [(> diff 0) (animate-arrow e "false")]
                            [(< diff 0) (animate-arrow e "true")])
                      (set! v-from v-to)))
                  (iota *dim* 0))
        (set-init-vertex pos)
        (sys-nanosleep 500000000)
        (set! pos next-pos))) 
              (iota 10 0))))
