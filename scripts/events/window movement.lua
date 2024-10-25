local eventEnabled = false;

local eventName = ""
local eventNumb = 0;
local eventTime = 0;
local player = 0;

--template variables
local randomChar = {"boyfriend", "dad"}
local randomStrum = {"playerStrums", "opponentStrums"}

--event script variables
local windowPos = {300,200}
local windowLerpPos = {300,200}
local windowModes = {"circle", "hover"}
local currentWindowMode = 2;

function setWindow(prop, value)
	setPropertyFromClass("lime.app.Application", "current.window."..prop, value)
	--runHaxeCode([[Application.current.window.]]..prop..[[ = ]]..value..[[;]])
end
function getWindow(prop)
	return getPropertyFromClass("lime.app.Application", "current.window."..prop)
	--runHaxeCode([[setVar("windowPropReturnVal", Application.current.window.]]..prop..[[);]])
	--return getVar("windowPropReturnVal");
end
function math.lerp(a, b, ratio)
	return a + ratio * (b - a);
end

local elapsedtime = 0.0;
function onUpdate(elapsed)
	if not eventEnabled then return; end
    elapsedtime = elapsedtime + elapsed;

	setWindow("x", math.lerp(windowLerpPos[1], tonumber(getWindow("x")), 0.88))
	setWindow("y", math.lerp(windowLerpPos[2], tonumber(getWindow("y")), 0.88))
	
	if windowModes[currentWindowMode] == "circle" then
		windowLerpPos[1] = windowPos[1] + (math.sin(elapsedtime) * 25)
		windowLerpPos[2] = windowPos[2] + (math.cos(elapsedtime) * 50)
	end
	if windowModes[currentWindowMode] == "hover" then
		windowLerpPos[1] = windowPos[1] + (math.sin(elapsedtime) * 20)
		windowLerpPos[2] = windowPos[2] + (math.cos(elapsedtime) * 75)
	end
end

function activateEvent(evName, evNum, evT, evP)
	eventName = evName; eventNum = evNum; eventTime = evT; player = evP;

	elapsedtime = 0.0;

	--setWindow("fullscreen", false)
	currentWindowMode = getRandomInt(1, #windowModes)
	windowPos = {tonumber(getWindow("x")), tonumber(getWindow("y"))}
	print("WINDOW POS: "..windowPos[1]..","..windowPos[2])

	eventEnabled = true;
end
function deactivateEvent()
	eventEnabled = false;

	--[[setWindow("x", windowPos[1])
	setWindow("y", windowPos[2])--]]

	removeLuaScript("scripts/events/"..eventName) --removes event
end