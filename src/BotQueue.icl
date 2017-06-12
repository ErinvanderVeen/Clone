implementation module BotQueue

import Bot
from StdList import ++, map
from Data.List import splitWith
import StdInt
from StdMisc import abort

:: BotQueue :== [Bot]

newBotQueue :: BotQueue
newBotQueue = []

insertBot :: Bot BotQueue -> BotQueue
insertBot bot [] = [bot]
insertBot bot [x:xs]
| bot.interval >= x.interval = [x : insertBot bot xs]
| otherwise = [bot] ++ [x:xs]

allBotsOnZero :: BotQueue -> ([Bot], BotQueue)
allBotsOnZero queue
= splitWith (\b -> b.interval == 0) queue

mapQueue :: ((Bot -> Bot) BotQueue -> BotQueue)
mapQueue = map

runRequired :: BotQueue -> Bool
runRequired [] = False
runRequired [x:_] = x.interval == 0

getWaitTime :: BotQueue -> Int
getWaitTime [] = abort "Could not determine wait-time of empty queue"
getWaitTime [x:_] = x.interval

