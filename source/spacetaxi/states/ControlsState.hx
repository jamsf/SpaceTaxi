package spacetaxi.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;

import spacetaxi.states.SpaceState;
import spacetaxi.utils.AssetDataUtil;


/**
 * A FlxState which can be used for the game's menu.
 */
class ControlsState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();
		
		_controlsImage = new FlxSprite(0, 0, AssetDataUtil.CONTROLS);
		_controlsImage.scrollFactor.set(0, 0);
		
		add(_controlsImage);
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
		
		if (FlxG.keys.justPressed.ENTER)
			FlxG.switchState(new SpaceState());
	}
	
	private var _controlsImage : FlxSprite;
}