package spacetaxi.hud;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxRandom;
import flixel.addons.text.FlxTypeText;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxTimer;

import spacetaxi.utils.AssetDataUtil;

/**
 * ...
 * @author Jams
 */
class AlienHUD
{

	public function new() 
	{
		_alienSpeechBubble = new FlxSprite(FlxG.camera.x + 100 + MARGIN, FlxG.camera.y + FlxG.camera.height - 100 - MARGIN, AssetDataUtil.SPEECH_BUBBLE);
		_alienSpeechBubble.scrollFactor.set(0, 0);
		_alienSpeechBubble.alpha = 0;
		
		_alienPortrait = new FlxSprite(FlxG.camera.x + MARGIN, FlxG.camera.y + FlxG.camera.height - 100 - MARGIN, getRandomAlienPortrait());
		_alienPortrait.alpha = 0;
		_alienPortrait.scrollFactor.set(0, 0);
		
		_alienText = new FlxTypeText(FlxG.camera.x + 100 + (MARGIN*4), FlxG.camera.y + FlxG.camera.height - 100, 160, "", 16);
		_alienText.color = FlxColor.BLACK;
		_alienText.waitTime = 4.0;
		_alienText.setTypingVariation(0.75, true);
		_alienText.scrollFactor.set(0, 0);
		_alienText.delay = 0.1;
		
		FlxG.state.add(_alienPortrait);
		FlxG.state.add(_alienSpeechBubble);
		FlxG.state.add(_alienText);
		
		_alienTrip = false;
		_alienTalking = false;
	}
	
	public function updateHud():Void
	{
		
	}
	
	public function newAlien(startStr:String):Void
	{
		_alienTrip = true;
		_alienPortrait.loadGraphic(getRandomAlienPortrait());
		_alienPortrait.alpha = 1;
		alienSays(startStr, true);
		_alienObjective = startStr;
		_alienRemindTimer = new FlxTimer(20, remindCallback);
	}
	
	public function remindCallback(timer:FlxTimer):Void
	{
		alienSays(_alienObjective, true);
	}
	
	public function endAlien(success:Bool):Void
	{
		if (_alienRemindTimer != null)
			_alienRemindTimer.cancel();
		_alienTrip = false;
		if (success)
			alienSays("Thanks for the ride! Here's some money!", true);
		else
			alienSays("This is taking forever, I'm getting out.", true);
	}
	
	public function alienSays(str:String, force:Bool=false):Void
	{
		if (force || (_alienTrip && !_alienTalking))
		{
			_alienSpeechBubble.alpha = 1;
			_alienText.resetText(str);
			_alienText.alpha = 1;
			_alienText.start(0.04, false, true, null, null, onAlienSaysComplete, ["Fully typed"]);
			_alienTalking = true;
		}
	}
	
	public function alienAngryAtAsteroid():Void
	{
		var rand : Int = new FlxRandom().int(0, 6);
		switch(rand)
		{
			case 0:
				alienSays("Hey, watch out for that Asteroid!");
			case 1:
				alienSays("Watch where you're flying!");
			case 2:
				alienSays("Be careful you dummy!!");
			case 3:
				alienSays("You almost got us killed!");
			case 4:
				alienSays("What are you even doing?");
			case 5:
				alienSays("How are you driving so poorly?");
			case 6:
				alienSays("Stop being so reckless!");
		}
	}
	
	private function onAlienSaysComplete(Text:String):Void
	{
		_eraseTimer = new FlxTimer(3.0, alphaOutSpeech);
	}
	
	private function alphaOutSpeech(timer:FlxTimer):Void
	{
		_alienSpeechBubble.alpha = 0;
		_alienText.alpha = 0;
		if (!_alienTrip)
			_alienPortrait.alpha = 0;
		_alienTalking = false;
	}
	
	private function getRandomAlienPortrait():String
	{
		return AssetDataUtil.ALIEN_PORTRAIT_RAND + Std.string(Std.int(Math.random() * 8)) + ".png";
	}
	
	private var _alienObjective:String;
	private var _alienRemindTimer:FlxTimer;
	
	private var _alienTalking : Bool;
	private var _alienPortrait:FlxSprite;
	private var _alienSpeechBubble:FlxSprite;
	private var _alienText:FlxTypeText;
	private var _alienTrip:Bool;
	private var _eraseTimer:FlxTimer;
	
	static var MARGIN : Float = 10;
}