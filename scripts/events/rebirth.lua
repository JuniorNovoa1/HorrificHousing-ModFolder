local eventEnabled = false;

local eventName = ""
local eventNumb = 0;
local eventTime = 0;
local player = 0;

--template variables
local randomChar = {"boyfriend", "dad"}
local randomStrum = {"playerStrums", "opponentStrums"}

--event script variables
local rebirth = {false, false}

local elapsedtime = 0.0;
function onUpdate(elapsed)
	if not eventEnabled then return; end
    elapsedtime = elapsedtime +elapsed;

	if rebirth[1] then
		if getProperty("health") >= 2 then
			setProperty("health", 0.1)
			playAnim("boyfriend", "hurt")
			playSound("bird-caw", 1)
			if flashingLights then
				cameraFlash("other", "FFA500", 1.2 / playbackRate)
			end
			rebirth[1] = false;
		end
	end
	if rebirth[2] then
		if getProperty("health") <= 0 then
			setProperty("health", 2)
			playAnim("boyfriend", "hey")
			playSound("bird-caw", 1)
			if flashingLights then
				cameraFlash("other", "FFA500", 1.2 / playbackRate)
			end
			rebirth[2] = false;
		end
	end
end

function activateEvent(evName, evNum, evT, evP)
	eventName = evName; eventNum = evNum; eventTime = evT; player = evP;

	rebirth[player] = true;

	eventEnabled = true;
end
function deactivateEvent() --this event should stay enabled!
	--[[eventEnabled = false;
	removeLuaScript("scripts/events/"..eventName) --removes event --]]
end