definition module BotQueue

import Data.Tuple
import Bot

/**
 * An ordered list of Entries
 */
:: BotQueue

/**
 * An Entry in the Queue. Stores the Bot,
 * in how long the bot needs to be executed
 * and which inputs must be passed to the bot
 */
:: BotQueueEntry = {
		bot :: Bot,
		waitTime :: Int,
		inputs :: Maybe [String]
	}

/**
 * Creates an empty BotQueue
 *
 * @result The empty Queue
 */
newBotQueue :: BotQueue

/**
 * Inserts a bot into the correct position in the queue
 *
 * @param The Bot that needs to be inserted
 * @param The Queue that the bot needs to be inserted into
 * @result The new Queue
 */
insertBot :: BotQueueEntry BotQueue -> BotQueue

/**
 * Constructs a default Entry for a bot,
 * this Entry can then be added to the queue
 * if this is desired
 *
 * @param The Bot record that needs to be turned into an entry
 * @result The Entry that corresponds to the Bot
 */
toBotQueueEntry :: Bot -> BotQueueEntry

/**
 * Returns if the Queue contains a Bot with the given name
 *
 * @param The BotQueue in which the Bot must be searched
 * @param The name of the Bot
 * @result True if it is in the Queue, False otherwise
 */
inQueue :: BotQueue String -> Bool

/**
 * Splits the Queue based on which bots have a waitTime of 0
 * Used when Clone needs to know which Bots need execution
 *
 * @param The Queue that needs to be split
 * @result The Bots that had a waitTime of 0, and the remaining bots
 */
allBotsOnZero :: BotQueue -> ([BotQueueEntry], BotQueue)

/**
 * Adds an input to a Bot
 * Used to pass the result of a bot to its children
 *
 * @param The Queue in which the children are waiting
 * @param The Name of the Child
 * @param The inputs that need to be given to this Bot
 * @result The new Queue
 */
addInput :: BotQueue String [String] -> BotQueue

/**
 * Executes the bot of an entry on each of the inputs
 *
 * @param The Entry
 * @result The list of output strings that the bot produced
 */
runEntry :: BotQueueEntry *World -> (Maybe [String], !*World)

/**
 * Allows mapping a function on a Queue
 *
 * @param The Function that needs to be mapped
 * @result A function that applies this function on a Queue
 */
mapQueue :: (BotQueueEntry -> BotQueueEntry) -> (BotQueue -> BotQueue)

/**
 * Tests if there is ANY bot that needs to be executed right Now
 *
 * @param The Queue
 * @result True if there is one that needs execution, False otherwise
 */
runRequired :: BotQueue -> Bool

/**
 * Returns the minimim waitTime of all Bots
 * Used by Clone to determine how long it needs to sleep
 *
 * @param The Queue
 * @result The amount that needs to be waited in seconds
 */
getWaitTime :: BotQueue -> Int
