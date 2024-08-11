local eventEnabled = false;

local eventName = ""
local eventNumb = 0;
local eventTime = 0;
local player = 0;

--template variables
local randomChar = {"boyfriend", "dad"}
local randomStrum = {"playerStrums", "opponentStrums"}

--event script variables
local scrollSpeedAmount = 0.25

local elapsedtime = 0.0;
function onUpdate(elapsed)
	if not eventEnabled then return; end
    elapsedtime = elapsedtime +elapsed;
end

function activateEvent(evName, evNum, evT, evP)
	eventName = evName; eventNum = evNum; eventTime = evT; player = evP;

	for i = 0, getProperty("unspawnNotes.length") do
		local multSpeed = getPropertyFromGroup("notes", i, "multSpeed")
		setPropertyFromGroup("unspawnNotes", i, "multSpeed", getRandomFloat(multSpeed - (scrollSpeedAmount), multSpeed))
	end

	eventEnabled = true;
end
function deactivateEvent()
	eventEnabled = false;

	for i = 0, getProperty("unspawnNotes.length") do
		setPropertyFromGroup("unspawnNotes", i, "multSpeed", 1)
	end

	removeLuaScript("scripts/events/"..eventName) --removes event
end