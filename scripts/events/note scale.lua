local eventEnabled = false;

local eventName = ""
local eventNumb = 0;
local eventTime = 0;
local player = 0;

--template variables
local randomChar = {"boyfriend", "dad"}
local randomStrum = {"playerStrums", "opponentStrums"}

--event script variables
local randomNoteSize = {0.5, 0.8}

local elapsedtime = 0.0;
function onUpdate(elapsed)
	if not eventEnabled then return; end
    elapsedtime = elapsedtime +elapsed;
end
function activateEvent(evName, evNum, evT, evP)
	eventName = evName; eventNum = evNum; eventTime = evT; player = evP;

	for i = 1, getProperty(randomStrum[player]..".length") do
		setPropertyFromGroup(randomStrum[player], i, "scale.x", getRandomFloat(randomNoteSize[1], randomNoteSize[2]))
		setPropertyFromGroup(randomStrum[player], i, "scale.y", getRandomFloat(randomNoteSize[1], randomNoteSize[2]))
	end
	for i = 0, getProperty("unspawnNotes.length") do
		if getPropertyFromGroup("unspawnNotes", i, "mustPress") then
			setPropertyFromGroup("unspawnNotes", i, "scale.x", getPropertyFromGroup("playerStrums", getPropertyFromGroup("unspawnNotes", i, "noteData"), "scale.x"))
			setPropertyFromGroup("unspawnNotes", i, "scale.y", getPropertyFromGroup("playerStrums", getPropertyFromGroup("unspawnNotes", i, "noteData"), "scale.y"))
		end
		if not getPropertyFromGroup("unspawnNotes", i, "mustPress") then
			setPropertyFromGroup("unspawnNotes", i, "scale.x", getPropertyFromGroup("opponentStrums", getPropertyFromGroup("unspawnNotes", i, "noteData"), "scale.x"))
			setPropertyFromGroup("unspawnNotes", i, "scale.y", getPropertyFromGroup("opponentStrums", getPropertyFromGroup("unspawnNotes", i, "noteData"), "scale.y"))
		end
	end

	eventEnabled = true;
end
function deactivateEvent()
	eventEnabled = false;

	removeLuaScript("scripts/events/"..eventName) --removes event
end