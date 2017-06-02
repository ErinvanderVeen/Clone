implementation module BotQueue

import Bot
from StdList import ++
import StdInt

:: BotQueue :== [Bot]

newBotQueue :: BotQueue
newBotQueue = []

insertBot :: BotQueue Bot -> BotQueue
insertBot [] bot = [bot]
insertBot [x:xs] bot
| x.interval > bot.interval = [bot] ++ [x:xs]
| otherwise = [x : insertBot xs bot]
