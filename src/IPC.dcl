definition module IPC

/**
 * Synnonym for the FileDescriptor
 */
:: Socket

/**
 * Calls a C function that creates a UNIX Domain Socket
 * @result The FileDescriptor of the Socket
 */
create_socket :: !*World -> (!Socket, !*World)

/**
 * Initializes some datastructures for the wait function
 * In particular, adds the socket to a set for the
 * select call in wait.
 * @param The Socket FileDesciptor
 */
setup_socket :: !Socket !*World -> *World

/**
 * Calls a C function that both waits untill the next bot
 * needs to be executed, but also listens for interupts
 * @param The amount of time that a sleep is required in seconds
 * @param The FileDescriptor on which Clone must watch for Interrupts
 * @result "" if no interrupt was received, the interrupt string there was
 */
wait :: Int Socket !*World -> (!String, !*World)

