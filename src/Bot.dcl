definition module Bot

import StdTuple, Data.Maybe, Text.JSON

// Should be 1-on-1 with the Configuration file
:: Bot = {
	name :: String,
	exe :: String,
	vars :: [(String, String)],
	interval :: Int,
	children :: Maybe [String],
	root :: Bool
	}

/**
* Runs a bot
* @param The Bot record
*/
runBot :: Bot (Maybe String) *World -> (Maybe String, *World)
