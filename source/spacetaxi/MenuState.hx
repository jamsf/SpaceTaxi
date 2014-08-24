package spacetaxi;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;

import spacetaxi.states.ControlsState;
import spacetaxi.states.SpaceState;
import spacetaxi.utils.AssetDataUtil;


/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();
		
		FlxG.mouse.visible = false;
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		FlxG.sound.playMusic("title");
		
		_titleImage = new FlxSprite(0, 0, AssetDataUtil.TITLE);
		_titleImage.scrollFactor.set(0, 0);
		
		_creditImage = new FlxSprite(0, 0, AssetDataUtil.CREDITS);
		_creditImage.scrollFactor.set(0, 0);
		_creditImage.alpha = 0;
		
		add(_titleImage);
		add(_creditImage);
	}

	/**
	 * Function that is called when this state is destroyed - you might want to
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		if (FlxG.keys.justPressed.C)
		{
			_lookingAtCredits = !_lookingAtCredits;
			_creditImage.alpha = _creditImage.alpha == 0 ? 1 : 0;
		}
			
		if (!_lookingAtCredits && FlxG.keys.justPressed.ENTER)
			FlxG.switchState(new ControlsState());
	}
	
	private var _lookingAtCredits:Bool;
	private var _creditImage : FlxSprite;
	private var _titleImage : FlxSprite;
}