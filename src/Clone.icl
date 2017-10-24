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

Start :: !*World -> ()
Start world
# (socket, world) = create_socket world
# queue = newBotQueue
# (config, world) = parseConfig world
# queue = foldr addIfRootBot queue config.bots
= loop config queue socket world

// Main program loop, continuously runs bot and then waits
loop :: Config BotQueue Socket !*World -> ()
loop config queue socket world
# (queue, world) = runRequiredBots config queue world
# (queue, world) = sleepUntilRun config queue socket world
= loop config queue socket world

// Sleeps untill the program needs to be woken up to run bots
// If an interrups occurs, bots are added to the Queue
sleepUntilRun :: Config BotQueue Socket !*World -> (!BotQueue, !*World)
sleepUntilRun config queue socket world
# sleepTime = getWaitTime queue
| sleepTime == 0 = (queue, world)
# (startTime, world) = time world
# (interruptString, world) = wait sleepTime socket world
// Nothing was written to the socket, assume full sleep
| interruptString == "" = (mapQueue (\e -> {e & waitTime = e.waitTime - sleepTime}) queue, world)
// Else: we received interrupt, reduce waitTime, and handle the interrupt
# (endTime, world) = time world
# timeSlept = diffTime endTime startTime
# queue = mapQueue (\e -> {e & waitTime = min 0 (e.waitTime - timeSlept)}) queue
# queue = handleInterrupt config interruptString queue
= sleepUntilRun config queue socket world

// Placeholder
// TODO: Replace
handleInterrupt :: Config String BotQueue -> BotQueue
handleInterrupt config interruptString queue
# node = fromString interruptString
# bot = toBotQueueEntry (toBot node)
= insertBot bot queue

// Gets all entries that need to be run, and runs them
runRequiredBots :: Config BotQueue !*World -> (!BotQueue, !*World)
runRequiredBots config queue world
// Get all entries that need to be run
# (requiredBots, queue) = allBotsOnZero queue
# (queue, world) = foldrSt (uncurry o runBotAndChildren config) requiredBots (queue, world)
| runRequired queue = runRequiredBots config queue world
| otherwise = (queue, world)

// Runs a single bot, and adds the children to the queue
runBotAndChildren :: Config BotQueueEntry !BotQueue !*World -> (!BotQueue, !*World)
runBotAndChildren config entry queue world
# (results, world) = runEntry entry world
# queue = addIfRootBot (findBot entry.bot.name config) queue
| isNothing results = (queue, world)
| isNothing entry.bot.children = (queue, world)
# queue = updateOrAddChildren config (fromJust entry.bot.children) queue (fromJust results)
= (queue, world)

findBot :: String Config -> Bot
findBot name config = fromJust (find (\b -> b.name == name) config.bots)

updateOrAddChildren :: Config [String] BotQueue [String] -> BotQueue
updateOrAddChildren _ [] queue _ = queue
updateOrAddChildren config [c : cs] queue results
| inQueue queue c = updateOrAddChildren config cs (addInput queue c results) results
# queue = insertBot (toBotQueueEntry (findBot c config)) queue
= updateOrAddChildren config cs (addInput queue c results) results


addIfRootBot :: Bot BotQueue -> BotQueue
addIfRootBot bot queue
| bot.root = insertBot (toBotQueueEntry bot) queue
| otherwise = queue
