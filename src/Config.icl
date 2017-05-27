implementation module Config

import Bot
import System.File, Text.JSON, Data.Maybe
from Data.Error import isError, fromOk
from StdMisc import abort
from StdFile import instance FileSystem World

parseConfig :: !*World -> (Config, *World)
parseConfig w
# (configString, w) = readConfig w
# node = fromString configString
# botsArray = jsonQuery "bots" node
| isNothing botsArray = abort "Could not find \"bots\" in config file"
# botsArray = fromJSONArray (fromJust botsArray)
| isNothing botsArray = abort "Could not get bots array from config file"
# botsArray = map toBot (fromJust botsArray)
# config = { Config | bots = botsArray }
= (config, w)
where
	readConfig :: !*World -> (String, *World)
	readConfig w
	# (result, w) = readFile "config" w
	| isError result = abort "Could not read from config file"
	# result = fromOk result
	= (result, w)

	fromJSONArray :: JSONNode -> Maybe [JSONNode]
	fromJSONArray (JSONArray x) = Just x
	fromJSONArray _ = Nothing

	toBot :: JSONNode -> Bot
	toBot node = {Bot | name=fromJust (jsonQuery "name" node),
	                    children=fromJust (jsonQuery "children" node),
	                    interval=fromJust (jsonQuery "interval" node)
	             }
	toBot _ = abort "Could not parse bot in config file"
