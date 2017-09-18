definition module Config

import Bot
from Text.JSON import :: JSONNode

:: Config = { bots :: [Bot] }

/**
* Parses the config located in the root dir
*/
parseConfig :: !*World -> (Config, *World)

/**
* Given a JSONNode, returns a bot that can be added to the BotQueue
*/
toBot :: JSONNode -> Bot
