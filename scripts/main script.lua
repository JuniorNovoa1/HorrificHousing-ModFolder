--setting
local bfOnlyTargeted = false;

local eventNum = 0;
local eventList = {
	[1] = 'note spinning',
	[2] = 'note alpha',
	[3] = 'poison',
	[4] = 'flash bang',
	[5] = 'random scrollspeed',
	[6] = 'snow',
	[7] = 'invinsible',
	[8] = 'rebirth',
	[9] = 'frozen',
	[10] = 'random notespeed'
}
local eventListTxt = {
	['note spinning'] = "Somebody's notes will start spinning!",
	['note alpha'] = "Somebody's notes will be transparent",
	['poison'] = "Somebody will be poisoned",
	['flash bang'] = "Somebody will be flashed!",
	['random scrollspeed'] = "The scroll speed will be random!",
	['snow'] = "Heavy Snowfall will start!",
	['invinsible'] = "Somebody is invinsible!",
	['rebirth'] = "Somebody will receive one rebirth!",
	['frozen'] = "Somebody is frozen!",
	['random notespeed'] = "Every notes's speed will be randomized!"
}

--event vars
local eventLastingTimer = 5;
local eventEndingTimer = 10; --timer after string to trigger event over
local textStringTimer = 5;

local canNoteSpin = false;
local poisoned = false;
local prevScrollSpeed = 0;
local canSnow = false;
local snowDamage = 0.0;
local rebirth = {false, false};
local frozen = false;

local randomPlayerEvent = 0;
local randomChar = {"dad", "boyfriend"}
local randomStrum = {"opponentStrums", "playerStrums"}

function onSongStart()
	runTimer("horrificHousingEvent", eventLastingTimer)

	--[[makeLuaSprite("iceCubeHorrific", "icecube", getProperty("boyfriend.x"), getProperty("boyfriend.y"))
	setGraphicSize("iceCubeHorrific", getProperty("boyfriend.width") * 1.35, getProperty("boyfriend.height") * 1.35, true)
	setProperty("iceCubeHorrific.x", getProperty("boyfriend.x") - (getProperty("boyfriend.width") / 6))
	setProperty("iceCubeHorrific.y", getProperty("boyfriend.y") - (getProperty("boyfriend.height") / 5.5))
	setProperty("iceCubeHorrific.color", getColorFromHex("00FFEF"))
	--screenCenter("iceCubeHorrific", 'xy')
	setProperty("iceCubeHorrific.alpha", 1)
	addLuaSprite("iceCubeHorrific", true)
	setProperty("iceCubeHorrific.visible", true)--]] --ugly ass image that i made
end

function onCreate()
	addHaxeLibrary("FlxTween", 'flixel.tweens')
	addHaxeLibrary("FlxEase", 'flixel.tweens')
	makeLuaSprite("robloxMenuItems", "robloxHUD/RobloxMenuItems", 0, 0)
	setObjectCamera("robloxMenuItems", 'other')
	screenCenter("robloxMenuItems", 'xy')
	--addLuaSprite("robloxMenuItems", false)

	makeLuaSprite("robloxBlackBar", "robloxHUD/blackBar", 0, 0)
	setObjectCamera("robloxBlackBar", 'HUD')
	screenCenter("robloxBlackBar", 'xy')
	addLuaSprite("robloxBlackBar", false)

	makeLuaText("robloxBlackBarTxt", "", 0, 0, getProperty("robloxBlackBar.y") + 14)
	setTextAlignment("robloxBlackBarTxt", 'center')
	setObjectCamera("robloxBlackBarTxt", 'HUD')
	setTextSize("robloxBlackBarTxt", 18)
	updateHitbox("robloxBlackBarTxt")
	screenCenter("robloxBlackBarTxt", 'x')
	addLuaText("robloxBlackBarTxt")
end

function onCreatePost()
	if bfOnlyTargeted then setProperty("health", 2) end

	if not downscroll then
		setProperty("robloxBlackBar.y", getProperty("robloxBlackBar.y") + 32)
		setProperty("robloxBlackBarTxt.y", getProperty("robloxBlackBar.y") + 14)
		setProperty("timeBar.y", getProperty("timeBar.y") - 16) -- + 25
		setProperty("timeTxt.y", getProperty("timeTxt.y") - 16)
		for i = 0, getProperty("strumLineNotes.length") do
			setPropertyFromGroup("strumLineNotes", i, "y", getPropertyFromGroup("strumLineNotes", i, "y") + 25)
		end
	else
		setProperty("robloxBlackBar.y", getProperty("timeBar.y") - 32)
		setProperty("robloxBlackBarTxt.y", getProperty("robloxBlackBar.y") + 14)
		setProperty("timeBar.y", getProperty("timeBar.y") + 16) -- + 25
		setProperty("timeTxt.y", getProperty("timeTxt.y") + 16)
		for i = 0, getProperty("strumLineNotes.length") do
			setPropertyFromGroup("strumLineNotes", i, "y", getPropertyFromGroup("strumLineNotes", i, "y") - 25)
		end
	end
end

local elapsedtime = 0.0;
function onUpdate(elapsed)
    elapsedtime = elapsedtime +elapsed;

	if canNoteSpin then
		for i = 0, getProperty(randomStrum[randomPlayerEvent]..".length") do
    	    setPropertyFromGroup(randomStrum[randomPlayerEvent], i, "angle", getPropertyFromGroup(randomStrum[randomPlayerEvent], i, "angle") + (elapsed * 750) * playbackRate)
    	end
	end
	if poisoned then
		if randomPlayerEvent == 1 then setProperty("health", getProperty("health") + 0.00065) else setProperty("health", getProperty("health") - 0.00065) end
	end
	if canSnow then
		setProperty("snowFallingVG.alpha", snowDamage * 500)
		setProperty("health", getProperty("health") - snowDamage)
		snowDamage = snowDamage + (0.00000075 * playbackRate);
		if snowDamage <= 0 then snowDamage = 0; end
	end
	if eventList[eventNum] == "invinsible" then 
		if randomPlayerEvent == 1 then setProperty("health", 0.001) else setProperty("health", 1.999) end
	end
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
	if frozen then
		runHaxeCode([[
			for (i in 0...game.]]..randomStrum[randomPlayerEvent]..[[.length) {
				var spr = game.]]..randomStrum[randomPlayerEvent]..[[.members[i];
				if(spr != null)
				{
					spr.playAnim('static', true);
				}
			}
		]])
		if randomPlayerEvent == 1 then
			for i = 0, getProperty("notes.length") do		
				if (getSongPosition() > (getProperty("noteKillOffset") - 10) + getPropertyFromGroup("notes", i, "strumTime")) and not getPropertyFromGroup("notes", i, "mustPress") then
					setProperty("health", getProperty("health") + getPropertyFromGroup("notes", i, "missHealth"))
					setProperty("vocals.volume", 0)
					--playSound("missnote"..getRandomInt(1, 3))
					removeFromGroup("notes", i, false)
				end
				setPropertyFromGroup("notes", i, "hitByOpponent", true)
			end
		elseif randomPlayerEvent == 2 then
			for i = 0, getProperty("notes.length") do
				setPropertyFromGroup("notes", i, "blockHit", true)
			end 
		end
	end
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
	if canSnow then
		if not isSustainNote then snowDamage = snowDamage - ((snowDamage * 0.05) * playbackRate); else snowDamage = snowDamage - (((snowDamage * 0.0025) / 2) * playbackRate); end
	end
end

local scrollSpeedAmount = 0.25;

function activateEvent()
	eventNum = getRandomInt(1, #eventList);
	randomPlayerEvent = getRandomInt(1, 2)
	if bfOnlyTargeted then randomPlayerEvent = 2; end
	--eventNum = 5;
	runTimer("horrificHousingEventEnd", eventEndingTimer / playbackRate)
	runTimer("horrificHousingEventTxt", textStringTimer / playbackRate)
	setTextString("robloxBlackBarTxt", eventListTxt[eventList[eventNum]])
	updateHitbox("robloxBlackBarTxt")
	screenCenter("robloxBlackBarTxt", 'x')

	if eventList[eventNum] == "note spinning" then canNoteSpin = true; end
	if eventList[eventNum] == "note alpha" then
		if randomPlayerEvent == 1 then
			for i = 1, getProperty("opponentStrums.length") do
				noteTweenAlpha("noteStrumHorrificAlpha"..i, i -1, 0.35 / playbackRate, 1, "sineInOut")
    		end
		else
			for i = 1, getProperty("playerStrums.length") do
				noteTweenAlpha("noteStrumHorrificAlpha"..i, 3 + i, 0.35 / playbackRate, 1, "sineInOut")
    		end
		end
	end
	if eventList[eventNum] == "poison" then
		setProperty(randomChar[randomPlayerEvent]..".color", getColorFromHex("A020F0"))
		poisoned = true; 
	end
	if eventList[eventNum] == "flash bang" then
		if flashingLights then 
			cameraFlash("hud", "FFFFFF", 5.5 / playbackRate) 
			playSound("flash-bang", 1)
		else activateEvent() end
	end
	if eventList[eventNum] == "random scrollspeed" then 
		prevScrollSpeed = getProperty("songSpeed")
		runHaxeCode([[
			var songSpeedNew = ]]..getRandomFloat(1, 4)..[[;
			FlxTween.tween(game, {songSpeed: songSpeedNew}, 2, {ease: FlxEase.linear});
		]])
	end
	if eventList[eventNum] == "snow" then
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
		snowDamage = 0;
		canSnow = true;
		doTweenAlpha("snow", "snowFalling", 1, 1 / playbackRate, "sineInOut")
	end
	if eventList[eventNum] == "rebirth" then
		rebirth[randomPlayerEvent] = true;
		skipEvent()
	end
	if eventList[eventNum] == "frozen" then
		frozen = true;
		for i = 0, getProperty(randomStrum[randomPlayerEvent]..".length") do
			setPropertyFromGroup(randomStrum[randomPlayerEvent], i, "color", getColorFromHex("00FFEF"))
		end
		setProperty(randomChar[randomPlayerEvent]..".color", getColorFromHex("00FFEF"))
		setProperty(randomChar[randomPlayerEvent]..".skipDance", true)
		if randomPlayerEvent == 2 then setProperty("boyfriend.hasMissAnimations", false) end
	end
	if eventList[eventNum] == "random notespeed" then
		--[[for i = 0, getProperty("notes.length") do
			setPropertyFromGroup("notes", i, "multSpeed", getRandomFloat(getPropertyFromGroup("notes", i, "multSpeed") - (scrollSpeedAmount), getPropertyFromGroup("notes", i, "multSpeed")))
		end--]]
		for i = 0, getProperty("unspawnNotes.length") do
			setPropertyFromGroup("unspawnNotes", i, "multSpeed", getRandomFloat(getPropertyFromGroup("unspawnNotes", i, "multSpeed") - (scrollSpeedAmount), getPropertyFromGroup("unspawnNotes", i, "multSpeed")))
		end
	end
end

function skipEvent()
	runTimer("horrificHousingEventEnd", textStringTimer * 2)
	runTimer("horrificHousingEventTxt", textStringTimer)
end

function resetEvents()
	runTimer("horrificHousingEvent", eventLastingTimer)
	if eventList[eventNum] == "note spinning" then 
		canNoteSpin = false;
		if randomPlayerEvent == 1 then
			for i = 1, getProperty("opponentStrums.length") do
				noteTweenAngle("noteStrumHorrificAngle"..i, i -1, 0, 1 / playbackRate, "sineInOut")
    		end
		else
			for i = 1, getProperty("playerStrums.length") do
				noteTweenAngle("noteStrumHorrificAngle"..i, 3 + i, 0, 1 / playbackRate, "sineInOut")
    		end
		end
	end
	if eventList[eventNum] == "note alpha" then
		if randomPlayerEvent == 1 then
			for i = 1, getProperty("opponentStrums.length") do
				noteTweenAlpha("noteStrumHorrificAlpha"..i, i - 1, 1, 1 / playbackRate, "sineInOut")
    		end
		else
			for i = 1, getProperty("playerStrums.length") do
				noteTweenAlpha("noteStrumHorrificAlpha"..i, 3 + i, 1, 1 / playbackRate, "sineInOut")
    		end
		end
	end
	if eventList[eventNum] == "poison" then 
		setProperty(randomChar[randomPlayerEvent]..".color", getColorFromHex("FFFFFF"))
		poisoned = false; 
	end
	if eventList[eventNum] == "random scrollspeed" then 
		runHaxeCode([[
			var songSpeedNew = ]]..prevScrollSpeed..[[;
			FlxTween.tween(game, {songSpeed: songSpeedNew}, 2, {ease: FlxEase.linear});
		]])
	end
	if eventList[eventNum] == "snow" then
		canSnow = false;
		snowDamage = 0;
		doTweenAlpha("bfCold", "boyfriendCold", 0, 1 / playbackRate, "sineInOut")
		doTweenAlpha("snow", "snowFalling", 0, 1 / playbackRate, "sineInOut")
		doTweenAlpha("snowVG", "snowFallingVG", 0, 1 / playbackRate, "sineInOut")
	end
	if eventList[eventNum] == "frozen" then
		frozen = false;
		for i = 0, getProperty(randomStrum[randomPlayerEvent]..".length") do
			setPropertyFromGroup(randomStrum[randomPlayerEvent], i, "color", getColorFromHex("FFFFFF"))
		end
		if randomPlayerEvent == 1 then
			for i = 0, getProperty("notes.length") do
				setPropertyFromGroup("notes", i, "hitByOpponent", false)
			end
		elseif randomPlayerEvent == 2 then
			for i = 0, getProperty("notes.length") do
				setPropertyFromGroup("notes", i, "blockHit", false)
			end
		end

		setProperty(randomChar[randomPlayerEvent]..".color", getColorFromHex("FFFFFF"))
		setProperty(randomChar[randomPlayerEvent]..".skipDance", false)
		if randomPlayerEvent == 2 then runHaxeCode([[if(game.boyfriend.animOffsets.exists('singLEFTmiss') || game.boyfriend.animOffsets.exists('singDOWNmiss') || game.boyfriend.animOffsets.exists('singUPmiss') || game.boyfriend.animOffsets.exists('singRIGHTmiss')) game.boyfriend.hasMissAnimations = true;]]) end
	end
	if eventList[eventNum] == "random notespeed" then
		for i = 0, getProperty("notes.length") do
			setPropertyFromGroup("notes", i, "multSpeed", 1)
		end
		for i = 0, getProperty("unspawnNotes.length") do
			setPropertyFromGroup("unspawnNotes", i, "multSpeed", 1)
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == "horrificHousingEvent" then 
		activateEvent() 
	end

	if tag == "horrificHousingEventTxt" then 
		setTextString("robloxBlackBarTxt", "")
	end

	if tag == "horrificHousingEventEnd" then
		resetEvents() 
	end
end