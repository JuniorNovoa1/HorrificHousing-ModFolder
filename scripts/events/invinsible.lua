local eventEnabled = false;

local eventName = ""
local eventNumb = 0;
local eventTime = 0;
local player = 0;

--template variables
local randomChar = {"boyfriend", "dad"}
local randomStrum = {"playerStrums", "opponentStrums"}

--event script variables
local previousHealth = 1;

local elapsedtime = 0.0;
function onUpdate(elapsed)
	if not eventEnabled then return; end
    elapsedtime = elapsedtime +elapsed;

	if player == 2 then runHaxeCode([[setVar("dadHealth", ]]..previousHealth..[[);]]) else setHealth(previousHealth) end
end

function activateEvent(evName, evNum, evT, evP)
	eventName = evName; eventNum = evNum; eventTime = evT; player = evP;

	if player == 1 then previousHealth = getHealth() elseif player == 2 then previousHealth = getProperty("dadHealth") end

	eventEnabled = true;
end
function deactivateEvent()
	eventEnabled = false;
	removeLuaScript("scripts/events/"..eventName) --removes event
end