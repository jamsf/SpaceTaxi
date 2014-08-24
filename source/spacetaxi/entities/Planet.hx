package spacetaxi.entities;

import flixel.FlxG;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import lime.utils.IDataInput;

import spacetaxi.utils.AssetDataUtil;

enum PlanetStatus
{
	NEEDRIDE;
	UNAVAILABLE;
	DESTINATION;
}

/**
 * ...
 * @author Jams
 */
class Planet extends FlxNapeSprite
{
	public var LandingZone(get, never):FlxSprite;
	public function get_LandingZone():FlxSprite { return _needRideAura; }
	
	public var Status(get, never):PlanetStatus;
	public function get_Status():PlanetStatus { return _status; }
	
	public var PlanetId(get, never):Int;
	public function get_PlanetId():Int { return _id; }
	
	public function new(X:Float = 0, Y:Float = 0, size:Int, graphic:String, id:Int) 
	{
		super(X, Y);
		loadGraphic(graphic, false, size, size);
		createCircularBody(size * 0.5);
		antialiasing = true;
		body.allowMovement = false;
		
		if (size == 150)
		{
			_needRideAura = new FlxSprite(X - 50 - (size * 0.5), Y - 50 - (size * 0.5), AssetDataUtil.LANDINGZONE150);
			_boundingStatus = new FlxSprite(X - (75 * 0.5), Y - 150, AssetDataUtil.STATUS_NEEDRIDE);
		}
		if (size == 300)
		{
			_needRideAura = new FlxSprite(X - 50 - (size * 0.5), Y - 50 - (size * 0.5), AssetDataUtil.LANDINGZONE300);
			_boundingStatus = new FlxSprite(X - (75 * 0.5), Y - 250, AssetDataUtil.STATUS_NEEDRIDE);
			_boundingStatus.scale.set(2, 2);
		}
		_needRideAura.angularVelocity = 10;
		
		FlxTween.linearMotion(_boundingStatus, _boundingStatus.x, _boundingStatus.y, _boundingStatus.x, _boundingStatus.y - 50, 1.0, true, { ease:FlxEase.quartOut } );
		
		FlxG.state.add(_needRideAura);
		FlxG.state.add(_boundingStatus);
			
		_id = id;
		_status = NEEDRIDE;
	}
	
	public function setStatus(status:PlanetStatus):Void
	{
		_status = status;
		switch(status)
		{
		case NEEDRIDE:
			_needRideAura.color = 0xececec;
			_boundingStatus.loadGraphic(AssetDataUtil.STATUS_NEEDRIDE);
		case UNAVAILABLE:
			_needRideAura.color = 0x700014;
			_boundingStatus.loadGraphic(AssetDataUtil.STATUS_UNAVAILABLE);
		case DESTINATION:
			_needRideAura.color = 0x508cb4;
			_boundingStatus.loadGraphic(AssetDataUtil.STATUS_DESTINATION);
		}
	}
	
	private var _id : Int;
	private var _needRideAura : FlxSprite;
	private var _boundingStatus : FlxSprite;
	private var _status : PlanetStatus;
	
	public static function GetPlanetDirection(id:Int):String
	{
		switch(id)
		{
			case 0:
				return "Please take me to Planet Hot 'n Sandy.";
			case 1:
				return "Take me to the Red Hot Planet.";
			case 2:
				return "I need to get to Planet Toxic - quick!";
			case 3:
				return "I gotta get to a hot date on the Love Planet.";
			case 4:
				return "Can you get me to Tiny Gray Planet?";
			case 5:
				return "Party on Little Lavendar! Get me there on time.";
			case 6:
				return "I have a meeting on the Big Dumb Rock Planet.";
			case 7:
				return "Bring me to Dark Blue Rock Planet.";
			case 8:
				return "Planet Mustard. Now. NOW!";
			case 9:
				return "I have business to attend to on Magic Purple Planet.";
			case 10:
				return "Planet Mold awaits me.";
			case 11:
				return "Get me to Light Blue Rock Planet.";
		}
		return "Just take me to some fucking planet.";
	}
}