local eventEnabled = false;

local eventName = ""
local eventNumb = 0;
local eventTime = 0;
local player = 0;

--template variables
local randomChar = {"boyfriend", "dad"}
local randomStrum = {"playerStrums", "opponentStrums"}

--event script variables
local snowDrainLimit = 2 / 3;
local snowDrainRate = 0.000003;
local snowDrain = 0.0;

function math.clamp(x,min,max)return math.max(min,math.min(x,max))end
function math.lerp(from, to, t)
	return from + (to - from) * math.clamp(t, 0, 1)
end

local elapsedtime = 0.0;
function onUpdate(elapsed)	--TO GET PERCENTAGE: math.floor(((snowDrain * 240) / snowDrainLimit) * 100)
	if not eventEnabled then return; end
    elapsedtime = elapsedtime +elapsed;

	--setProperty("snowFallingVG.alpha", math.lerp(getProperty("snowFallingVG.alpha"), snowDrain * 500, 0.9))
	--setProperty("health", getProperty("health") - snowDrain)
	setProperty("health", 1)
	print("Heat: "..(100 - math.floor(((snowDrain * 240) / snowDrainLimit) * 100)).."%")
	snowDrain = snowDrain + (snowDrainRate * playbackRate);
	if snowDrain >= snowDrainLimit --[[stupid fnf health system]] then snowDrain = 0.5 end
	if snowDrain <= 0 then snowDrain = 0; end
	--setProperty("snowFallingVG.alpha", (snowDrain * 250) / snowDrainLimit)
	setProperty("snowFallingVG.alpha", math.lerp(getProperty("snowFallingVG.alpha"), (snowDrain * 250) / snowDrainLimit, 0.77))
end
function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
	local drainRateMult = snowDrainRate * 20;
	if not isSustainNote then snowDrain = snowDrain - (drainRateMult * playbackRate); else snowDrain = snowDrain - ((drainRateMult / 3) * playbackRate); end
end

function activateEvent(evName, evNum, evT, evP)
	eventName = evName; eventNum = evNum; eventTime = evT; player = evP;

	if not luaSpriteExists("snowFallingVG") then
		makeLuaSprite("snowFallingVG", "VG", 0, 0)
		setProperty("snowFallingVG.color", getColorFromHex("FFFFFF"))
		setObjectCamera("snowFallingVG", 'OTHER')
		screenCenter("snowFallingVG", 'xy')
		setProperty("snowFallingVG.alpha", 0)
		addLuaSprite("snowFallingVG", false)
	
		if not lowDetail then
			makeAnimatedLuaSprite("snowFalling", "snow", 0, 0)
			addAnimationByPrefix("snowFalling", "snowfall", "snow", 48, true)
			setGraphicSize("snowFalling", 1280, 1280, true)
			playAnim("snowFalling", "snowfall", false, false, 0)
			setObjectCamera("snowFalling", 'OTHER')
			screenCenter("snowFalling", 'xy')
			setProperty("snowFalling.alpha", 0)
			addLuaSprite("snowFalling", false)
		end
	end
	snowDrain = 0;
	doTweenAlpha("snow", "snowFalling", 1, 1 / playbackRate, "sineInOut")

	eventEnabled = true;
end
function deactivateEvent()
	eventEnabled = false;

	snowDrain = 0;
	doTweenAlpha("bfCold", "boyfriendCold", 0, 1 / playbackRate, "sineInOut")
	doTweenAlpha("snow", "snowFalling", 0, 1 / playbackRate, "sineInOut")
	doTweenAlpha("snow2", "snowFallingFlipped", 0, 1 / playbackRate, "sineInOut")
	doTweenAlpha("snowVG", "snowFallingVG", 0, 1 / playbackRate, "sineInOut")

	removeLuaScript("scripts/events/"..eventName) --removes event
end