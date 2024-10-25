--Settings:
gamemodes = {'normal', 'fast', 'random'}
gamemode = 'normal' --How should the game act? (options are above!!!)
isBFTargeted = false; --Should Boyfriend be the only one affected by events? (true / false)
opponentNoteMissChance = 10; --Chance for Opponent to miss a note (0-100)
endWhenOpponentHealthGoesToZero = false; -- (true / false) (DOES NOT WORK RIGHT NOW!))))

local eventLength = 10; --How long should events last? (in seconds)
local eventDelay = 5; --How long before another event happens? (in seconds)
local textStringTimer = 5; --How long should text stay on screen after event description is shown? (in seconds)

--events
local eventNum = 0;
local eventList = { --{name='', desc="", customTimer=nil}
	{name='note spinning', desc="Somebody's notes will start spinning!", customTimer=nil},
	{name='note alpha', desc="Somebody's notes will be transparent!", customTimer=nil},
	{name='note scale', desc="Somebody's notes will change size!", customTimer=nil},
	{name='poison', desc="Somebody will be poisoned!", customTimer=nil},
	{name='regeneration', desc="Somebody will gain regeneration!", customTimer=nil},
	{name='flash bang', desc="Somebody will be sent a flash bang!", customTimer=5},
	{name='random scrollspeed', desc="The scroll speed will be random!", customTimer=nil},
	{name='random notespeed', desc="Every notes's speed will be randomized!", customTimer=nil},
	{name='snow', desc="Heavy Snowfall will start, sing to remain warm!", customTimer=nil},
	{name='invinsible', desc="Somebody is invinsible!", customTimer=nil},
	{name='rebirth', desc="Somebody will receive one rebirth!", customTimer=5},
	{name='frozen', desc="Somebody will be frozen!", customTimer=nil},
	{name='strum swap', desc="Two player's notes will swap positions!", customTimer=nil},
	{name='shuffle', desc="Shuffle: All players will swap positions", customTimer=5},
	{name='1 hp', desc="Someone will play 1 hp on their own", customTimer=0.001},
	{name='wide', desc="Somebody is wide", customTimer=0.001},
	{name='life linked', desc="2 players are life linked", customTimer=0.001},
	--{name='darkness', desc="Everyone's screen will go dark (use the flashlight!)", customTimer=nil},
	--{name='flash beacon', desc="Everyone's screen will go dark (use the flash beacon!)", customTimer=nil},
	{name='corruption', desc="Somebody's game didn't properly load!", customTimer=nil},
	{name='window movement', desc="Someone's game will start moving!", customTimer=nil},
	{name='half health', desc="A player will lose half their halth", customTimer=0.001}
	--{name='heart attack', desc="Somebody will have a heart attack!", customTimer=nil}
	--{name='', desc="", customTimer=nil}
	--{name='random strumnote', desc="Someone will receive another strum note", customTimer=nil}
	--{name='jumpscare', desc="AHHHHHHHHHHHHHHHHHH", customTimer=5}
}
local randomPlayerEvent = 0;
--debug
local forcedEvent = 0; --0 = disabled

function onCreatePost()
	if string.lower(gamemode) == "random" then
		gamemode = gamemodes[getRandomInt(1, #gamemodes, ""..#gamemodes)]
	end
	if string.lower(gamemode) == "" or string.lower(gamemode) == "normal" then
		eventLength = 10; --How long should events last? (in seconds)
		eventDelay = 5; --How long before another event happens? (in seconds)
	end
	if string.lower(gamemode) == "fast" then
		eventLength = 5; --How long should events last? (in seconds)
		eventDelay = 0; --How long before another event happens? (in seconds)
	end
	for i = 0, getProperty("unspawnNotes.length") do
		if getRandomBool(opponentNoteMissChance) and not getPropertyFromGroup("unspawnNotes", i, "mustPress") and not getPropertyFromGroup("unspawnNotes", i, "isSustainNote") then setPropertyFromGroup("unspawnNotes", i, "ignoreNote", true) end
	end
end
local oldFPS = 60;
local overrideFPS = 60;
function onSongStart()
	runTimer("horrificHousingEvent", eventDelay / playbackRate)

	if stringStartsWith(version, '0.6') then oldFPS = getPropertyFromClass("ClientPrefs", "framerate") else oldFPS = getPropertyFromClass("backend.ClientPrefs", "data.framerate") end
	runHaxeCode([[
		var framerate = ]]..overrideFPS..[[;
		if(framerate > FlxG.drawFramerate) {
			FlxG.updateFramerate = framerate;
			FlxG.drawFramerate = framerate;
		} else {
			FlxG.drawFramerate = framerate;
			FlxG.updateFramerate = framerate;
		}
	]])
end
function onUpdate(elapsed)
	for i = 0, getProperty("notes.length") do		
		if (getSongPosition() > (getProperty("noteKillOffset") - 10) + getPropertyFromGroup("notes", i, "strumTime")) and not getPropertyFromGroup("notes", i, "mustPress") then
			runHaxeCode([[setVar("healthDad", getVar("healthDad") - ]]..getPropertyFromGroup("notes", i, "missHealth")..[[);]])
			--setProperty("vocals.volume", 0) --not enjoyable
			--playSound("missnote"..getRandomInt(1, 3))
			removeFromGroup("notes", i, false)
		end
	end
end

function activateEvent()
	eventNum = getRandomInt(1, #eventList);
	if forcedEvent ~= 0 then eventNum = forcedEvent; end

	local eventName = eventList[eventNum]["name"];
	local eventDescription = eventList[eventNum]["desc"];
	local eventTimer = eventList[eventNum]["customTimer"];
	
	randomPlayerEvent = getRandomInt(1, 2)
	if isBFTargeted then randomPlayerEvent = 1; end
	if eventTimer ~= nil then eventTimer = eventTimer / playbackRate; else eventTimer = eventLength / playbackRate; end
	if eventDescription ~= nil then
		setTextString("robloxBlackBarTxt", eventDescription)
	else
		setTextString("robloxBlackBarTxt", 'No text has been set for event "'..eventName..'"')
	end
	updateHitbox("robloxBlackBarTxt")
	screenCenter("robloxBlackBarTxt", 'x')

	if checkFileExists("scripts/events/"..eventName..".lua", false) then
		addLuaScript("scripts/events/"..eventName, false)
		callScript("scripts/events/"..eventName, "activateEvent", {eventName, eventNum, eventTimer, randomPlayerEvent})
	else
		setTextString("robloxBlackBarTxt", 'Event File "'..eventName..'.lua" does not exist, skipping event...')
		updateHitbox("robloxBlackBarTxt")
		screenCenter("robloxBlackBarTxt", 'x')
		skipEvent()
		return;
	end

	runTimer("horrificHousingEventEnd", eventTimer)
	runTimer("horrificHousingEventTxt", textStringTimer / playbackRate)
end

function skipEvent()
	runTimer("horrificHousingEventEnd", eventDelay / playbackRate)
	runTimer("horrificHousingEventTxt", textStringTimer / playbackRate)
end

function resetEvents()
	callScript("scripts/events/"..eventList[eventNum]["name"], "deactivateEvent")
	runTimer("horrificHousingEvent", eventDelay / playbackRate)
end
function onTimerCompleted(tag, loops, loopsLeft)
	if tag == "horrificHousingEvent" then activateEvent() end

	if tag == "horrificHousingEventTxt" then setTextString("robloxBlackBarTxt", "") end

	if tag == "horrificHousingEventEnd" then resetEvents() end
end

function onDestroy()
	runHaxeCode([[
		var framerate = ]]..overrideFPS..[[;
		if(framerate > FlxG.drawFramerate) {
			FlxG.updateFramerate = framerate;
			FlxG.drawFramerate = framerate;
		} else {
			FlxG.drawFramerate = framerate;
			FlxG.updateFramerate = framerate;
		}
	]])
end