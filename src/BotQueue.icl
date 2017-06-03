implementation module BotQueue

import Bot
from StdList import ++, map
from Data.List import splitWith
import StdInt

:: BotQueue :== [Bot]

newBotQueue :: BotQueue
newBotQueue = []

insertBot :: BotQueue Bot -> BotQueue
insertBot [] bot = [bot]
insertBot [x:xs] bot
| bot.interval >= x.interval = [x : insertBot xs bot]
| otherwise = [bot] ++ [x:xs]

allBotsOnZero :: BotQueue -> ([Bot], BotQueue)
allBotsOnZero queue
= splitWith (\b -> b.interval == 0) queue

decrementAll :: BotQueue -> BotQueue
decrementAll queue = map (\x -> {x & interval = x.interval - 1}) queue

runRequired :: BotQueue -> Bool
runRequired [] = False
runRequired [x:_] = x.interval == 0
