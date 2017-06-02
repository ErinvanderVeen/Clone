module Clone

import Config, BotQueue, Bot
import Data.Maybe, Data.List
import StdString

runBotAndChildren :: !BotQueue Config Bot !*World -> (!BotQueue, !*World)
runBotAndChildren queue config bot world
# (result, world) = runBot bot world
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
