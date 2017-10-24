definition module Bot

import StdTuple, Data.Maybe, Text.JSON

/**
 * Stores all static information of a Bot
 * Information that changes should be part of the Entry instead
 * Should be a 1-to-1 mapping of the config
 */
:: Bot = {
	name :: String,
	exe :: String,
	vars :: [(String, String)],
	interval :: Int,
	children :: [String],
	root :: Bool
	}

/**
* Runs a bot
* @param The Bot record
* @param The String that must be passed as input
* @result The output of the Bot, if there was any
*/
runBot :: Bot (Maybe String) *World -> (Maybe String, *World)
