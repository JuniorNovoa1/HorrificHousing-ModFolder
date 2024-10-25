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

	runTimer("deathTimer", eventTime / 2)

	eventEnabled = true;
end
function onTimerCompleted(tag, loops, loopsLeft)
	if tag == "deathTimer" then
		if player == 1 then setProperty("health", 0) else runHaxeCode([[setVar("healthDad", 0);]]) end
	end
end
function deactivateEvent()
	eventEnabled = false;
	removeLuaScript("scripts/events/"..eventName) --removes event
end