package spacetaxi.entities;

import flixel.addons.nape.FlxNapeSprite;
import flixel.math.FlxRandom;
import nape.geom.Vec2;

import spacetaxi.utils.AssetDataUtil;

/**
 * ...
 * @author Jams
 */
class Asteroid extends FlxNapeSprite
{
	public function new(X:Float, Y:Float) 
	{
		super(X, Y, AssetDataUtil.ASTEROID);
		createCircularBody(64 * 0.5);
		maxVelocity.set(200, 200);
		antialiasing = true;
		setBodyMaterial(0.5, 0.5, 4, 2);
		
		// Set Random Direction to go
		var randRad : Float = new FlxRandom().float( -Math.PI, Math.PI);
		body.applyImpulse(new Vec2(Math.cos(randRad)*8000, Math.sin(randRad)*8000));
	}
}