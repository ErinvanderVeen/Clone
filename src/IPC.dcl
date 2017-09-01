definition module IPC

:: Socket

create_socket :: !*World -> (Socket, !*World)

wait :: Int Socket !*World -> (!String, !*World)

