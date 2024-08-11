local eventEnabled = false;

local eventName = ""
local eventNumb = 0;
local eventTime = 0;
local player = 0;

--template variables
local randomChar = {"boyfriend", "dad"}
local randomStrum = {"playerStrums", "opponentStrums"}

--event script variables
local frozen = false;

local elapsedtime = 0.0;
function onUpdate(elapsed)
	if not eventEnabled then return; end
    elapsedtime = elapsedtime +elapsed;

	runHaxeCode([[
		for (i in 0...game.]]..randomStrum[player]..[[.length) {
			var spr = game.]]..randomStrum[player]..[[.members[i];
			if(spr != null)
			{
				spr.playAnim('static', true);
			}
		}
	]])
	if player == 2 then
		for i = 0, getProperty("notes.length") do		
			if (getSongPosition() > (getProperty("noteKillOffset") - 10) + getPropertyFromGroup("notes", i, "strumTime")) and not getPropertyFromGroup("notes", i, "mustPress") then
				setProperty("health", getProperty("health") + getPropertyFromGroup("notes", i, "missHealth"))
				setProperty("vocals.volume", 0)
				--playSound("missnote"..getRandomInt(1, 3))
				removeFromGroup("notes", i, false)
			end
			setPropertyFromGroup("notes", i, "hitByOpponent", true)
		end
	elseif player == 1 then
		for i = 0, getProperty("notes.length") do
			setPropertyFromGroup("notes", i, "blockHit", true)
		end 
	end
end

function activateEvent(evName, evNum, evT, evP)
	eventName = evName; eventNum = evNum; eventTime = evT; player = evP;

	frozen = true;
	for i = 0, getProperty(randomStrum[player]..".length") do
		setPropertyFromGroup(randomStrum[player], i, "color", getColorFromHex("00FFEF"))
	end
	setProperty(randomChar[player]..".color", getColorFromHex("00FFEF"))
	setProperty(randomChar[player]..".skipDance", true)
	if player == 1 then setProperty("boyfriend.hasMissAnimations", false) end

	eventEnabled = true;
end
function deactivateEvent()
	eventEnabled = false;

	for i = 0, getProperty(randomStrum[player]..".length") do
		setPropertyFromGroup(randomStrum[player], i, "color", getColorFromHex("FFFFFF"))
	end
	if player == 2 then
		for i = 0, getProperty("notes.length") do
			setPropertyFromGroup("notes", i, "hitByOpponent", false)
		end
	elseif player == 1 then
		for i = 0, getProperty("notes.length") do
			setPropertyFromGroup("notes", i, "blockHit", false)
		end
	end

	setProperty(randomChar[player]..".color", getColorFromHex("FFFFFF"))
	setProperty(randomChar[player]..".skipDance", false)
	if player == 1 then runHaxeCode([[if(game.boyfriend.animOffsets.exists('singLEFTmiss') || game.boyfriend.animOffsets.exists('singDOWNmiss') || game.boyfriend.animOffsets.exists('singUPmiss') || game.boyfriend.animOffsets.exists('singRIGHTmiss')) game.boyfriend.hasMissAnimations = true;]]) end
	
	removeLuaScript("scripts/events/"..eventName) --removes event
end