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

	for i = 0, getProperty(randomStrum[player]..".length") do
    	setPropertyFromGroup(randomStrum[player], i, "angle", getPropertyFromGroup(randomStrum[player], i, "angle") + (elapsed * 775) * playbackRate)
    end
end

function activateEvent(evName, evNum, evT, evP)
	eventName = evName; eventNum = evNum; eventTime = evT; player = evP;
	eventEnabled = true;
end
function deactivateEvent()
	eventEnabled = false;

	if player == 2 then
		for i = 1, getProperty("opponentStrums.length") do
			noteTweenAngle("noteStrumHorrificAngle"..i, i -1, 0, 1 / playbackRate, "sineInOut")
		end
	else
		for i = 1, getProperty("playerStrums.length") do
			noteTweenAngle("noteStrumHorrificAngle"..i, 3 + i, 0, 1 / playbackRate, "sineInOut")
		end
	end

	removeLuaScript("scripts/events/"..eventName) --removes event
end