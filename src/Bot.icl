implementation module Bot

import StdString
from StdMisc import abort
from StdTuple import snd
from StdList import isEmpty

import System.Process, Data.Error, System._Posix

runBot :: Bot (Maybe String) *World -> (Maybe String, *World)
runBot bot input world
# (err, world) = runProcessIO ("./" +++ bot.name) [] (Just "bots") world
| isError err = abort ("Could not start bot: " +++ bot.name +++ "\n" +++ snd (fromError err))
# (handle, io) = fromOk err
# (err, world) = writePipe (fromMaybe "" input) io.stdIn world
| isError err = abort ("Could not write to stdIn of " +++ bot.name +++ "\n" +++ snd (fromError err))
# (err, world) = closePipe io.stdIn world
| isError err = abort "Could not close stdIn pipe"
# (err, world) = waitForProcess handle world
# (result, world) = readStdOut io.stdOut world
# (err, world) = closePipe io.stdOut world
| isError err = abort "Could not close stdOut pipe"
# (err, world) = closePipe io.stdErr world
| isError err = abort "Could not close stdErr pipe"
| isNothing bot.children = (Nothing, world)
= (result, world)
where
	readStdOut :: ReadPipe !*World -> (Maybe String, *World)
	readStdOut pipe world
	# (err, world) = readPipeNonBlocking pipe world
	| isError err = abort "Could not read stdOut"
	# result = fromOk err
	| result == "" = (Nothing, world)
	= (Just result, world)
