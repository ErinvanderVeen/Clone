module Clone

import Config, BotQueue, Bot
import Data.Maybe, Data.List
from System._Posix import select_, chdir
from System._Pointer import :: Pointer
from StdListExtensions import foldrSt
from StdFunc import o
import StdString, StdInt

Start world
# queue = newBotQueue
# (config, world) = parseConfig world
# queue = foldr addIfRootBot queue config.bots
= loop config queue world

loop :: Config BotQueue !*World -> ()
loop config queue world
# queue = decrementAll queue
# (queue, world) = runRequiredBots config queue world
# (_, world) = sleep (getWaitTime queue) world
= loop config queue world

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

sleep :: !Int !*World -> *(!Int, !*World)
sleep i w = code {
	ccall sleep "I:I:A"
}
