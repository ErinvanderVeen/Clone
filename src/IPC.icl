implementation module IPC

import System._Pointer

:: Socket :== Int

create_socket :: !*World -> (Socket, !*World)
create_socket w = code {
	ccall create_socket ":I:A"
}

wait :: Int Socket !*World -> (!String, !*World)
wait time socket world
# (resPointer, world) = wait` time socket world
# result = unpackString resPointer
= (result, world)
where
	wait` :: !Int !Int !*World -> (Pointer, !*World)
	wait` :: t s w = code {
		ccall wait "II:I:A"
	}
