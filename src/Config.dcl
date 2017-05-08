definition module Config

import Bot

:: Config = { bots :: [Bot] }

/**
* Parses the config located in the root dir
*/
parseConfig :: !*World -> (Config, *World)
