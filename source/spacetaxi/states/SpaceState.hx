package spacetaxi.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

import spacetaxi.entities.Taxi;
import spacetaxi.utils.AssetDataUtil;

/**
 * ...
 * @author Jams
 */
class SpaceState extends FlxState
{
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		
		// Set space boundries
		LEVEL_MIN_X = -FlxG.width * 2;
		LEVEL_MAX_X = FlxG.width * 2;
		LEVEL_MIN_Y = -FlxG.height * 2;
		LEVEL_MAX_Y = FlxG.height * 2;
		
		// Create background
		add(new FlxSprite(LEVEL_MIN_X, LEVEL_MIN_Y, AssetDataUtil.BACKGROUND_TEST));
		
		_taxi = new Taxi(0, 0);
		add(_taxi);
		
		FlxG.camera.setScrollBounds(LEVEL_MIN_X, LEVEL_MAX_X, LEVEL_MIN_Y, LEVEL_MAX_Y);
		
		FlxG.camera.follow(_taxi);
		FlxG.camera.setPosition(0, 0);
	}
	
	private var _taxi : Taxi;
	
	// Space boundaries
	static var LEVEL_MIN_X;
	static var LEVEL_MAX_X;
	static var LEVEL_MIN_Y;
	static var LEVEL_MAX_Y;
}