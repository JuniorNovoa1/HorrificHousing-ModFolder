function onCreatePost()
	makeLuaSprite("robloxBlackBar", "content/blackBar", 0, 0)
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

	makeLuaSprite("coloredlogo", "content/ui/topBar/coloredlogo", 15, 14)
	setObjectCamera("coloredlogo", 'other')
	addLuaSprite("coloredlogo")
	createButtonBG("coloredlogo")
	makeLuaSprite("chatOff", "content/ui/topBar/chatOff", 55, 15)
	setObjectCamera("chatOff", 'other')
	setProperty("chatOff.offset.x", -3)
	setProperty("chatOff.offset.y", -1)
	addLuaSprite("chatOff")
	createButtonBG("chatOff")
	makeLuaSprite("moreOff", "content/ui/topBar/moreOff", screenWidth - 45, 15)
	setObjectCamera("moreOff", 'other')
	addLuaSprite("moreOff")
	createButtonBG("moreOff")

	setProperty("healthBar.visible", false)
	setProperty("healthBarBG.visible", false)

	runHaxeCode([[
		var bfHealthBarBG = new AttachedSprite('content/horrificHealthBarBG');
		bfHealthBarBG.camera = game.camHUD;
		bfHealthBarBG.x = game.healthBar.x + 690; //+ 195
		bfHealthBarBG.y = game.healthBar.y + 30; // - 22
		bfHealthBarBG.scale.set(1.5, 1.5);
		game.add(bfHealthBarBG);
		setVar("bfHealthBarBG", bfHealthBarBG);
		bfHealthBarBG.antialiasing = false;
		var bfHealthBar = new FlxBar(bfHealthBarBG.x + 4, bfHealthBarBG.y + 4, null, bfHealthBarBG.width, bfHealthBarBG.height, game, 'health', 0, 2);
		bfHealthBar.camera = game.camHUD;
		bfHealthBar.scale.set(1.5, 1.5);
		//bfHealthBar.numDivisions = 800;
		game.add(bfHealthBar);
		setVar("bfHealthBar", bfHealthBar);
		bfHealthBarBG.sprTracker = bfHealthBar;
		bfHealthBar.antialiasing = false;
		bfHealthBar.createImageBar(null, Paths.image('content/horrificHealthBar'), 0x00000000, 0xFF00FF00);
		bfHealthBar.updateBar();

		var dadHealthBarBG = new AttachedSprite('content/horrificHealthBarBG');
		dadHealthBarBG.camera = game.camHUD;
		dadHealthBarBG.x = game.healthBar.x - 305; //+ 195
		dadHealthBarBG.y = game.healthBar.y + 30; // - 22
		dadHealthBarBG.scale.set(1.5, 1.5);
		game.add(dadHealthBarBG);
		setVar("dadHealthBarBG", dadHealthBarBG);
		dadHealthBarBG.antialiasing = false;
		var dadHealthBar = new FlxBar(dadHealthBarBG.x + 4, dadHealthBarBG.y + 4, null, dadHealthBarBG.width, dadHealthBarBG.height, null, '', 0, 2);
		dadHealthBar.camera = game.camHUD;
		dadHealthBar.scale.set(1.5, 1.5);
		//dadHealthBar.numDivisions = 800;
		game.add(dadHealthBar);
		setVar("dadHealthBar", dadHealthBar);
		dadHealthBarBG.sprTracker = dadHealthBar;
		dadHealthBar.antialiasing = false;

		dadHealthBar.createImageBar(null, Paths.image('content/horrificHealthBar'), 0x00000000, 0xFF00FF00);
		dadHealthBar.updateBar();

		var healthDad = 2;
		setVar("healthDad", healthDad);
	]])
	setHealth(2)

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
function opponentNoteHit(index, noteDir, noteType, isSustainNote)
	runHaxeCode([[setVar("healthDad", getVar("healthDad") + ]]..getPropertyFromGroup("notes", index, "hitHealth")..[[);]])
end

function onUpdatePost(elapsed)
	runHaxeCode([[
		if (getVar("healthDad") > 2)
			setVar("healthDad", 2);
		if (getVar("healthDad") < 0)
			setVar("healthDad", 0);

		getVar("dadHealthBar").value = getVar("healthDad");
		
		game.iconP1.x = getVar("bfHealthBarBG").x + 80;
		game.iconP1.y = getVar("bfHealthBarBG").y - 100;

		game.iconP2.x = getVar("dadHealthBarBG").x - 50;
		game.iconP2.y = getVar("dadHealthBarBG").y - 115;

		if (getVar("dadHealthBar").percent < 20)
			game.iconP2.animation.curAnim.curFrame = 1;
		else
			game.iconP2.animation.curAnim.curFrame = 0;
	]])

	--[[if getGlobalFromScript("scripts/EventHandler", "endWhenOpponentHealthGoesToZero") then
		runHaxeCode([[
			if (getVar("healthDad") <= 0)
				game.endSong();
		]]--)
	--end
end

function createButtonBG(name)
	makeLuaSprite(name.."BG", "content/ui/topBar/iconBase", getProperty(name..".x")-4, getProperty(name..".y")-4)
	setObjectCamera(name.."BG", 'other')
	addLuaSprite(name.."BG")
	setObjectOrder(name.."BG", getObjectOrder(name) - 1)
end