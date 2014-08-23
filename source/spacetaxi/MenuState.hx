package spacetaxi;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import spacetaxi.states.SpaceState;

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
		
		_titleText = new FlxText(0, 0, 500); // x, y, width
		_titleText.text = "Space Taxi";
		_titleText.size = 20;
		_titleText.color = FlxColor.YELLOW;
		_titleText.alignment = "center";
		_titleText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.RED, 1);
		
		add(_titleText);
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
		
		if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)
			FlxG.switchState(new SpaceState());
	}
	
	private var _titleText : FlxText;
}