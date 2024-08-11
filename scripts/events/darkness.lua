local eventEnabled = false;

local eventName = ""
local eventNumb = 0;
local eventTime = 0;
local player = 0;

--template variables
local randomChar = {"boyfriend", "dad"}
local randomStrum = {"playerStrums", "opponentStrums"}

--event script variables
local flashLightPower = 100;
local flashLightOn = false;

local elapsedtime = 0.0;
function onUpdate(elapsed)
	if not eventEnabled then return; end
    elapsedtime = elapsedtime +elapsed;

	setProperty("darknessLight.x", getMouseX("other"))
	setProperty("darknessLight.y", getMouseY("other"))
	if mouseClicked("left") then flashLightOn = not flashLightOn end
	setProperty("darknessLight.visible", flashLightOn)
	if flashLightOn and flashLightPower ~= 0 then flashLightPower = flashLightPower - (elapsed * (eventTime / 1.005)) end
	if math.floor(flashLightPower) < 0 then flashLightPower = 0; doTweenAlpha("darknessLight", "darknessLight", 0, 1, "") end
	setTextString("flashlightPower", "Flashlight Power: "..math.floor(flashLightPower).."%")
end

function activateEvent(evName, evNum, evT, evP)
	eventName = evName; eventNum = evNum; eventTime = evT; player = evP;

	if not luaSpriteExists("darknessFlashLight") then
		makeLuaSprite('darknessFlashLight', '', 0, 0)
		makeGraphic('darknessFlashLight', '1280', '720', '000000')
		setProperty('darknessFlashLight.alpha', 0)
		setObjectCamera("darknessFlashLight", "other")
		updateHitbox("darknessFlashLight")
		screenCenter("darknessFlashLight", 'xy')
		addLuaSprite('darknessFlashLight', true)
	end
	doTweenAlpha("darknessFlashLight", "darknessFlashLight", 0.9335, 3, "")

	makeLuaSprite("darknessLight", "light", getMouseX("other"), getMouseY("other"))
	setObjectCamera("darknessLight", 'other')
	setBlendMode("darknessLight", 'add')
	scaleObject("darknessLight", 2.35, 2.35, true)
	addLuaSprite("darknessLight", false)
	setObjectOrder("darknessLight", getObjectOrder("darknessFlashLight") + 1)

	makeLuaText('flashlightPower', "Flashlight Power: "..flashLightPower, 0, 4, getProperty('healthBar.y') + 30)
	setObjectCamera('flashlightPower', 'other')
	setTextAlignment('flashlightPower', 'left')
	setTextSize('flashlightPower', 24)
	setTextBorder('flashlightPower', 1.5, '000000')
	updateHitbox('flashlightPower')
	addLuaText('flashlightPower')
	setProperty("flashlightPower.alpha", 0)
	doTweenAlpha("flashlightPower", "flashlightPower", 1, 2.5, "")

	flashLightOn = false;
	flashLightPower = 100;

	eventEnabled = true;
end
function deactivateEvent()
	eventEnabled = false;

	doTweenAlpha("darknessFade", "darknessFlashLight", 0, 1, "")
	removeLuaSprite("darknessLight", true)
	removeLuaText("flashlightPower", true)

	removeLuaScript("scripts/events/"..eventName) --removes event
end