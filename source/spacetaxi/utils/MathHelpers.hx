package spacetaxi.utils;

import flixel.math.FlxAngle;
import flixel.math.FlxPoint;

/**
 * ...
 * @author Jams
 */
class MathHelpers
{

	public function new() 
	{
	}
	
	public static inline function rotatePoint(X:Float, Y:Float, PivotX:Float, PivotY:Float, Angle:Float, ?point:FlxPoint):FlxPoint
    {
        var sin:Float = 0;
        var cos:Float = 0;
        var radians:Float = Angle * -FlxAngle.TO_RAD; // keep the minus cause sprite angle is clockwise and the mathematical rotation is counter-clockwise
        while (radians < -Math.PI)
        {
            radians += Math.PI * 2;
        }
        while (radians >  Math.PI)
        {
            radians = radians - Math.PI * 2;
        }

        if (radians < 0)
        {
            sin = 1.27323954 * radians + .405284735 * radians * radians;
            if (sin < 0)
            {
                sin = .225 * (sin *-sin - sin) + sin;
            }
            else
            {
                sin = .225 * (sin * sin - sin) + sin;
            }
        }
        else
        {
            sin = 1.27323954 * radians - 0.405284735 * radians * radians;
            if (sin < 0)
            {
                sin = .225 * (sin *-sin - sin) + sin;
            }
            else
            {
                sin = .225 * (sin * sin - sin) + sin;
            }
        }

        radians += Math.PI / 2;
        if (radians >  Math.PI)
        {
            radians = radians - Math.PI * 2;
        }
        if (radians < 0)
        {
            cos = 1.27323954 * radians + 0.405284735 * radians * radians;
            if (cos < 0)
            {
                cos = .225 * (cos *-cos - cos) + cos;
            }
            else
            {
                cos = .225 * (cos * cos - cos) + cos;
            }
        }
        else
        {
            cos = 1.27323954 * radians - 0.405284735 * radians * radians;
            if (cos < 0)
            {
                cos = .225 * (cos *-cos - cos) + cos;
            }
            else
            {
                cos = .225 * (cos * cos - cos) + cos;
            }
        }

        var dx:Float = X - PivotX;
        var dy:Float = Y - PivotY;
        if (point == null)
        {
            point = FlxPoint.get();
        }
        point.x = cos * dx - sin * dy + PivotX;
        point.y = sin * dx + cos * dy + PivotY;
        return point;
    }
	
}