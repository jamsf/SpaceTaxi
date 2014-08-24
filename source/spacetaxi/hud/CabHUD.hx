package spacetaxi.hud;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText.FlxTextAlign;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import spacetaxi.entities.Taxi;

import spacetaxi.utils.AssetDataUtil;
import spacetaxi.hud.Radio;

/**
 * ...
 * @author Jams
 */
class CabHUD
{
	public var AlienHud(get, never):AlienHUD;
	public function get_AlienHud():AlienHUD { return _alienHUD; }
	
	public function new(gameTimer:FlxTimer, startMoney:Int) 
	{
		_gameTimer = gameTimer;
		_gameTimerText = new FlxText(FlxG.camera.x + MARGIN, FlxG.camera.y + MARGIN, 400, "TAXI TIME: ", 18);
		_gameTimerText.color = FlxColor.WHITE;
		_gameTimerText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.YELLOW, 1);
		_gameTimerText.scrollFactor.set(0, 0);
		
		_moneyText = new FlxText(FlxG.camera.x + FlxG.camera.width - 400 - MARGIN, FlxG.camera.y + MARGIN, 400, "$ 0", 18);
		_moneyText.color = 0x3c9850;
		_moneyText.alignment = FlxTextAlign.RIGHT;
		_moneyText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.YELLOW, 1);
		_moneyText.scrollFactor.set(0, 0);
		_moneyCounting = 0;
		updateMoney(0);
		
		_radioText = new FlxText(FlxG.camera.x + FlxG.camera.width - 400 - MARGIN, FlxG.camera.y + FlxG.camera.height - MARGIN - 18, 400, "Bloop FM", 18);
		_radioText.color = 0x508cb4;
		_radioText.alignment = FlxTextAlign.RIGHT;
		_radioText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.YELLOW, 1);
		_radioText.scrollFactor.set(0, 0);
		
		FlxG.state.add(_gameTimerText);
		FlxG.state.add(_moneyText);
		FlxG.state.add(_radioText);
		
		_radio = new Radio();
		_alienHUD = new AlienHUD();
	}
	
	public function updateHUD():Void
	{
		var sec : Int = Math.floor(_gameTimer.timeLeft);
		var minStr : String = Std.string(Math.floor(sec / 60));
		sec = sec % 60;
		var secStr = sec < 10 ? "0" + Std.string(sec) : Std.string(sec);
		_gameTimerText.text = "TAXI TIME " + minStr + ":" + secStr;
		
		
		if (FlxG.keys.justPressed.SPACE)
			_radioText.text = _radio.playNextTrack();
		
		if (_moneyCounting < _moneyActual-1)
		{
			_moneyCounting += 1;
			_moneyText.text = "+ $ " + Std.string(_moneyCounting);
		}
		else if (_moneyCounting < _moneyActual)
		{
			_moneyCounting += 1;
			_moneyText.text = "$ " + Std.string(_moneyCounting);
		}
	}
	
	public function stopAllMusic():Void
	{
		_radio.stopAllMusic();
	}
	
	public function updateMoney(money:Int)
	{
		_moneyActual = money;
	}
	
	private var _gameTimer:FlxTimer;
	private var _gameTimerText:FlxText;
	
	private var _moneyText:FlxText;
	private var _moneyCounting:Int;
	private var _moneyActual:Int;
	
	private var _radioText:FlxText;
	private var _radio : Radio;
	
	private var _alienHUD:AlienHUD;
	
	static var MARGIN : Float = 10;
}