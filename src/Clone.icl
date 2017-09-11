module Clone

import Config, BotQueue, Bot, IPC
import Data.Maybe, Data.List
from Text.JSON import instance fromString JSONNode
from System._Posix import select_, chdir
from System._Pointer import :: Pointer
from System.Time import ::Timestamp, time, diffTime
from StdListExtensions import foldrSt
from StdFunc import o
import StdString, StdInt

import StdDebug

Start :: !*World -> ()
Start world
# (socket, world) = create_socket world
# queue = newBotQueue
# (config, world) = parseConfig world
# queue = foldr addIfRootBot queue config.bots
= loop config queue socket world

loop :: Config BotQueue Socket !*World -> ()
loop config queue socket world
# (queue, world) = runRequiredBots config queue world
# (queue, world) = sleepUntilRun config queue socket world
= loop config queue socket world

sleepUntilRun :: Config BotQueue Socket !*World -> (!BotQueue, !*World)
sleepUntilRun config queue socket world 
# sleepTime = getWaitTime queue
| sleepTime == 0 = (queue, world)
# (startTime, world) = time world
# (interruptString, world) = wait sleepTime socket world
| interruptString == "" = trace_n "Sleep completed" (mapQueue (\b -> {b & interval = b.interval - sleepTime}) queue, world)
# (endTime, world) = trace_n "Interrupted" time world
# timeSlept = diffTime endTime startTime
# queue = mapQueue (\b -> {b & interval = min 0 (b.interval - timeSlept)}) queue
# queue = handleInterrupt config interruptString queue
= sleepUntilRun config queue socket world

handleInterrupt :: Config String BotQueue -> BotQueue
handleInterrupt config interruptString queue
# node = fromString interruptString
# bot = toBot node
= insertBot bot queue

runRequiredBots :: Config BotQueue !*World -> (!BotQueue, !*World)
runRequiredBots config queue world
# (requiredBots, queue) = allBotsOnZero queue
# (queue, world) = foldrSt (uncurry o runBotAndChildren config) requiredBots (queue, world)
| runRequired queue = runRequiredBots config queue world
| otherwise = (queue, world)

runBotAndChildren :: Config Bot !BotQueue !*World -> (!BotQueue, !*World)
runBotAndChildren config bot queue world
# (result, world) = runBot bot world
# queue = addIfRootBot (findBot bot.name config) queue
| isNothing result = (queue, world)
# queue = foldr (\c -> insertBot {findBot c config & input=result}) queue bot.children
= (queue, world)
where
	findBot :: String Config -> Bot
	findBot name config = fromJust (find (\b -> b.name == name) config.bots)

addIfRootBot :: Bot BotQueue -> BotQueue
addIfRootBot bot queue
| bot.root = insertBot bot queue
| otherwise = queue
