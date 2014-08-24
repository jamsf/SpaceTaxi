package spacetaxi.hud;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;

import spacetaxi.entities.Taxi;

/**
 * ...
 * @author Jams
 */
class TaxiUpdateHUD extends FlxText
{

	public function new(taxi:Taxi) 
	{
		super(0, 0, 0, "", 12, true);
		
		color = 0xFFFFFF;
		_taxiTimer = null;
		_taxi = taxi;
	}
	
	override public function update():Void 
	{
		x = _taxi.x;
		y = _taxi.y - 50;
		
		if (_inRide)
		{
			var sec : Int = Math.floor(_taxiTimer.timeLeft);
			var minStr : String = Std.string(Math.floor(sec / 60));
			sec = sec % 60;
			var secStr = sec < 10 ? "0" + Std.string(sec) : Std.string(sec);
			text = minStr + ":" + secStr;
		}
		
		super.update();
	}
	
	public function setRideTimer(timer:FlxTimer):Void
	{
		_taxiTimer = timer;
		_inRide = true;
		color = FlxColor.WHITE;
	}
	
	public function endRideTimer():Void
	{
		_inRide = false;
		_taxiTimer = null;
		text = "";
	}
	
	public function setText(str:String, duration:Float, textcolor:FlxColor=FlxColor.WHITE):Void
	{
		if (_durationTimer == null || !_durationTimer.active)
		{
			text = str;
			_durationTimer = new FlxTimer(duration, endSetText);
			color = textcolor;
		}
	}
	
	private function endSetText(timer:FlxTimer):Void
	{
		text = "";
	}
	
	private var _taxi:Taxi;
	private var _inRide:Bool;
	private var _durationTimer:FlxTimer;
	private var _taxiTimer:FlxTimer;
}