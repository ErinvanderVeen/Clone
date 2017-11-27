implementation module Config

import Bot
import System.File, Text.JSON, Data.Maybe
from Data.Error import isError, fromOk
from StdMisc import abort
from StdFile import instance FileSystem World
from StdFunc import o
from StdList import map

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
	# (result, w) = readFile "config.json" w
	| isError result = abort "Could not read from config file"
	# result = fromOk result
	= (result, w)

fromJSONArray :: JSONNode -> Maybe [JSONNode]
fromJSONArray (JSONArray x) = Just x
fromJSONArray _ = Nothing

fromJSONObject :: JSONNode -> [(!String, !JSONNode)]
fromJSONObject (JSONObject x) = x
fromJSONObject _ = abort "Could not retrieve JSONObject"

toBot :: JSONNode -> Bot
toBot node=:(JSONObject _) =
		{Bot |
			name     = fromJust (jsonQuery "name" node),
			exe      = fromJust (jsonQuery "exe" node),
			vars     = fromMaybe [] (jsonQuery "vars" node),
			interval = fromJust (jsonQuery "interval" node),
			children = fromMaybe [] (jsonQuery "children" node),
			root     = fromMaybe False (jsonQuery "root" node)
		}
toBot _ = abort "Could not parse bot in config file"
