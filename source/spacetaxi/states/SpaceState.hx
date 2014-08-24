package spacetaxi.states;

import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxCollision;
import flixel.addons.nape.FlxNapeState;
import flixel.util.FlxTimer;
import flixel.math.FlxRandom;

import spacetaxi.entities.Planet;
import spacetaxi.hud.CabHUD;

import spacetaxi.entities.Taxi;
import spacetaxi.utils.AssetDataUtil;

/**
 * ...
 * @author Jams
 */
class SpaceState extends FlxNapeState
{
	public function new() 
	{
		super();
		
		FlxG.mouse.visible = false;
	}
	
	override public function create():Void 
	{
		super.create();
		
		// Set space boundries
		LEVEL_MIN_X = 0;
		LEVEL_MAX_X = FlxG.width * 8;
		LEVEL_MIN_Y = 0;
		LEVEL_MAX_Y = FlxG.height * 8;
		
		// Create background
		add(new FlxSprite(0, 0, AssetDataUtil.BACKGROUND_TEST));
		add(new FlxSprite(LEVEL_MAX_X * 0.5, 0, AssetDataUtil.BACKGROUND_TEST));
		add(new FlxSprite(0, LEVEL_MAX_Y * 0.5, AssetDataUtil.BACKGROUND_TEST));
		add(new FlxSprite(LEVEL_MAX_X * 0.5, LEVEL_MAX_Y * 0.5, AssetDataUtil.BACKGROUND_TEST));
		createWalls(LEVEL_MIN_X+10, LEVEL_MIN_Y+10, LEVEL_MAX_X-10, LEVEL_MAX_Y-10, 20);
		
		// Add Smaller Entites
		_taxi = new Taxi(LEVEL_MAX_X * 0.5, LEVEL_MAX_Y * 0.5);
		_testColl = new FlxNapeSprite(LEVEL_MAX_X * 0.5 + 300, LEVEL_MAX_Y * 0.5 + 300, AssetDataUtil.TAXI_OCC, true, true);
		add(_taxi);
		add(_testColl);
		
		_gameTimer = new FlxTimer(60 * 4, gameOver);
		
		// Add Planets
		_planets = new Array<Planet>();
		_planets.push(new Planet(300, 300, 150, AssetDataUtil.PLANET150_1, 0));
		_planets.push(new Planet(1250, 500, 150, AssetDataUtil.PLANET150_2, 1));
		_planets.push(new Planet(500, 1750, 150, AssetDataUtil.PLANET150_3, 2));
		_planets.push(new Planet(3450, 2000, 150, AssetDataUtil.PLANET150_4, 3));
		_planets.push(new Planet(4500, 750, 150, AssetDataUtil.PLANET150_5, 4));
		_planets.push(new Planet(2500, 3500, 150, AssetDataUtil.PLANET150_6, 5));
		
		_planets.push(new Planet(500, 750, 300, AssetDataUtil.PLANET300_1, 6));
		_planets.push(new Planet(1250, 4850, 300, AssetDataUtil.PLANET300_2, 7));
		_planets.push(new Planet(1200, 1200, 300, AssetDataUtil.PLANET300_3, 8));
		_planets.push(new Planet(4500, 2000, 300, AssetDataUtil.PLANET300_4, 9));
		_planets.push(new Planet(2500, 2750, 300, AssetDataUtil.PLANET300_5, 10));
		_planets.push(new Planet(3250, 3500, 300, AssetDataUtil.PLANET300_6, 11));
		
		for (planet in _planets)
		{
			add(planet);
		}
		
		FlxG.camera.setScrollBounds(LEVEL_MIN_X, LEVEL_MAX_X, LEVEL_MIN_Y, LEVEL_MAX_Y);
		createWalls(LEVEL_MIN_X, LEVEL_MAX_X, LEVEL_MIN_Y, LEVEL_MAX_Y);
		
		_cabHud = new CabHUD(_gameTimer, 0);
		
		FlxG.camera.follow(_taxi);
		FlxG.camera.setPosition(0, 0);
	}
	
	override public function update():Void 
	{
		super.update();
		
		_cabHud.updateHUD();
		
		if (!_occupiedTaxi)
		{
			// Only check pickup if taxi is going slow
			if (_taxi.body.velocity.x < 0.5 && _taxi.body.velocity.y < 0.5)
			{
				for (planet in _planets)
				{
					if (planet.Status == PlanetStatus.NEEDRIDE)
					{
						if (FlxCollision.pixelPerfectCheck(_taxi, planet.LandingZone, -10))
						{
							initializeRide(planet);
							_cabHud.AlienHud.newAlien(Planet.GetPlanetDirection(_destinationPlanet.PlanetId));
							break;
						}
					}
				}
			} 
		}
		else
		{
			// Only check pickup if taxi is going slow
			if (_taxi.body.velocity.x < 0.5 && _taxi.body.velocity.y < 0.5)
			{
				if (FlxCollision.pixelPerfectCheck(_taxi, _destinationPlanet.LandingZone, -10))
				{
					endRide();
				}
			}
		}
		
		if (FlxG.collide(_taxi, _testColl))
			trace("COLLISION!");
	}
	
	public function ridesAvailable():Void
	{
		for (planet in _planets)
		{
			planet.setStatus(PlanetStatus.NEEDRIDE);
		}
		
		// Make sure we're not immediately on an available planet
		if (_destinationPlanet != null)
		{
			_destinationPlanet.setStatus(PlanetStatus.UNAVAILABLE);
			_destinationPlanet = null;
		}
	}
	
	public function ridesUnavailable():Void
	{
		for (planet in _planets)
		{
			planet.setStatus(PlanetStatus.UNAVAILABLE);
		}
	}
	
	public function initializeRide(departPlanet:Planet):Void
	{
		_occupiedTaxi = true;
		ridesUnavailable();
		
		// Get random planet that's not departing planet
		var rand : FlxRandom = new FlxRandom();
		var destId : Int = rand.int(0, _planets.length - 1);
		while (destId == departPlanet.PlanetId)
		{
			destId = rand.int(0, _planets.length - 1);
		}
		
		_destinationPlanet = _planets[destId];
		_destinationPlanet.setStatus(PlanetStatus.DESTINATION);
	}
	
	public function endRide():Void
	{
		_occupiedTaxi = false;
		ridesAvailable();
		_money += 200;
		_cabHud.updateMoney(_money);
		_cabHud.AlienHud.endAlien();
	}
	
	private function gameOver(timer:FlxTimer):Void
	{
		// Game Ends here
	}
	
	private var _taxi : Taxi;
	private var _testColl : FlxNapeSprite;
	
	private var _rideTimer : FlxTimer;
	private var _gameTimer : FlxTimer;
	private var _money : Int;
	
	private var _cabHud : CabHUD;
	
	private var _planets : Array<Planet>;
	
	private var _occupiedTaxi : Bool;
	private var _destinationPlanet : Planet;
	
	
	// Space boundaries
	static var LEVEL_MIN_X;
	static var LEVEL_MAX_X;
	static var LEVEL_MIN_Y;
	static var LEVEL_MAX_Y;
}