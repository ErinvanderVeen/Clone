definition module IPC

import System._Pointer

create_socket :: !*World -> (Socket, !*World)

wait :: !*World Socket Int -> (!String, !*World)

