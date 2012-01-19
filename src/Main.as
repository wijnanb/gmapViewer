package 
{
	import com.google.maps.LatLng;
	import com.google.maps.Map3D;
	import com.google.maps.MapEvent;
	import com.google.maps.MapOptions;
	import com.google.maps.MapType;
	import com.google.maps.View;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.*;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.system.fscommand;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import gl.events.GestureEvent;
	import gl.events.TouchEvent;
	
	import id.component.DrawUser;
	import id.core.Application;
	import id.core.ApplicationGlobals;
	import id.core.TouchSprite;
	import id.module.GMapViewer;
	import id.module.YouTubeViewer;
	import id.template.MagnifierViewer;
	
	public class Main extends Application
	{
		protected var maps:Array = [];
		protected var viewer:MagnifierViewer;
		
		protected var viewerLayer:TouchSprite = new TouchSprite();
		protected var mapSwitchButtonLayer:TouchSprite = new TouchSprite();
		protected var mapLayer:TouchSprite = new TouchSprite();
		
		protected var resetTimer:Timer;

		public function Main()
		{
			settingsPath = "config/Application.xml";

			stage.scaleMode = StageScaleMode.NO_SCALE;
			if ( Player.runFullscreen )		stage.displayState = StageDisplayState.FULL_SCREEN;			
			stage.align = StageAlign.TOP_LEFT;
			
			resetTimer = new Timer(50000,0);// reset application every 50 seconds when no touches are detected, touches are detected in main.as
			resetTimer.addEventListener(TimerEvent.TIMER, onResetTimerComplete);
			resetTimer.start();		
			
			if ( Player.useSecureDomain ) {
				Security.allowDomain("*");
				Security.allowInsecureDomain("*");	
			}
			
			addChild(mapLayer);
			addChild(viewerLayer);
			addChild(mapSwitchButtonLayer);
		}

		override protected function initialize():void
		{
			stage.frameRate = ApplicationGlobals.dataManager.data.Template.FrameRate;
			addEventListener(TouchEvent.TOUCH_UP, onTouch);
			
			for ( var i:int=0; i<ApplicationGlobals.dataManager.data.Maps.Map.length(); i++ ) {
				var name:String = ApplicationGlobals.dataManager.data.Maps.Map[i].Name;
				var content:String = ApplicationGlobals.dataManager.data.Maps.Map[i].Content;

				maps.push( new MapData(name, content) );
				
				var switchButton:SwitchButton = new SwitchButton(name);
				switchButton.y = (switchButton.size + 10) * i;
				switchButton.addEventListener(TouchEvent.TOUCH_UP, function(e:TouchEvent):void {
					loadMapWithName( (e.target as SwitchButton).caption );
				} );
				mapSwitchButtonLayer.addChild(switchButton);
			}

			createGMap();
			
			var loadFirstMapTimeout:int = setTimeout( function() {
				loadMapWithName( (maps[0] as MapData).name );
			}, 50);
		}
		
		protected function loadMapWithName(name:String):void {
			if ( viewer ) {
				trace("destroy viewer");
				viewer.Dispose();
				viewer = null;
			}
			
			viewer = new MagnifierViewer();
			viewerLayer.addChild(viewer);
			
			trace(viewer);
		}
		
		protected function onTouch(e:TouchEvent):void {
			resetTimer.reset();
			resetTimer.start();
		}

		protected function onResetTimerComplete(e:TimerEvent):void
		{
			if ( Player.runFullscreen )		stage.displayState = StageDisplayState.FULL_SCREEN;
				
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			if ( viewer ) 	viewer.reset();
		}
		
		protected function createGMap():void {
			trace("createGMap()");
			
			MapData.gMap = new Map3D();
			MapData.gMap.url = "http://maddoc.khlim.be";
			MapData.gMap.key = "ABQIAAAAty-8JphdW63RQjyEH9EuFxS4OKswxGP2Jk6kerS8HZB0PQykqhRYFL8--w_-Qt50euSW6trHD4Up9A";
			MapData.gMap.setSize(new Point(1280,800));
			MapData.gMap.sensor = "false";
			MapData.gMap.addEventListener(MapEvent.MAP_PREINITIALIZE, onMapPreInt);
			MapData.gMap.addEventListener(MapEvent.MAP_READY, onMapReady);
			//gMap.addEventListener(MapEvent.MAP_READY, onMapReady);
			
			mapLayer.addChild(MapData.gMap);
		}
		
		protected function onMapPreInt(event:MapEvent=null):void
		{
			trace("onMapPreInt()");
			var lat:Number = 50.798426;
			var lng:Number = 5.348904;
			var zoom:Number = 14;
				
			var mOptions:MapOptions = new MapOptions();
			mOptions.zoom = zoom;
			mOptions.center = new LatLng(lat,lng);
			mOptions.viewMode = View.VIEWMODE_2D;
			mOptions.mapType = MapData.getZOutMapType();
			
			MapData.gMap.setInitOptions(mOptions);
		}
		
		protected function onMapReady(event:MapEvent):void {
			trace("onMapReady()");
		}
	}
}