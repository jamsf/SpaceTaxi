package spacetaxi.states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextAlign;
import flixel.util.FlxTimer;
import spacetaxi.MenuState;

/**
 * ...
 * @author Jams
 */
class Results extends FlxState
{

	public function new(money:Int, rideCount:Int) 
	{
		super();
		_money = money;
		_rideCount = rideCount;
	}
	
	override public function create():Void 
	{
		super.create();
		
		FlxG.camera.setPosition(0, 0);
		FlxG.sound.pause();
		
		_finishShowingResults = false;
		
		_resultsTitle = new FlxText(FlxG.camera.x + (FlxG.camera.width*0.5) - 200, FlxG.camera.y + (FlxG.camera.height * 0.10), 400, "RESULTS", 48);
		_resultsTitle.color = FlxColor.WHITE;
		_resultsTitle.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.YELLOW, 1);
		
		_rideText = new FlxText(FlxG.camera.x + (FlxG.camera.width*0.5) - 200, FlxG.camera.y + (FlxG.camera.height * 0.5) - 50, 400, "Rides Given: " + Std.string(_rideCount), 24);
		_rideText.alignment = FlxTextAlign.CENTER;
		_rideText.color = FlxColor.WHITE;
		_rideText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.YELLOW, 1);
		_rideText.alpha = 0;
		
		_moneyText = new FlxText(FlxG.camera.x + (FlxG.camera.width*0.5) - 200, FlxG.camera.y + (FlxG.camera.height * 0.5) + 10, 400, "Money Earned: $" + Std.string(_money), 24);
		_moneyText.alignment = FlxTextAlign.CENTER;
		_moneyText.color = 0x3c9850;
		_moneyText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.YELLOW, 1);
		_moneyText.alpha = 0;
		
		var grade : String = "F";
		if (_money > 2000)
			grade = "S";
		else if (_money > 1500)
			grade = "A";
		else if (_money > 1000)
			grade = "B";
		else if (_money > 750)
			grade = "C";
		else if (_money > 200)
			grade = "D";
		
		_gradeText = new FlxText(FlxG.camera.x + (FlxG.camera.width*0.5) - 200, FlxG.camera.y + (FlxG.camera.height * 0.75), 400, "GRADE: " + grade, 48);
		_gradeText.color = 0x508cb4;
		_gradeText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.YELLOW, 1);
		_gradeText.alpha = 0;
		
		_continueText = new FlxText(FlxG.camera.x + (FlxG.camera.width*0.5) - 100, FlxG.camera.y + FlxG.camera.height - 20, 400, "Press ENTER to Continue", 12);
		_continueText.color = FlxColor.WHITE;
		_continueText.alignment = FlxTextAlign.CENTER;
		_continueText.alpha = 0;
		
		add(_resultsTitle);
		add(_rideText);
		add(_moneyText);
		add(_gradeText);
		add(_continueText);
		
		new FlxTimer(1.0, showRides);
	}
	
	private function showRides(timer:FlxTimer):Void
	{
		FlxG.sound.play("succeed");
		_rideText.alpha = 1;
		new FlxTimer(1.0, showMoney);
	}
	
	private function showMoney(timer:FlxTimer):Void
	{
		FlxG.sound.play("succeed");
		_moneyText.alpha = 1;
		new FlxTimer(1.0, showGrade);
	}
	
	private function showGrade(timer:FlxTimer):Void
	{
		FlxG.sound.play("succeed");
		_gradeText.alpha = 1;
		new FlxTimer(1.0, showContinue);
	}
	
	private function showContinue(timer:FlxTimer):Void
	{
		_continueText.alpha = 1;
		_finishShowingResults = true;
	}
	
	
	override public function update():Void 
	{
		super.update();
		
		if (_finishShowingResults && (FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER))
			FlxG.switchState(new MenuState());
	}
	
	private var _finishShowingResults:Bool;
	private var _resultsTitle:FlxText;
	private var _rideText:FlxText;
	private var _moneyText:FlxText;
	private var _gradeText:FlxText;
	private var _continueText:FlxText;
	
	private var _money : Int;
	private var _rideCount : Int;
}