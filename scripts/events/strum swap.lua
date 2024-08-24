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

	local playerPos = {};
	for i = 0, getProperty("playerStrums.length") do
		table.insert(playerPos, {getPropertyFromGroup("playerStrums", i, "x"), getPropertyFromGroup("playerStrums", i, "y")})
	end
	local opponentPos = {};
	for i = 0, getProperty("opponentStrums.length") do
		table.insert(opponentPos, {getPropertyFromGroup("opponentStrums", i, "x"), getPropertyFromGroup("opponentStrums", i, "y")})
	end

	local noteSwapSpeed = 2 / playbackRate;
	for i = 0, 3 do
		noteTweenX("noteSwapOpponentX"..i, i, playerPos[i + 1][1], noteSwapSpeed, "backInOut")
		noteTweenX("noteSwapPlayerX"..i, 4 + i, opponentPos[i + 1][1], noteSwapSpeed, "backInOut")

		noteTweenY("noteSwapOpponentY"..i, i, playerPos[i + 1][2], noteSwapSpeed, "backInOut")
		noteTweenY("noteSwapPlayerY"..i, 4 + i, opponentPos[i + 1][2], noteSwapSpeed, "backInOut")
	end
	
	eventEnabled = true;
end
function deactivateEvent()
	eventEnabled = false;
	removeLuaScript("scripts/events/"..eventName) --removes event
end