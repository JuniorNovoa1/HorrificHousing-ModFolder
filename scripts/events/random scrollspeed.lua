local eventEnabled = false;

local eventName = ""
local eventNumb = 0;
local eventTime = 0;
local player = 0;

--template variables
local randomChar = {"boyfriend", "dad"}
local randomStrum = {"playerStrums", "opponentStrums"}

--event script variables
local prevScrollSpeed = 0;

local elapsedtime = 0.0;
function onUpdate(elapsed)
	if not eventEnabled then return; end
    elapsedtime = elapsedtime +elapsed;
end

function activateEvent(evName, evNum, evT, evP)
	eventName = evName; eventNum = evNum; eventTime = evT; player = evP;

	prevScrollSpeed = getProperty("songSpeed")
	runHaxeCode([[
		var songSpeedNew = ]]..getRandomFloat(1, 4)..[[;
		FlxTween.tween(game, {songSpeed: songSpeedNew}, 2, {ease: FlxEase.linear});
	]])

	eventEnabled = true;
end
function deactivateEvent()
	eventEnabled = false;

	runHaxeCode([[
		var songSpeedNew = ]]..prevScrollSpeed..[[;
		FlxTween.tween(game, {songSpeed: songSpeedNew}, 2, {ease: FlxEase.linear});
	]])

	removeLuaScript("scripts/events/"..eventName) --removes event
end