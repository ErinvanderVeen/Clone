implementation module IPC

import System._Pointer

:: Socket :== Int

create_socket :: !*World -> (!Socket, !*World)
create_socket w = code {
	ccall create_socket ":I:A"
}

setup_socket :: !Socket !*World -> *World
setup_socket s w = code {
	ccall setup_socket "I:V:A"
}

wait :: Int Socket !*World -> (!String, !*World)
wait time socket world
# (resPointer, world) = wait` time socket world
# result = derefString resPointer
= (result, world)
where
	wait` :: !Int !Int !*World -> (!Pointer, !*World)
	wait` t s w = code {
		ccall wait "II:I:A"
	}
