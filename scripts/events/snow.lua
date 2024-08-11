local eventEnabled = false;

local eventName = ""
local eventNumb = 0;
local eventTime = 0;
local player = 0;

--template variables
local randomChar = {"boyfriend", "dad"}
local randomStrum = {"playerStrums", "opponentStrums"}

--event script variables
local hudObjs = {"healthBar", "healthBarBG", "iconP2", "iconP1"}
local snowDrainLimit = 2 / 3;
local snowDrainRate = 0.2;
local snowDrainBF = 0.0;
local snowDrainDAD = 0.0;

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
	--setHealth(1)

	snowDrainBF = snowDrainBF + ((snowDrainRate * 0.00001) * playbackRate);
	snowDrainDAD = snowDrainDAD + ((snowDrainRate * 0.00001) * playbackRate);
	--if snowDrainBF > (snowDrainLimit * 0.00001) then snowDrainBF = snowDrainLimit * 0.00001 end
	if snowDrainBF <= 0 then snowDrainBF = 0; end
	--if snowDrainDAD > (snowDrainLimit * 0.00001) then snowDrainDAD = snowDrainLimit * 0.00001 end
	if snowDrainDAD <= 0 then snowDrainDAD = 0; end
	local healthBF = 0 + (getProperty("heatBarBF.percent") * .01)
	local healthDAD = 1 * (getProperty("heatBarDAD.percent") * .01)
	setHealth(healthBF + healthDAD)
	--print("Heat: "..(100 - math.floor(((snowDrainBF * 240) / snowDrainLimit) * 100)).."%")

	runHaxeCode([[
		getVar("heatBarBF").percent = ]]..(100 - math.floor(((snowDrainBF * 240) / snowDrainLimit) * 100))..[[;
		getVar("heatBarDAD").percent = ]]..(100 - math.floor(((snowDrainDAD * 240) / snowDrainLimit) * 100))..[[;
	]])

	setProperty("snowFallingVG.alpha", math.lerp(getProperty("snowFallingVG.alpha"), (snowDrainBF * 250) / snowDrainLimit, 0.77))
	--setProperty("snowFallingVG.alpha", (snowDrain * 250) / snowDrainLimit)
end
function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
	local drainRateMult = snowDrainRate * 0.0004;
	if not isSustainNote then snowDrainBF = snowDrainBF - (drainRateMult * playbackRate); else snowDrainBF = snowDrainBF - ((drainRateMult / 3) * playbackRate); end
end
function opponentNoteHit(index, noteDir, noteType, isSustainNote)
	local drainRateMult = snowDrainRate * 0.0004;
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
		runHaxeCode([[
			var heatBarBFBG = new AttachedSprite('heatBar');
			heatBarBFBG.x = 1018;
			heatBarBFBG.y = 616;
			heatBarBFBG.scrollFactor.set();
			heatBarBFBG.xAdd = -4;
			heatBarBFBG.yAdd = -4;
			heatBarBFBG.camera = game.camHUD;
			game.add(heatBarBFBG);
			setVar("heatBarBFBG", heatBarBFBG);
	
			var heatBarBF = new FlxBar(heatBarBFBG.x + 4, heatBarBFBG.y + 4, null, Std.int(heatBarBFBG.width - 8), Std.int(heatBarBFBG.height - 8), null,
				'', 0, 100);
			heatBarBF.scrollFactor.set();
			heatBarBF.camera = game.camHUD;
			heatBarBF.scale.set(0.983, 0.946);
			// healthBar
			game.add(heatBarBF);
			setVar("heatBarBF", heatBarBF);
			heatBarBFBG.sprTracker = heatBarBF;
	
			heatBarBF.createFilledBar(0x00000000, 0xFFFF0C00);//.createFilledBar(Std.parseInt(0xFF8A0101), Std.parseInt(0xFF1565C0));
			heatBarBF.updateBar();
	
			var heatBarDADBG = new AttachedSprite('heatBar');
			heatBarDADBG.x = 18;
			heatBarDADBG.y = 616;
			heatBarDADBG.scrollFactor.set();
			heatBarDADBG.xAdd = -4;
			heatBarDADBG.yAdd = -4;
			heatBarDADBG.flipX = true;
			heatBarDADBG.camera = game.camHUD;
			game.add(heatBarDADBG);
			setVar("heatBarDADBG", heatBarDADBG);
	
			var heatBarDAD = new FlxBar(heatBarDADBG.x + 4, heatBarDADBG.y + 4, null, Std.int(heatBarDADBG.width - 8), Std.int(heatBarDADBG.height - 8), null,
				'', 0, 100);
			heatBarDAD.scrollFactor.set();
			heatBarDAD.camera = game.camHUD;
			heatBarDAD.scale.set(0.983, 0.946);
			heatBarDAD.flipX = true;
			// healthBar
			game.add(heatBarDAD);
			setVar("heatBarDAD", heatBarDAD);
			heatBarDADBG.sprTracker = heatBarDAD;
	
			heatBarDAD.createFilledBar(0x00000000, 0xFFFF0C00);//.createFilledBar(Std.parseInt(0xFF8A0101), Std.parseInt(0xFF1565C0));
			heatBarDAD.updateBar();
		]])
	end
	runHaxeCode([[
		getVar("heatBarBF").percent = ]]..(100 - math.floor(((snowDrainBF * 240) / snowDrainLimit) * 100))..[[;
		getVar("heatBarDAD").percent = ]]..(100 - math.floor(((snowDrainDAD * 240) / snowDrainLimit) * 100))..[[;
	]])
	runHaxeCode([[
		getVar("heatBarBFBG").visible = true;
		getVar("heatBarBF").visible = true;
		getVar("heatBarDADBG").visible = true;
		getVar("heatBarDAD").visible = true;
	]])
	for i = 1, #hudObjs do
		doTweenAlpha(hudObjs[i], hudObjs[i], 0, 1 / playbackRate, "sineInOut")
	end
	doTweenAlpha("snow", "snowFalling", 1, 1 / playbackRate, "sineInOut")

	eventEnabled = true;
end
function deactivateEvent()
	eventEnabled = false;

	doTweenAlpha("bfCold", "boyfriendCold", 0, 1 / playbackRate, "sineInOut")
	doTweenAlpha("snow", "snowFalling", 0, 1 / playbackRate, "sineInOut")
	doTweenAlpha("snow2", "snowFallingFlipped", 0, 1 / playbackRate, "sineInOut")
	doTweenAlpha("snowVG", "snowFallingVG", 0, 1 / playbackRate, "sineInOut")
	runHaxeCode([[
		getVar("heatBarBFBG").visible = false;
		getVar("heatBarBF").visible = false;
		getVar("heatBarDADBG").visible = false;
		getVar("heatBarDAD").visible = false;
	]])
	for i = 1, #hudObjs do
		doTweenAlpha(hudObjs[i], hudObjs[i], 1, 1 / playbackRate, "sineInOut")
	end
	--[[local healthBF = 0 + (getProperty("heatBarBF.percent") * .01)
	local healthDAD = 1 * (getProperty("heatBarDAD.percent") * .01)
	setHealth(healthBF + healthDAD)--]]

	removeLuaScript("scripts/events/"..eventName) --removes event
end