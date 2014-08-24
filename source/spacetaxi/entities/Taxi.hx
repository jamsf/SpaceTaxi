package spacetaxi.entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxVelocity;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.addons.nape.FlxNapeSprite;
import nape.geom.Vec2;

import spacetaxi.utils.AssetDataUtil;
import spacetaxi.utils.MathHelpers;

/**
 * ...
 * @author Jams
 */
class Taxi extends FlxNapeSprite
{

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetDataUtil.TAXI_VAC, false, 50, 28);
		
		// Taxi Physics
		drag.set(200, 200);
		maxVelocity.set(MAX_VELOCITY, MAX_VELOCITY);
		createRectangularBody(width, height);
		antialiasing = true;
		setBodyMaterial(0.5, 0.5, 4, 2);
		setDrag(0.98, 1);
		
		occupied = false;
	}
	
	override public function update():Void 
	{
		super.update();
		updateMovement();
	}
	
	public function pickupRide():Void
	{
		occupied = true;
	}
	
	private function updateMovement():Void
	{	
		// Resolve rotation
		if (body.rotation > Math.PI)
			body.rotation = -Math.PI + (body.rotation - Math.PI);
		else if (body.rotation < -Math.PI)
			body.rotation = Math.PI - (body.rotation+Math.PI);
		
		body.angularVel += body.angularVel > 0 ? -0.05 : 0.05;
			
		if (FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT)
		{
			body.angularVel += 0.1;
		}
		if (FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT)
		{
			body.angularVel -= 0.1;
		}
		
		if (FlxG.keys.pressed.W || FlxG.keys.pressed.UP)
		{
			body.applyImpulse(new Vec2(Math.cos(body.rotation)*20, Math.sin(body.rotation)*20));
		}
		if (FlxG.keys.pressed.S || FlxG.keys.pressed.DOWN)
		{
			body.applyImpulse(new Vec2(Math.cos(body.rotation + Math.PI)*20, Math.sin(body.rotation + Math.PI)*20));
		}
	}
	
	private var occupied : Bool;
	
	// Space boundaries
	static var MAX_VELOCITY : Float = 400;
	static var MAX_RAD : Float = 2 * Math.PI;
}