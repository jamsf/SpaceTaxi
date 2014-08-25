package spacetaxi.states;

import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxCollision;
import flixel.addons.nape.FlxNapeState;
import flixel.util.FlxTimer;
import flixel.math.FlxRandom;
import spacetaxi.entities.Asteroid;
import spacetaxi.hud.TaxiUpdateHUD;

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
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		// Set space boundries
		LEVEL_MIN_X = 0;
		LEVEL_MAX_X = FlxG.width * 8;
		LEVEL_MIN_Y = 0;
		LEVEL_MAX_Y = FlxG.height * 8;
		
		_money = 0;
		_rideCount = 0;
		
		// Create background
		add(new FlxSprite(0, 0, AssetDataUtil.BACKGROUND_TEST));
		add(new FlxSprite(LEVEL_MAX_X * 0.5, 0, AssetDataUtil.BACKGROUND_TEST));
		add(new FlxSprite(0, LEVEL_MAX_Y * 0.5, AssetDataUtil.BACKGROUND_TEST));
		add(new FlxSprite(LEVEL_MAX_X * 0.5, LEVEL_MAX_Y * 0.5, AssetDataUtil.BACKGROUND_TEST));
		createWalls(LEVEL_MIN_X+10, LEVEL_MIN_Y+10, LEVEL_MAX_X-10, LEVEL_MAX_Y-10, 20);
		
		// Add Smaller Entites
		_taxi = new Taxi(LEVEL_MAX_X * 0.5, LEVEL_MAX_Y * 0.5);
		add(_taxi);
		
		_gameTimer = new FlxTimer(60*8, gameOver);
		
		// Add Planets
		_planets = new Array<Planet>();
		_planets.push(new Planet(2052, 1404, 150, AssetDataUtil.PLANET150_1, 0));
		_planets.push(new Planet(2835, 404, 150, AssetDataUtil.PLANET150_2, 1));
		_planets.push(new Planet(1180, 2525, 150, AssetDataUtil.PLANET150_3, 2));
		_planets.push(new Planet(3412, 2716, 150, AssetDataUtil.PLANET150_4, 3));
		_planets.push(new Planet(591, 457, 150, AssetDataUtil.PLANET150_5, 4));
		_planets.push(new Planet(4581, 1700, 150, AssetDataUtil.PLANET150_6, 5));

		_planets.push(new Planet(4585, 3319, 300, AssetDataUtil.PLANET300_1, 6));
		_planets.push(new Planet(4215, 470, 300, AssetDataUtil.PLANET300_2, 7));
		_planets.push(new Planet(533, 3318, 300, AssetDataUtil.PLANET300_3, 8));
		_planets.push(new Planet(807, 1488, 300, AssetDataUtil.PLANET300_4, 9));
		_planets.push(new Planet(3397, 1241, 300, AssetDataUtil.PLANET300_5, 10));
		_planets.push(new Planet(2228, 3065, 300, AssetDataUtil.PLANET300_6, 11));
		
		// Add Asteroids
		_asteroids = new FlxGroup();
		_asteroids.add(new Asteroid(1240, 400));
		_asteroids.add(new Asteroid(400, 890));
		_asteroids.add(new Asteroid(450, 2257));
		_asteroids.add(new Asteroid(1200, 3300));
		_asteroids.add(new Asteroid(3113, 3385));
		_asteroids.add(new Asteroid(4329, 2652));
		_asteroids.add(new Asteroid(3769, 1609));
		_asteroids.add(new Asteroid(4761, 710));
		_asteroids.add(new Asteroid(2800, 900));
		_asteroids.add(new Asteroid(4697, 200));
		_asteroids.add(new Asteroid(1937, 2449));
		_asteroids.add(new Asteroid(2737, 800));
		add(_asteroids);
		
		for (planet in _planets)
		{
			add(planet);
		}
		
		FlxG.camera.setScrollBounds(LEVEL_MIN_X, LEVEL_MAX_X, LEVEL_MIN_Y, LEVEL_MAX_Y);
		createWalls(LEVEL_MIN_X, LEVEL_MAX_X, LEVEL_MIN_Y, LEVEL_MAX_Y);
		
		_cabHud = new CabHUD(_gameTimer, 0);
		_taxiUpdateHud = new TaxiUpdateHUD(_taxi);
		_taxiUpdateHud.setText("Let's do it!", 2.0);
		add(_taxiUpdateHud);
		
		_map = new FlxSprite(FlxG.camera.x, FlxG.camera.y, AssetDataUtil.MAP);
		_map.scrollFactor.set(0, 0);
		_map.alpha = 0;
		add(_map);
		
		FlxG.camera.follow(_taxi);
		FlxG.camera.setPosition(0, 0);
	}
	
	override public function update():Void 
	{
		super.update();
		
		_cabHud.updateHUD();
		
		if (!_occupiedTaxi)
		{
			for (planet in _planets)
			{
				if (planet.Status == PlanetStatus.NEEDRIDE)
				{
					if (FlxCollision.pixelPerfectCheck(_taxi, planet.LandingZone, -10))
					{
						// Only check pickup if taxi is going slow
						if (Math.abs(_taxi.body.velocity.x) < 80 && Math.abs(_taxi.body.velocity.y) < 80)
						{
							FlxG.sound.play("entercar", 1, false);
							initializeRide(planet);
							_cabHud.AlienHud.newAlien(Planet.GetPlanetDirection(_destinationPlanet.PlanetId));
							break;
						}
						else
						{
							_taxiUpdateHud.setText("SLOW DOWN", 2.0);
						}
					}
				}
			}
		}
		else
		{
			// Only check pickup if taxi is going slow
			if (Math.abs(_taxi.body.velocity.x) < 80 && Math.abs(_taxi.body.velocity.y) < 80)
			{
				if (FlxCollision.pixelPerfectCheck(_taxi, _destinationPlanet.LandingZone))
				{
					endRide(true);
					_rideTimer.cancel();
					_rideTimer.destroy();
					_rideTimer = null;
				}
			}
		}
		
		if (_occupiedTaxi)
		{
			for (asteroid in _asteroids)
			{
				if (FlxCollision.pixelPerfectCheck(_taxi, cast(asteroid, Asteroid)))
					_cabHud.AlienHud.alienAngryAtAsteroid();
			}
		}
		
		// Toggle Map
		if (FlxG.keys.justPressed.M)
			_map.alpha = _map.alpha == 0 ? 0.75 : 0;
	}
	
	public function lateRideCallback(timer:FlxTimer):Void
	{
		endRide(false);
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
		_rideTimer = new FlxTimer(Math.min(45, _gameTimer.timeLeft), lateRideCallback);
		_taxiUpdateHud.setRideTimer(_rideTimer);
	}
	
	public function endRide(success:Bool):Void
	{
		_occupiedTaxi = false;
		_taxiUpdateHud.endRideTimer();
		ridesAvailable();
		if (success)
		{
			FlxG.sound.play("succeed", 1, false);
			_taxiUpdateHud.setText("SUCCESS!", 2.0, 0x74903c);
			_money += 200;
			_rideCount += 1;
			_cabHud.updateMoney(_money);
		}
		else
		{
			FlxG.sound.play("fail", 1, false);
			_taxiUpdateHud.setText("TOO LATE!", 2.0, 0x700014);
		}
		_cabHud.AlienHud.endAlien(success);
	}
	
	private function gameOver(timer:FlxTimer):Void
	{
		FlxG.sound.play("timesup");
		var gameOverText : FlxText = new FlxText(FlxG.camera.x + FlxG.camera.width * 0.5 - 250, FlxG.camera.y + FlxG.camera.height * 0.5 - 100, 400, "TIME'S UP!", 48);
		gameOverText.color = 0x3c9850;
		gameOverText.alignment = FlxTextAlign.CENTER;
		gameOverText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.YELLOW, 1);
		gameOverText.scrollFactor.set(0, 0);
		add(gameOverText);
		new FlxTimer(3.0, switchToResultsScreen);
	}
	
	private function switchToResultsScreen(timer:FlxTimer):Void
	{
		FlxG.switchState(new Results(_money, _rideCount));
		_cabHud.stopAllMusic();
	}
	
	private var _taxi : Taxi;
	private var _map : FlxSprite;
	
	private var _rideTimer : FlxTimer;
	private var _gameTimer : FlxTimer;
	private var _money : Int;
	private var _rideCount : Int;
	
	private var _cabHud : CabHUD;
	private var _taxiUpdateHud : TaxiUpdateHUD;
	
	private var _planets : Array<Planet>;
	private var _asteroids : FlxGroup;
	
	private var _occupiedTaxi : Bool;
	private var _destinationPlanet : Planet;
	
	// Space boundaries
	static var LEVEL_MIN_X;
	static var LEVEL_MAX_X;
	static var LEVEL_MIN_Y;
	static var LEVEL_MAX_Y;
}