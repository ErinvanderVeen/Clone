definition module BotQueue

import Data.Tuple
import Bot

:: BotQueue

/**
 * Creates an empty BotQueue
 */
newBotQueue :: BotQueue

/**
 * Inserts a bot into the correct position in the queue
 * @param The Bot that needs to be inserted
 * @param The Queue that the bot needs to be inserted into
 * @result The new Queue
 */
insertBot :: Bot BotQueue -> BotQueue

allBotsOnZero :: BotQueue -> ([Bot], BotQueue)

mapQueue :: ((Bot -> Bot) BotQueue -> BotQueue)

runRequired :: BotQueue -> Bool

getWaitTime :: BotQueue -> Int
