definition module Bot

import StdTuple, Data.Maybe

:: Bot = {
	name :: String,
	children :: [String],
	interval :: Int,
	input :: Maybe String,
	root :: Bool
	}

/**
* Runs a bot
* @param The Bot record
*/
runBot :: Bot !*World -> (Maybe String, *World)
