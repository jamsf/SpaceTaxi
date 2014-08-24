package spacetaxi.hud;

import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Jams
 */
class Radio
{
	public function new() 
	{
		_fancyTrackNames = ["Bloop FM", "Earth Classics"];
		_trackNames = ["bloopfm", "earthclassics"];
		_tracks = new Array<FlxSound>();
		
		for (trackName in _trackNames)
		{
			var track = new FlxSound();
			track.loadEmbedded(trackName, true);
			track.volume = 1;
			track.persist = true;
 			_tracks.push(track);
		}
		_currentTrack = 0;
		_tracks[_currentTrack].startSound(0);
		_trackChangeWait = false;
	}
	
	public function playNextTrack():String
	{
		if (!_trackChangeWait)
		{
			_tracks[_currentTrack].pause();
			var duration : Float = _tracks[_currentTrack].time;
			_currentTrack = _currentTrack >= _trackNames.length - 1 ? 0 : _currentTrack + 1;
			_tracks[_currentTrack].startSound(duration);
			_trackChangeWait = true;
			_trackChangeTimeout = new FlxTimer(1, trackChangeTimeout);
		}
		return _fancyTrackNames[_currentTrack];
	}
	
	private function trackChangeTimeout(timer:FlxTimer):Void
	{
		_trackChangeWait = false;
	}
	
	private var _trackChangeWait:Bool;
	private var _trackChangeTimeout:FlxTimer;
	private var _currentTrack:Int;
	private var _trackNames : Array<String>;
	private var _fancyTrackNames : Array<String>;
	private var _tracks : Array<FlxSound>;
}