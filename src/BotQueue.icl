implementation module BotQueue

import Bot
from Data.Func import mapSt
from StdList import ++, map, filter, isEmpty
from Data.List import splitWith
import Data.Maybe
import StdInt
from StdMisc import abort
from StdBool import ||

:: BotQueue :== [BotQueueEntry]

newBotQueue :: BotQueue
newBotQueue = []

insertBot :: BotQueueEntry BotQueue -> BotQueue
insertBot entry [] = [entry]
insertBot entry [x:xs]
| entry.waitTime >= x.waitTime = [x : insertBot entry xs]
| otherwise = [entry] ++ [x:xs]

toBotQueueEntry :: Bot -> BotQueueEntry
toBotQueueEntry b = {bot = b, waitTime = b.interval, inputs = Nothing}

inQueue :: BotQueue String -> Bool
inQueue [] _ = False
inQueue [e : es] name = e.bot.name == name || inQueue es name

allBotsOnZero :: BotQueue -> ([BotQueueEntry], BotQueue)
allBotsOnZero queue
= splitWith (\b -> b.waitTime == 0) queue

addInput :: BotQueue String [String] -> BotQueue
addInput [] _ _ = abort "Could not add input to non-existing bot"
addInput [e : es] name inputs
| e.bot.name == name = [addInput` e inputs : es]
| otherwise = [e : addInput es name inputs]
where
	addInput` :: BotQueueEntry [String] -> BotQueueEntry
	addInput` entry inputs
	| isNothing entry.inputs = {entry & inputs = Just inputs}
	| otherwise = {entry & inputs = Just ((fromJust entry.inputs) ++ inputs)}

runEntry :: BotQueueEntry *World -> (Maybe [String], !*World)
runEntry entry world
# (results, world) = mapSt (\input -> runBot entry.bot (Just input)) (fromJust entry.inputs) world // [(Maybe String)]
# results = filter isJust results
| isEmpty results = (Nothing, world)
# results = map fromJust results
| otherwise = (Just results, world)

mapQueue :: (BotQueueEntry -> BotQueueEntry) -> (BotQueue -> BotQueue)
mapQueue f = map f

runRequired :: BotQueue -> Bool
runRequired [] = False
runRequired [x:_] = x.waitTime == 0

getWaitTime :: BotQueue -> Int
getWaitTime [] = abort "Could not determine wait-time of empty queue"
getWaitTime [x:_] = x.waitTime

