local eventEnabled = false;

local eventName = "";
local eventNumb = 0;
local eventTime = 0;
local player = 0;

--template variables
local randomChar = {"boyfriend", "dad"}
local randomStrum = {"playerStrums", "opponentStrums"}

--event script variables
local shaderObjects = {""}
local binaryIntensity = 1000.0;
local negativity = 0.0;
local strumPositions = {};

local elapsedtime = 0.0;
function onUpdate(elapsed)
	if not eventEnabled then return; end
    elapsedtime = elapsedtime +elapsed;
	negativity = negativity - (elapsed * 10);
	if negativity < 0 then negativity = 0.0; end

	for i = 1, #shaderObjects do
		setShaderFloat(shaderObjects[i], 'binaryIntensity', binaryIntensity)
		setShaderFloat(shaderObjects[i], 'negativity', negativity)
	end

	local songPosition = getPropertyFromClass("Conductor", "songPosition")
    local firstEventNoteStrumTime = getProperty("eventNotes[0].strumTime") - 10 --2.75

    if songPosition > firstEventNoteStrumTime and getProperty("eventNotes[0].event") == "change character" then
        if getProperty("eventNotes[0].value1") == "bf" then
			removeSpriteShader("boyfriend")
		end
		if getProperty("eventNotes[0].value1") == "dad" then
			removeSpriteShader("dad")
		end
    end
end
function onStepHit()
	binaryIntensity = getRandomFloat(4, 6);
end
function onBeatHit()
	if not eventEnabled then return; end
		--disable this shit for performance reasons.
	--[[for i = 0, getProperty("notes.length") do
		if player == 1 and getPropertyFromGroup("notes", i, "mustPress") then
			table.insert(shaderObjects, "notes.members["..i.."]")
			setSpriteShader("notes.members["..i.."]", "Distortion")
		elseif player == 2 and not getPropertyFromGroup("notes", i, "mustPress") then
			table.insert(shaderObjects, "notes.members["..i.."]")
			setSpriteShader("notes.members["..i.."]", "Distortion")
		end
	end--]]
end
function goodNoteHit(index, noteDir, noteType, isSustainNote)
	if not eventEnabled then return; end
	if player == 1 then
		setPropertyFromGroup("playerStrums", noteDir, "x", strumPositions[noteDir+1][1] + getRandomInt(1, 8))
		setPropertyFromGroup("playerStrums", noteDir, "y", strumPositions[noteDir+1][2] + getRandomInt(1, 8))
	end
end
function opponentNoteHit(index, noteDir, noteType, isSustainNote)
	if not eventEnabled then return; end
	if player == 2 then
		setPropertyFromGroup("opponentStrums", noteDir, "x", strumPositions[noteDir+1][1] + getRandomInt(1, 8))
		setPropertyFromGroup("opponentStrums", noteDir, "y", strumPositions[noteDir+1][2] + getRandomInt(1, 8))
	end
end

function onEvent(eventName, value1, value2)
	if eventName == "Change Character" then
		if value1 == "bf" and player == 1 then
			setSpriteShader("boyfriend", "Distortion")
		end
		if value1 == "dad" and player == 2 then
			setSpriteShader("dad", "Distortion")
		end
	end
end

function activateEvent(evName, evNum, evT, evP)
	eventName = evName; eventNum = evNum; eventTime = evT; player = evP;
	initLuaShader("Distortion")

	--shaderObjects = {"robloxBlackBar", "robloxBlackBarTxt", "timeTxt", "healthBarBG"}
	if player == 2 then
		table.insert(shaderObjects, "iconP2")
		table.insert(shaderObjects, "dad")
	else
		shaderObjects = {"robloxBlackBar", "robloxBlackBarTxt", "timeTxt", "scoreTxt", "iconP1", "boyfriend",  "coloredlogo", "chatOff", "moreOff"}
	end
	for i = 0, getProperty(randomStrum[player]..".length") do
		table.insert(shaderObjects, randomStrum[player]..".members["..i.."]")
		table.insert(strumPositions, {getPropertyFromGroup(randomStrum[player], i, "x"), getPropertyFromGroup(randomStrum[player], i, "y")})
	end
	for i = 1, #shaderObjects do
		setSpriteShader(shaderObjects[i], "Distortion")
	end

	eventEnabled = true;
end
function deactivateEvent()
	eventEnabled = false;

	for i = 1, #shaderObjects do
		removeSpriteShader(shaderObjects[i])
	end

	removeLuaScript("scripts/events/"..eventName) --removes event
end