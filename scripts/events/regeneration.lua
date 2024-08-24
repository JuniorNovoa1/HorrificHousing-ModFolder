local eventEnabled = false;

local eventName = ""
local eventNumb = 0;
local eventTime = 0;
local player = 0;

--template variables
local randomChar = {"boyfriend", "dad"}
local randomStrum = {"playerStrums", "opponentStrums"}

--event script variables
local healthGain = 0.002;

local elapsedtime = 0.0;
function onUpdate(elapsed)
	if not eventEnabled then return; end
    elapsedtime = elapsedtime +elapsed;

	if player == 1 then setProperty("health", getProperty("health") + healthGain) else runHaxeCode([[setVar("healthDad", getVar("healthDad") + ]]..healthGain..[[);]]) end
end

function activateEvent(evName, evNum, evT, evP)
	eventName = evName; eventNum = evNum; eventTime = evT; player = evP;

	if player == 2 then
		setProperty("iconP2.color", getColorFromHex("32cd32"))
	else
		setProperty("iconP1.color", getColorFromHex("32cd32"))
	end
	setProperty(randomChar[player]..".color", getColorFromHex("32cd32"))

	eventEnabled = true;
end
function deactivateEvent()
	eventEnabled = false;

	if player == 2 then
		setProperty("iconP2.color", getColorFromHex("FFFFFF"))
	else
		setProperty("iconP1.color", getColorFromHex("FFFFFF"))
	end
	setProperty(randomChar[player]..".color", getColorFromHex("FFFFFF"))

	removeLuaScript("scripts/events/"..eventName) --removes event
end