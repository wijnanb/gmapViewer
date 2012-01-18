package 
{
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
		private var container:MagnifierViewer;

		public function Main()
		{
			settingsPath = "config/Application.xml";

			stage.scaleMode = StageScaleMode.NO_SCALE;
			if ( Player.runFullscreen )		stage.displayState = StageDisplayState.FULL_SCREEN;			
			stage.align = StageAlign.TOP_LEFT;
			
			var resetTimer:Timer = new Timer(50000,0);// reset application every 50 seconds when no touches are detected, touches are detected in main.as
			resetTimer.addEventListener(TimerEvent.TIMER, reset);
			resetTimer.start();		
			
			if ( Player.useSecureDomain ) {
				Security.allowDomain("*");
				Security.allowInsecureDomain("*");	
			}
		}

		override protected function initialize():void
		{
			stage.frameRate = ApplicationGlobals.dataManager.data.Template.FrameRate;
			container = new MagnifierViewer();
			addChild(container);
			addEventListener(TouchEvent.TOUCH_UP, update);
		}
		

		private function reset(e:Event)
		{
			if ( Player.runFullscreen )		stage.displayState = StageDisplayState.FULL_SCREEN;
				
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
		private function update(e:Event)
		{
			container.updater();
		}
		
		public function map(v:Number, a:Number, b:Number, x:Number = 0, y:Number = 1):Number {
    		return (v == a) ? x : (v - a) * (y - x) / (b - a) + x;
		}
	}
}