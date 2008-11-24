(use rfc.uri)
(use xsm.xml-rpc.client)

(define scheme "http")
(define host "localhost")
(define port 20738)
(define path "/RPC2")

;;========== Main
(define (main args)
  (let ((client (make-xml-rpc-client (uri-compose :scheme scheme
                                                  :host host
                                                  :port port
                                                  :path path)))
        (handler (current-exception-handler)))
    (with-exception-handler
      (lambda (e)
        (use gauche.interactive)
        (d e)
        (handler e))
      (lambda ()
        (print (call client "ubigraph.remove_vertex" 1)
               (call client "ubigraph.remove_vertex" 2))))))
