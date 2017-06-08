implementation module Bot

import StdString
from StdMisc import abort
from StdTuple import snd

import System.Process, Data.Error, System._Posix
from Data.List import isnull

runBot :: Bot !*World -> (Maybe String, *World)
runBot bot world
# (err, world) = runProcessIO ("bots/" +++ bot.name) [] (Just "bots/") world
| isError err = abort ("Could not start bot: " +++ bot.name +++ "\n" +++ snd (fromError err))
# (handle, io) = fromOk err
# (err, world) = writePipe (fromMaybe "" bot.input) io.stdIn world
| isError err = abort ("Could not write to stdIn of " +++ bot.name +++ "\n" +++ snd (fromError err))
# (err, world) = closePipe io.stdIn world
| isError err = abort "Could not close stdIn pipe"
# (err, world) = waitForProcess handle world
# (result, world) = readStdOut io.stdOut world
# (err, world) = closePipe io.stdOut world
| isError err = abort "Could not close stdOut pipe"
| isnull bot.children = (Nothing, world)
= (result, world)
where
	readStdOut :: ReadPipe !*World -> (Maybe String, *World)
	readStdOut pipe world
	# (err, world) = readPipeNonBlocking pipe world
	| isError err = abort "Could not read stdOut"
	# result = fromOk err
	| result == "" = (Nothing, world)
	= (Just result, world)
