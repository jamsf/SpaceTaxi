package spacetaxi.entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxVelocity;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;

import spacetaxi.utils.AssetDataUtil;
import spacetaxi.utils.MathHelpers;

/**
 * ...
 * @author Jams
 */
class Taxi extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetDataUtil.TAXI, false, 64, 32);
		drag.set(100, 100);
	}
	
	override public function update():Void 
	{
		super.update();
		updateMovement();
	}
	
	private function updateMovement():Void
	{
		angularVelocity = 0;
		
		if (FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT)
		{
			angularVelocity += 240;
		}
		if (FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT)
		{
			angularVelocity -= 240;
		}
		angle = FlxAngle.wrapAngle(angle);
		
		acceleration.set();
		
		if (FlxG.keys.pressed.W || FlxG.keys.pressed.UP)
		{
			var convertedAngle : Float = angle < 0 ? -angle : 360 - angle;
			convertedAngle = convertedAngle % 360;
			MathHelpers.rotatePoint(200, 0, 0, 0, convertedAngle, acceleration);
		}
		if (FlxG.keys.pressed.S || FlxG.keys.pressed.DOWN)
		{
			var convertedAngle : Float = angle < 0 ? -angle : 360-angle;
			convertedAngle = (angle + 180) % 360;
			MathHelpers.rotatePoint(200, 0, 0, 0, convertedAngle, acceleration);
		}
	}
}