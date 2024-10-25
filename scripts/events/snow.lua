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
local snowDrainRate = 0.0002;
local snowDrainBF = 0;
local snowDrainDAD = 0;

function math.clamp(x,min,max)return math.max(min,math.min(x,max))end
function math.lerp(from, to, t)
	return from + (to - from) * math.clamp(t, 0, 1)
end

local elapsedtime = 0.0;
function onUpdate(elapsed)	--TO GET PERCENTAGE: math.floor(((snowDrain * 240) / snowDrainLimit) * 100)
	if not eventEnabled then return; end
    elapsedtime = elapsedtime +elapsed; 
end
function onTimerCompleted(tag, loops, loopsLeft)
	if tag == "0.1" then
		snowDrainBF = snowDrainBF + (snowDrainRate * playbackRate);
		snowDrainDAD = snowDrainDAD + (snowDrainRate * playbackRate);
		if snowDrainBF < 0 then snowDrainBF = 0; end
		if snowDrainDAD < 0 then snowDrainDAD = 0; end
		if snowDrainBF >= snowDrainLimit then snowDrainBF = snowDrainLimit end
		if snowDrainDAD >= snowDrainLimit then snowDrainDAD = snowDrainLimit end
		setHealth(getProperty("health") - snowDrainBF)
		runHaxeCode([[setVar("healthDad", getVar("healthDad") - ]]..snowDrainDAD..[[);]])
	
		setProperty("snowFallingVG.alpha", math.lerp(getProperty("snowFallingVG.alpha"), (snowDrainBF * 10) / snowDrainLimit, 0.77))
	end
end
local drainRateMult = snowDrainRate / 2;
function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
	if not isSustainNote then snowDrainBF = snowDrainBF - (drainRateMult * playbackRate); else snowDrainBF = snowDrainBF - ((drainRateMult / 3) * playbackRate); end
end
function opponentNoteHit(index, noteDir, noteType, isSustainNote)
	if not isSustainNote then snowDrainDAD = snowDrainDAD - (drainRateMult * playbackRate); else snowDrainDAD = snowDrainDAD - ((drainRateMult / 3) * playbackRate); end
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
	doTweenAlpha("snow", "snowFalling", 1, 1 / playbackRate, "sineInOut")

	eventEnabled = true;
end
function deactivateEvent()
	eventEnabled = false;

	doTweenAlpha("snow", "snowFalling", 0, 1 / playbackRate, "sineInOut")
	doTweenAlpha("snow2", "snowFallingFlipped", 0, 1 / playbackRate, "sineInOut")
	doTweenAlpha("snowVG", "snowFallingVG", 0, 1 / playbackRate, "sineInOut")

	removeLuaScript("scripts/events/"..eventName) --removes event
end