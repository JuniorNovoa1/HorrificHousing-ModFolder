local eventEnabled = false;

local eventName = ""
local eventNumb = 0;
local eventTime = 0;
local player = 0;

--template variables
local randomChar = {"boyfriend", "dad"}
local randomStrum = {"playerStrums", "opponentStrums"}

--event script variables


local elapsedtime = 0.0;
function onUpdate(elapsed)
	if not eventEnabled then return; end
    elapsedtime = elapsedtime +elapsed;
end

function activateEvent(evName, evNum, evT, evP)
	eventName = evName; eventNum = evNum; eventTime = evT; player = evP;

	scaleObject(randomChar[player], getProperty(randomChar[player]..".scale.x") * 1.2, getProperty(randomChar[player]..".scale.y") * 0.8, true)

	eventEnabled = true;
end
function deactivateEvent()
	eventEnabled = false;

	removeLuaScript("scripts/events/"..eventName) --removes event
end