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

	if player == 2 then runHaxeCode([[setVar("dadHealth", 2);]]) else setProperty("health", 2) end
end

function activateEvent(evName, evNum, evT, evP)
	eventName = evName; eventNum = evNum; eventTime = evT; player = evP;

	eventEnabled = true;
end
function deactivateEvent()
	eventEnabled = false;
	removeLuaScript("scripts/events/"..eventName) --removes event
end