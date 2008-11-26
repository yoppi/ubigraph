;;;
;;; ubigraph - interface of Ubigraph library
;;;

(define-module ubigraph
  (use srfi-1)
  (use rfc.uri)
  (use xsm.xml-rpc.client) ;to use XML-RPC
  (export *ubigraph-version* make-vertex make-edge make-ubigraph-client init-ubigraph 
          clear call))
(select-module ubigraph)

(define *ubigraph-version* "0.0.1")
;(define *server* '())


;;==================== Vertex 
;(define-class <vertex> ()
;  ((id :init-keyword :id :accessor id-of)))

;(define-method initialize ((self <vertex>) initargs)
;  (next-method)
;  (if (null? (id-of self))
;    (make-vertex-with-id (id-of self))
;    (make-vertex)))

;(define (new-vertex . args)
;  (let-optionals* args ((id #f))
;    (if (eq? id #f)
;      (make-vertex-with-id id)
;      (make-vertex))))

(define (make-vertex server . args)
  (let-optionals* args ((id #f))
    (if (eq? id #f)
      (call server "ubigraph.new_vertex")
      (call server "Ubigraph.new_vertex_w_id" id))))

;(define-method draw-vertex ((self <vertex>) server)
;  (call server ))


;;==================== Edge between Vertexes
;(define-class <edge> ()
;  ((id :init-keyword :id :accessor id-of)))

;(define-method initialize ((self <edge>) initargs)
;  (next-method)
;  (if (null? (id-of self))
;    (make-edge-with-id)
;    (make-edge)))

;(define (make-edge from to . args)
;  (let-optionals* args ((id #f))
;    (if (eq? id #f)
;      (make-edge-with-id id)
;      (make-edge))))

(define (make-edge from to . args)
  (let-optionals* args ((id #f))
    (if (eq? id #f)
      (call server "ubigraph.new_edge" from to)
      (call server "Ubigraph.new_edge_w_id" id from to))))


;;==================== Ubigraph Client
(define-class <ubigraph-client> ()
  ;((host :init-keyword :host :init-value "localhost" :accessor host-of)
  ; (port :init-keyword :port :init-value 20738 :accessor port-of)
  ; (path :init-keyword :path :accessor "RPC2" path-of)
  ; (server :init-keyword :server :accessor sever-of)))
  ((server :init-keyword :server :accessor server-of)))

;(define-method initialize ((self <ubigraph-client>) initargs)
;  (next-method)
;  (set! (sever-of self)
;    (make-xml-rpc-client (uri-compose ))))

(define (make-ubigraph-client scheme host port path)
  ;(let-optionals* args ())
  (make <ubigraph-client> 
    :server (make-xml-rpc-client 
              (uri-compose :scheme scheme
                           :host host
                           :port port
                           :path path))))

(define  (init-ubigraph . args)
  (let-optionals* args ((scheme "http")
                        (host "localhost")
                        (port 20738)
                        (path "RPC2"))
    (make-ubigraph-client scheme host port path)))

(define-method clear ((self <ubigraph-client>))
  (call self "ubigraph.clear"))

(define-method call ((self <ubigraph-client>) msg . args)
  (let ((server (server-of self))
        (size (length args)))
    (cond [(= size 0) (call server msg)]
          [(= size 1) (call server msg (first args))]
          [(= size 2) (call server msg (first args) (second args))]
          [(= size 3) (call server msg (first args) (second args) (third args))]
        )))

(provide "ubigraph")
