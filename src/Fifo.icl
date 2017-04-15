implementation module Fifo

import StdFile, StdList, StdDebug, StdMisc, _SystemArray, System._Pointer, System.OSError
import Data.Maybe, System.Process, StdString, StdTuple, System.Directory

createTempDir :: !*World -> !*World
createTempDir w
# (err, w) = createDirectory "/tmp/cleanbots" w
= w

// Code used from Random.icl by mschool@science.ru.nl
// Generates a random string
getRandomName :: !*World -> (!String, !*World)
getRandomName w
# w = createTempDir w
# (ok, src, w) = sfopen "/dev/urandom" FReadData w
| not ok = abort "Could not open /dev/random in creation of named pipe"
# (bytes, _) = sfreads src 8
# name = map (\x -> toChar ((toInt x) rem 26 + 65)) [c \\ c<-:bytes]
| otherwise = (toString name, w)

// The {Char} is the null terminated path
mkfifo :: !*World -> (!{#Char}, !*World)
mkfifo w
# (fileName, w) = getRandomName w
# filepath = "/tmp/cleanbots/" +++ fileName
# (err, w) = runProcess "/bin/mkfifo" [filepath] Nothing w
| isError err = abort ("Could not create named pipe" +++ snd (fromError err))
| otherwise = (filepath, w)
