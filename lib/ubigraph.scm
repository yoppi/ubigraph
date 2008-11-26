(define-module ubigraph
  (use rfc.uri)
  (use xsm.xml-rpc.client)
  (export *ubigraph-version*))
(select-module ubigraph)

(define *ubigraph-version* "0.0.1")

(define-class <vertex> ()
  )

(define (make-vertex))

(define-class <edge> ()
  )

(define (make-edge))

(define-class <ubigraph-client> ()
  ((host :init-keyword :host :init-value "localhost" :accessor host-of)
   (port :init-keyword :port :init-value 20738 :accessor port-of)
   (path :init-keyword :path :accessor "RPC2" path-of)
   (server :init-keyword :server :accessor sever-of)))

(define-method initialize ((self <ubigraph-client>) initargs)
  (next-method)
  (set! (sever-of self)
    (make-xml-rpc-client (uri-compose ))))

(define (make-ubigraph-client . args)
  (let-optionals* args ())
  (make <ubigraph-client>))

(define  (init-ubigraph . args)
  (let-optionals* args ((host "localhost")
                        (port 20738))
    make-ubigraph-client host port))

(provide "ubigraph")

