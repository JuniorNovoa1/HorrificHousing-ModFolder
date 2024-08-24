local eventEnabled = false;

local eventName = ""
local eventNumb = 0;
local eventTime = 0;
local player = 0;

--template variables
local randomChar = {"boyfriend", "dad"}
local randomStrum = {"playerStrums", "opponentStrums"}

--event script variables
local charPos = {}

local elapsedtime = 0.0;
function onUpdate(elapsed)
	if not eventEnabled then return; end
    elapsedtime = elapsedtime +elapsed;
end

function activateEvent(evName, evNum, evT, evP)
	eventName = evName; eventNum = evNum; eventTime = evT; player = evP;

	table.insert(charPos, {getProperty("dad.x"), getProperty("dad.y")})
	table.insert(charPos, {getProperty("boyfriend.x"), getProperty("boyfriend.y")})

	for i = 1, 2 do
		setCharacterX(randomChar[i], charPos[i][1])
		--setCharacterY(randomChar[i], charPos[i][2])
		--setProperty(randomChar[i]..".flipX", not getProperty(randomChar[i]..".flipX"))
	end
	
	eventEnabled = true;
end
function deactivateEvent()
	eventEnabled = false;
	removeLuaScript("scripts/events/"..eventName) --removes event
end