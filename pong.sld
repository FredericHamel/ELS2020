
(define-library (pong)
  (export start migrate)

  (import (gambit)
          (termite))

  (begin
    (define (start)
      (letrec ((loop (lambda ()
                       (recv
                         ((from tag 'PING)
                          (! from (list tag 'PONG)))

                         ((from tag ('UPDATE k))
                          (! from (list tag 'ACK))
                          (k #t))

                         ((from tag ('MIGRATE dest))
                          (call/cc
                            (lambda (k)
                              (!? dest (list 'UPDATE k))
                              (! from (list tag 'ACK))))))
                       (loop))))

        (spawn loop name: 'pong-server)))

    (define (migrate dest)
      (let ((server (start)))
        (!? server (list 'MIGRATE dest))))))
