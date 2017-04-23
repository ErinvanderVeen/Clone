definition module Bot

import StdTuple, Data.Maybe

:: Bot = {
	name :: String,
	children :: [String]
	}

/**
* Runs a bot
* @param The Bot record
* @param The input that should be fed to the Bot
* @param World
*/
runBot :: Bot String !*World -> (Maybe String, *World)
