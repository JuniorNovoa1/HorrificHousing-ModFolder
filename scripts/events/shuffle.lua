local eventEnabled = false;

local eventName = ""
local eventNumb = 0;
local eventTime = 0;
local player = 0;

--template variables
local randomChar = {"boyfriend", "dad", "gf"}
local randomStrum = {"playerStrums", "opponentStrums"}

--event script variables
local charPos = {}

local elapsedtime = 0.0;
function onUpdate(elapsed)
	if not eventEnabled then return; end
    elapsedtime = elapsedtime +elapsed;
end

function onTimerCompleted(tag, loops, loopsLeft)
	if not eventEnabled then return; end
	if tag == "0.5" then
		local positionsArray = {}
		table.insert(positionsArray, getRandomInt(1, #charPos))
		table.insert(positionsArray, getRandomInt(1, #charPos, ""..positionsArray[1]))
		table.insert(positionsArray, getRandomInt(1, #charPos, ""..positionsArray[1]..","..positionsArray[2]))
		for i = 1, #randomChar do
			setCharacterX(randomChar[i], charPos[positionsArray[i]][1])
			--setCharacterY(randomChar[i], charPos[positionsArray[i]][2])
			--setProperty(randomChar[i]..".flipX", not getProperty(randomChar[i]..".flipX"))
		end
	end
end

function activateEvent(evName, evNum, evT, evP)
	eventName = evName; eventNum = evNum; eventTime = evT; player = evP;

	table.insert(charPos, {getProperty("boyfriend.x"), getProperty("boyfriend.y")})
	table.insert(charPos, {getProperty("dad.x"), getProperty("dad.y")})
	table.insert(charPos, {getProperty("gf.x"), getProperty("gf.y")})

	--[[for i = 1, #charPos do
		--setCharacterY(randomChar[i], charPos[i][2])
		--setProperty(randomChar[i]..".flipX", not getProperty(randomChar[i]..".flipX"))
	end--]]
	
	eventEnabled = true;
end
function deactivateEvent()
	eventEnabled = false;
	removeLuaScript("scripts/events/"..eventName) --removes event
end