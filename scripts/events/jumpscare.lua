local eventEnabled = false;

local eventName = ""
local eventNumb = 0;
local eventTime = 0;
local player = 0;

--template variables
local randomChar = {"boyfriend", "dad"}
local randomStrum = {"playerStrums", "opponentStrums"}

--event script variables


local elapsedtime = 0.0;
function onUpdate(elapsed)
	if not eventEnabled then return; end
    elapsedtime = elapsedtime +elapsed;
end

function activateEvent(evName, evNum, evT, evP)
	eventName = evName; eventNum = evNum; eventTime = evT; player = evP;

	local jumpscareImgs = {"39", "eeee", "james"}
	makeLuaSprite("jumpscare", "jumpscares/"..jumpscareImgs[getRandomInt(1, #jumpscareImgs)], 0, 0)
	setObjectCamera("jumpscare", 'OTHER')
	setGraphicSize("jumpscare", 1280, 720, true)
	updateHitbox("jumpscare")
	screenCenter("jumpscare", 'xy')
	setProperty("jumpscare.alpha", 1)
	addLuaSprite("jumpscare", false)
	--setBlendMode("jumpscare", "add")
	doTweenAlpha("jumpscareFade", "jumpscare", 0, 2)

	playSound("jumpscares/"..getRandomInt(1, 4))

	eventEnabled = true;
end
function deactivateEvent()
	eventEnabled = false;
	removeLuaScript("scripts/events/"..eventName) --removes event
end