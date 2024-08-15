--Settings:
isBFTargeted = false; --Should Boyfriend be the only one affected by events? (true / false)
endWhenOpponentHealthGoesToZero = false; -- (true / false) (DOES NOT WORK RIGHT NOW!))))

local eventLength = 15; --How long should events last? (in seconds)
local eventDelay = 5; --How long before another event happens? (in seconds)
local textStringTimer = 5; --How long should text stay on screen after event description is shown? (in seconds)

--events
local eventNum = 0;
local eventList = { --{name='', desc="", customTimer=nil}
	{name='note spinning', desc="Somebody's notes will start spinning!", customTimer=nil},
	{name='note alpha', desc="Somebody's notes will be transparent!", customTimer=nil},
	{name='poison', desc="Somebody will be poisoned!", customTimer=nil},
	{name='flash bang', desc="Somebody will be sent a flash bang!", customTimer=5},
	{name='random scrollspeed', desc="The scroll speed will be random!", customTimer=nil},
	{name='random notespeed', desc="Every notes's speed will be randomized!", customTimer=nil},
	{name='snow', desc="Heavy Snowfall will start, sing to remain warm!", customTimer=nil},
	{name='invinsible', desc="Somebody is invinsible!", customTimer=nil},
	{name='rebirth', desc="Somebody will receive one rebirth!", customTimer=5},
	{name='frozen', desc="Somebody will be frozen!", customTimer=nil},
	--{name='darkness', desc="Everyone's screen will go dark (use the flashlight!)", customTimer=nil},
	--{name='flash beacon', desc="Everyone's screen will go dark (use the flash beacon!)", customTimer=nil},
	{name='corruption', desc="Somebody's game didn't properly load!", customTimer=nil}
	--{name='jumpscare', desc="AHHHHHHHHHHHHHHHHHH", customTimer=5}
}
--debug
local forcedEvent = 0; --0 = disabled

local randomPlayerEvent = 0;


local oldFPS = 60;
local overrideFPS = 60;
function onSongStart()
	runTimer("horrificHousingEvent", eventDelay)

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

function activateEvent()
	eventNum = getRandomInt(1, #eventList);
	if forcedEvent ~= 0 then eventNum = forcedEvent; end

	local eventName = eventList[eventNum]["name"];
	local eventDescription = eventList[eventNum]["desc"];
	local eventTimer = eventList[eventNum]["customTimer"];
	
	randomPlayerEvent = getRandomInt(1, 2)
	if isBFTargeted then randomPlayerEvent = 1; end
	if eventTimer ~= nil then
		eventTimer = eventTimer / playbackRate;
		runTimer("horrificHousingEventEnd", eventTimer)
	else
		eventTimer = eventLength / playbackRate;
		runTimer("horrificHousingEventEnd", eventTimer)
	end
	runTimer("horrificHousingEventTxt", textStringTimer / playbackRate)
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
	end
end

function skipEvent()
	runTimer("horrificHousingEventEnd", textStringTimer / playbackRate)
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