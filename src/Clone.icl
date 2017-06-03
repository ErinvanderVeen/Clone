module Clone

import Config, BotQueue, Bot
import Data.Maybe, Data.List
from System._Posix import select_, chdir
from System._Pointer import :: Pointer
from StdListExtensions import foldrSt
import StdString, StdInt

Start world
// Platform hasn't yet implemented workingdir for runProcessIO
// So we must physically change dir
# (_, world) = chdir "bots/" world
# queue = newBotQueue
# (config, world) = parseConfig world
# queue = foldr addIfRootBot queue config.bots
= loop config queue world

loop :: Config BotQueue !*World -> ()
loop config queue world
# queue = decrementAll queue
# (queue, world) = runRequiredBots config queue world
# (_, world) = waitMinute world
= loop config queue world

runRequiredBots :: Config BotQueue !*World -> (!BotQueue, !*World)
runRequiredBots config queue world
# (requiredBots, queue) = allBotsOnZero queue
# (queue, world) = foldrSt (\b (q, w) -> runBotAndChildren q config b w) requiredBots (queue, world)
| runRequired queue = runRequiredBots config queue world
| otherwise = (queue, world)

runBotAndChildren :: !BotQueue Config Bot !*World -> (!BotQueue, !*World)
runBotAndChildren queue config bot world
# (result, world) = runBot bot world
# queue = addIfRootBot (findBot config bot.name) queue
| isNothing result = (queue, world)
# children = [findBot config x \\ x <- bot.children]
# children = map (\c -> {c & input = result}) children
# queue = foldr addToQueue queue children
= (queue, world)
where
	findBot :: Config String -> Bot
	findBot config name = fromJust (find (\b -> b.name == name) config.bots)

addToQueue :: Bot BotQueue -> BotQueue
addToQueue bot queue = insertBot queue bot

addIfRootBot :: Bot BotQueue -> BotQueue
addIfRootBot bot queue
| bot.root = addToQueue bot queue
| otherwise = queue

waitMinute :: !*World -> (!Int, !*World)
waitMinute w = code {
	ccall waitMinute ":I:A"
}
