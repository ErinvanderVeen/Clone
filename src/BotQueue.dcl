definition module BotQueue

import Data.Tuple
import Bot

:: BotQueue

// Creates an empty BotQueue
newBotQueue :: BotQueue

// Inserts a bot into the correct position in the queue
// @param The Queue that the bot needs to be inserted into
// @param The Bot that needs to be inserted
insertBot :: BotQueue Bot -> BotQueue

allBotsOnZero :: BotQueue -> ([Bot], BotQueue)

decrementAll :: BotQueue -> BotQueue

runRequired :: BotQueue -> Bool
