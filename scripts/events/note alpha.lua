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

	if player == 2 then
		for i = 1, getProperty("opponentStrums.length") do
			noteTweenAlpha("noteStrumHorrificAlpha"..i, i - 1, 0.35 / playbackRate, 1, "sineInOut")
		end
	else
		for i = 1, getProperty("playerStrums.length") do
			noteTweenAlpha("noteStrumHorrificAlpha"..i, 3 + i, 0.35 / playbackRate, 1, "sineInOut")
		end
	end

	eventEnabled = true;
end
function deactivateEvent()
	eventEnabled = false;

	if player == 2 then
		for i = 1, getProperty("opponentStrums.length") do
			noteTweenAlpha("noteStrumHorrificAlpha"..i, i - 1, 1, 1 / playbackRate, "sineInOut")
		end
	else
		for i = 1, getProperty("playerStrums.length") do
			noteTweenAlpha("noteStrumHorrificAlpha"..i, 3 + i, 1, 1 / playbackRate, "sineInOut")
		end
	end

	removeLuaScript("scripts/events/"..eventName) --removes event
end