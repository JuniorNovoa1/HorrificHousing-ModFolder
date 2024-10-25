--[[local powerups = {}
function reposition_PowerUps()
	local positionAmount = getProperty(powerups[1]["name"].."powerup_BG.height") + 4
	for i = 1, #powerups do
		local objectBG = powerups[i]["name"].."powerup_BG"
		screenCenter(objectBG)
		setProperty(objectBG..".x", screenWidth - getProperty(objectBG..".width") - 4)
		setProperty(objectBG..".y", getProperty(objectBG..".y")+(positionAmount * (i-1)))
		setProperty(objectBG..".y", getProperty(objectBG..".y")-(positionAmount * math.floor(#powerups / 4)))
	end
end
function create_PowerUp(name, icon, eventLength, event, eventDesc)
	local bgObjName = name.."powerup_BG";
	local iconObjName = name.."powerup_ICON";
	local txtObjName = name.."powerup_TXT";
	makeLuaSprite(bgObjName, "content/powerups/bg", 0, 0)
	setObjectCamera(bgObjName, "hud")
	setProperty(bgObjName..".x", screenWidth - getProperty(bgObjName..".width") - 4)
	screenCenter(bgObjName)
	addLuaSprite(bgObjName)

	makeLuaSprite(iconObjName, "content/powerups/icons/"..icon, 0, 0)
	setObjectCamera(iconObjName, "hud")
	screenCenter(iconObjName)
	setProperty(iconObjName..".x", screenWidth - getProperty(iconObjName..".width") - 4)
	addLuaSprite(iconObjName)

	runTimer(name.."powerup_TIMER_END", eventLength)
	table.insert(powerups, {name=name,icon=icon,length=eventLength,event=event,eventDesc=eventDesc})
	print("New Powerup: "..powerups[#powerups]["name"])
	reposition_PowerUps()
end
function remove_PowerUp(name)
	for i = 1, #powerups do
		if powerups[i]["name"] == name then
			print("removing: "..name)
			table.remove(powerups, i)
			removeLuaSprite(name.."powerup_BG", false)
			removeLuaSprite(name.."powerup_ICON", false)
			reposition_PowerUps()
			--removeLuaText(name.."powerup_TXT", false)
			break;
		end
	end
end
function get_PowerUp(name)
	return powerups[name]
end
function onTimerCompleted(tag, loops, loopsLeft)
	if #powerups <= 1 then return; end
	local positionAmount = getProperty(powerups[1]["name"].."powerup_BG.height") + 4
	for i = 1, #powerups do
		if tag == powerups[i]["name"].."powerup_TIMER_END" then
			table.remove(powerups, i)
			removeLuaSprite(powerups[i]["name"].."powerup_BG", false)
			removeLuaSprite(powerups[i]["name"].."powerup_ICON", false)
			reposition_PowerUps()
			break;
		end
	end
end
function onUpdate(elapsed)
	if #powerups <= 1 then return; end
	for i = 1, #powerups do
		local objectBG = powerups[i]["name"].."powerup_BG"
		local objectICON = powerups[i]["name"].."powerup_ICON"
		setProperty(objectICON..".x", getProperty(objectBG..".x"))
		setProperty(objectICON..".y", getProperty(objectBG..".y"))
	end
end

function onSongStart()
	create_PowerUp("ev1", "immortal", 5, "e", "yes")
	create_PowerUp("ev2", "jump", 6, "e", "yes")
	create_PowerUp("ev3", "immortal", 3, "e", "yes")
	create_PowerUp("ev4", "stunned", 8, "e", "yes")
	print("Power: "..get_PowerUp("immortal")["name"])
end
--]]