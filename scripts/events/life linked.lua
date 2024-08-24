local eventEnabled = false;

local eventName = ""
local eventNumb = 0;
local eventTime = 0;
local player = 0;

--template variables
local randomChar = {"boyfriend", "dad"}
local randomStrum = {"playerStrums", "opponentStrums"}

--event script variables
local lifelinked = false;

local elapsedtime = 0.0;
function onUpdate(elapsed)
	if not eventEnabled then return; end
    elapsedtime = elapsedtime +elapsed;

	if (getHealth() <= 0 or getProperty("dadHealth") <= 0) and lifelinked then
		setHealth(0)
	end
end

function activateEvent(evName, evNum, evT, evP)
	eventName = evName; eventNum = evNum; eventTime = evT; player = evP;

	lifelinked = true;
	
	eventEnabled = true;
end
function deactivateEvent() --this event should stay enabled!
	--[[eventEnabled = false;
	removeLuaScript("scripts/events/"..eventName) --removes event --]]
end