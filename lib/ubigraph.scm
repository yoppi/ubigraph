;;;
;;; ubigraph - interface of Ubigraph library
;;; Copyright (c) 2008 yoppi <y.hirokazu@gmail.com>
;;;
;;; Permission is hereby granted, free of charge, to any person obtaining a copy
;;; of this software and associated documentation files (the "Software"), to deal
;;; in the Software without restriction, including without limitation the rights
;;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;;; copies of the Software, and to permit persons to whom the Software is
;;; furnished to do so, subject to the following conditions:
;;;
;;; The above copyright notice and this permission notice shall be included in
;;; all copies or substantial portions of the Software.
;;;
;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
;;; THE SOFTWARE.
;;;

(define-module ubigraph
  (use srfi-1)
  (use rfc.uri)
  (use xsm.xml-rpc.client) ;to use XML-RPC
  (export *ubigraph-version* make-vertex make-edge make-ubigraph-client remove-vertex remove-edge set-color-vertex set-shape-vertex set-shapedetail-vertex set-label-vertex set-labelpos-vertex set-size-vertex set-fontcolor-vertex set-fontfamily-vertex set-fontsize-vertex set-visible-vertex set-style-vertex set-attribute-edge set-color-edge set-label-edge set-fontcolor-edge set-fontfamily-edge set-fontsize-edge set-strength-edge  set-orientationweight-edge set-width-edge set-arrow-edge set-arrowreverse-edge set-arrowlength-edge set-arrowradius-edge set-arrowposition-edge set-showstrain-edge set-visible-edge set-style-edge init-ubigraph clear call))
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
      (call server "ubigraph.new_vertex_w_id" id))))

(define (remove-vertex id server)
  (call server "ubigraph.remove_vertex" id))

(define (set-attribute-vertex id att value server)
  (call server "ubigraph.set_vertex_attribute" id att value))

(define (set-style-vertex att value server)
  (call server "ubigraph.set_vertex_style_attribute" 0 att value))

(define (set-color-vertex id color server)
  (set-attribute-vertex id "color" color server))

(define (set-shape-vertex id shape server)
  (set-attribute-vertex id "shape" shape server))

(define (set-shapedetail-vertex id detail server)
  (set-attribute-vertex id "shapedetail" detail server))

(define (set-label-vertex id label server)
  (set-attribute-vertex id "label" label server))

(define (set-labelpos-vertex id pos server)
  (set-attribute-vertex id "labelpos" pos server))

(define (set-size-vertex id size server)
  (set-attribute-vertex id "size" size server))

(define (set-fontcolor-vertex id fontc server)
  (set-attribute-vertex id "fontcolor" fontc server))

(define (set-fontfamily-vertex id family server)
  (set-attribute-vertex id "fontfamily" family server))

(define (set-fontsize-vertex id size server)
  (set-attribute-vertex id "fontsize" size server))

(define (set-visible-vertex v server)
  (set-style-vertex "visible" v server))


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

(define (make-edge from to server . args)
  (let-optionals* args ((id #f))
    (if (eq? id #f)
      (call server "ubigraph.new_edge" from to)
      (call server "ubigraph.new_edge_w_id" id from to))))

(define (remove-edge id server)
  (call server "ubigraph.remove_edge" id))

(define (set-attribute-edge id att value server)
  (call server "ubigraph.set_edge_attribute" id att value))

(define (set-style-edge att value server)
  (call server "ubigraph.set_edge_style_attribute" 0 att value))

(define (set-color-edge id c server)
  (set-attribute-edge id "color" c server))

(define (set-label-edge id pos server)
  (set-attribute-edge id "labelpos" pos server))

(define (set-fontcolor-edge id fontc server)
  (set-attribute-edge id "fontcolor" fontc server))

(define (set-fontfamily-edge id family server)
  (set-attribute-edge id "fontfamily" family server))

(define (set-fontsize-edge id size server)
  (set-attribute-edge id "fontsize" size server))

(define (set-strength-edge id s server)
  (set-attribute-edge id "strength" s server))

(define (set-orientationweight-edge id o server)
  (set-attribute-edge id "orientationweight" o server))

(define (set-width-edge id width server)
  (set-attribute-edge id "width" width server))

(define (set-arrow-edge id arrow server)
  (set-attribute-edge id "arrow" arrow server))

(define (set-arrowreverse-edge id a server)
  (set-attribute-edge id "arrow_reverse" a server))

(define (set-arrowlength-edge id a server)
  (set-attribute-edge id "arrow_length" a server))

(define (set-arrowradius-edge id a server)
  (set-attribute-edge id "arrow_radius" a server))

(define (set-arrowposition-edge id a server)
  (set-attribute-edge id "arrow_position" a server))

(define (set-showstrain-edge id s server)
  (set-attribute-edge id "showstrain" s server))

(define (set-visible-edge v server)
  (set-style-edge "visible" v server))


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
