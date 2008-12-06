(use srfi-1)
(use util.queue)
(use ubigraph)

(define *server* (init-ubigraph))
(define *tasks* (make-queue))

(clear *server*)

(define-syntax define-coroutine
  (syntax-rules ()
    [(_ (routine yield) body ...)
     (define (routine)
       (call/cc (lambda (return)
                  (define (yield)
                    (call/cc (lambda (cont)
                               (enqueue! *tasks* cont)
                               (return))))
                  body ...))
       ((dequeue! *tasks*)))]
    [(_ (routine (yield exit)) body ...)
     (define (routine)
       (call/cc (lambda (escape)
                  (call/cc (lambda (return)
                             (define (yield)
                               (call/cc (lambda (cont)
                                          (enqueue! *tasks* cont)
                                          (return))))
                             (define (exit)
                               (call/cc (lambda (cont)
                                          (enqueue! *tasks* cont)
                                          (escape))))
                             body ...))
                  ((dequeue! *tasks*)))))]
    [(_ (routine n (yield)) body ...)
     (define (routine n)
       (call/cc (lambda (return)
                  (define (yield)
                    (call/cc (lambda (cont)
                               (enqueue! *tasks* cont)
                               (return))))
                  body ...))
       ((dequeue! *tasks*)))]
    ))

(define (coroutine-init! . rs)
  (set! *tasks* (make-queue))
  (for-each (lambda (r) 
              (enqueue! *tasks* r)) rs))


(define *val* #f)

(define-coroutine (printer (yield exit))
  (let ((parent #f))
    (define (loop)
      (cond [(equal? parent *val*) (exit)]
            [else 
              (make-vertex  *server* *val*)
              (when (not (equal? parent #f))
                (make-edge parent *val* *server*))
              (set! parent *val*)
              (yield)
              (loop)]))
    (loop)))

(define-coroutine (evaluator n (yield))
  (define (loop)
    (for-each (lambda (i)
                (set! *val* i)
                (sys-nanosleep 20000000)
                (yield)) 
              (iota n 1)))
  (loop))


;;========== Main
(define (main args)
  (coroutine-init! printer)
  (evaluator 10))
