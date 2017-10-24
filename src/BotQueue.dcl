definition module BotQueue

import Data.Tuple
import Bot

:: BotQueue

:: BotQueueEntry = {
		bot :: Bot,              // The Bot Data
		waitTime :: Int,         // Amount of time that still needs to elapse before the bot should be run
		inputs :: Maybe [String] // Maybe the input that needs to be passed to the bot
	}

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
insertBot :: BotQueueEntry BotQueue -> BotQueue

toBotQueueEntry :: Bot -> BotQueueEntry

inQueue :: BotQueue String -> Bool

allBotsOnZero :: BotQueue -> ([BotQueueEntry], BotQueue)

addInput :: BotQueue String [String] -> BotQueue

runEntry :: BotQueueEntry *World -> (Maybe [String], !*World)

mapQueue :: (BotQueueEntry -> BotQueueEntry) -> (BotQueue -> BotQueue)

runRequired :: BotQueue -> Bool

getWaitTime :: BotQueue -> Int
