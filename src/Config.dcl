definition module Config

import Bot
from Text.JSON import :: JSONNode

/**
 * Holds a representation of the configfile
 */
:: Config = {
		bots :: [Bot]
	}

/**
* Parses the config located in the root dir
* @result The Config
*/
parseConfig :: !*World -> (Config, *World)

/**
* Parses a JSONNode to a bot
* @param The Node
* @result The Parsed Bot
*/
toBot :: JSONNode -> Bot
