package io.newgrounds.test.ui;

import io.newgrounds.test.art.MainScreenSwf;
import openfl.events.Event;
import haxe.PosInfos;
import openfl.text.TextField;
import haxe.ds.StringMap;

import openfl.display.MovieClip;

import io.newgrounds.test.ui.Button;
import io.newgrounds.test.ui.Page;
import io.newgrounds.NG;

import openfl.display.Sprite;

class MainScreen extends Sprite {
	
	static inline var CORE      :String = "core";
	static inline var APP       :String = "app";
	static inline var EVENT     :String = "event";     
	static inline var GATEWAY   :String = "gateway";
	static inline var LOADER    :String = "loader";
	static inline var MEDAL     :String = "medal";
	static inline var SCOREBOARD:String = "scoreboard";
	
	static var _pageWrappers:StringMap<Class<Dynamic>>;
	
	var _layout:MainScreenSwf;
	var _tabs:StringMap<Button>;
	var _pages:StringMap<MovieClip>;
	var _currentPage:String;
	var _output:TextField;
	
	public function new () {
		
		super ();
		
		_pageWrappers = 
		[ CORE       => CorePage
		, APP        => AppPage
		, EVENT      => EventPage
		, GATEWAY    => GatewayPage
		, LOADER     => LoaderPage
		, MEDAL      => MedalPage
		, SCOREBOARD => ScoreboardPage
		];
		
		NG.core.log = logOutput;
		
		_layout = new MainScreenSwf();
		addChild(_layout);
		_output = _layout.output;
		_output.text = "";
		
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
	}
	
	function onAdded(event:Event):Void {
		_currentPage = null;
		
		_tabs = new StringMap<Button>();
		_pages = new StringMap<MovieClip>();
		
		for (name in _pageWrappers.keys()) {
			
			_tabs.set(name, new Button(cast _layout.getChildByName(name + "Tab"), onTabClick.bind(name)));
			_pages.set(name, cast _layout.getChildByName(name));
			_pages.get(name).visible = false;
			Type.createInstance(_pageWrappers.get(name), [_pages.get(name)]);
		}
		
		onTabClick(CORE);
	}
	
	function onTabClick(name:String):Void {
		
		if (_currentPage != null) {
			
			_pages.get(_currentPage).visible = false;
			_tabs.get(_currentPage).enabled = true;
		}
		
		_tabs.get(name).enabled = false;
		_pages.get(name).visible = true;
		
		_currentPage = name;
	}
	
	function logOutput(msg:String, ?pos:PosInfos):Void {
		
		_output.appendText(msg + "\n");
	}
}