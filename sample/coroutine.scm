(use srfi-1)
(use util.queue)
(use ubigraph)

(define *server* (init-ubigraph))

(clear *server*)

(define *tasks* (make-queue))

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
    [(_ (routine yield) body ...)
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
                  ((dequeue! *tasks*)))))]))

(define (coroutine-init! . rs)
  (set! *tasks* (make-queue))
  (for-each (lambda (r)
              (enqueue! *tasks* r)) rs))

(define ())

;;========== Main
(define (main args)
  ())
