package id.module
{
	import com.google.maps.InfoWindowOptions;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.Map3D;
	import com.google.maps.MapEvent;
	import com.google.maps.MapOptions;
	import com.google.maps.MapType;
	import com.google.maps.View;
	import com.google.maps.geom.Attitude;
	import com.google.maps.overlays.GroundOverlay;
	import com.google.maps.overlays.GroundOverlayOptions;
	import com.google.maps.overlays.Marker;
	import com.google.maps.overlays.MarkerOptions;
	import com.greensock.*;
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.*;
	
	import gl.events.GestureEvent;
	import gl.events.TouchEvent;
	
	import id.component.CreateLine;
	import id.component.LaderIcoon;
	import id.component.YouTubeDisplay;
	import id.core.ApplicationGlobals;
	import id.core.TouchComponent;
	import id.element.ContentParser;
	import id.element.YouTubeDisplayParser;
	import id.element.YouTubeParser;
	import id.module.YouTubeViewer;

	public class YouTubeViewer extends TouchComponent
	{

		public var youtubeDisplay:YouTubeDisplay;
		public var myMap;
		public var myMarkerLatLng:LatLng;//new line ******
		var teller = 0;
		var nummer;
		public var testX;
		public var testY;
		public var points:Array = new Array();
		public var pointNum:int = 100;
		public var canvas:Sprite = new Sprite();
		public var tB:Boolean = false;
		public var idKlik;
		public var wegY;
		public var youtubeDisplayList:Array = new Array();

		public var line:CreateLine;
		public var lineList:Array = new Array();
		public var tx;
		public var ty;
		private var magnifier;
		private var staat;
		private var LaadIcon:LaderIcoon = new LaderIcoon();
		
		public function YouTubeViewer(id , niveau, magnifi)
		{
			super();
			YouTubeParser.addEventListener(Event.COMPLETE, onParseComplete);
			YouTubeParser.settingsPath = "FSCommand/Content.xml";
			YouTubeDisplayParser.settingsPath = "config/"+Global.environment+"/YouTubeViewer.xml";
			YouTubeParser.settingsId = id;
			YouTubeParser.settingsNiveau = niveau;
			staat = niveau;
			//trace("id: ", niveau);
			nummer = id;
			magnifier = magnifi;
		}
		

/*		public function wireStation()
		{
			for (var i = 0; i< youtubeDisplayList.length; i++)
			{
				youtubeDisplayList[i].myMap = myMap;
				youtubeDisplayList[i].myMarkerLatLng = myMarkerLatLng;
				lineList[i].updateLine(youtubeDisplayList[i].x, youtubeDisplayList[i].y, myMap, myMarkerLatLng,  tx,  ty);
			}

		}*/
		
		
	/*	private function dispose(e:Event):void
		{
			//removeChild(lineList[e.target.name]);
			removeEventListener(TouchEvent.TOUCH_DOWN,touchMoveHandler);
			removeEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
			removeEventListener(GestureEvent.GESTURE_FLICK,flick);
			removeEventListener("deleteVideo",dispose);
			dispatchEvent(new Event("videoVrij"));
		}
*/
		public function verwijder(){
			for (var i = 0; i< youtubeDisplayList.length;i++){
				youtubeDisplayList[i].Dispose();
				
				}
			
			}
		public function onParseComplete(event:Event):void
		{
			YouTubeParser.removeEventListener(Event.COMPLETE, onParseComplete);
			
			//addChild(LaadIcon);
			//LaadIcon.progresser(true , -1060, -440);
			
			for (var ti = 0; ti < YouTubeParser.dataSet.length; ti++)
			{
				youtubeDisplay = new YouTubeDisplay(magnifier, staat, nummer);

				//trace('nummer', YouTubeParser.dataSet[ti]);
				/*youtubeDisplay.x = Math.random() *50; //positie individueel filmpje
				youtubeDisplay.y = Math.random() *50;*/
				youtubeDisplay.id = ti;
				youtubeDisplay.name = ti;
				youtubeDisplayList[ti] = youtubeDisplay;

				addChild(youtubeDisplayList[ti]);
				//new lines ****
				//youtubeDisplayList[ti].addEventListener(GestureEvent.GESTURE_FLICK,flick);
				//youtubeDisplayList[ti].addEventListener("deleteVideo", dispose);
				youtubeDisplayList[ti].alpha = 0;
				youtubeDisplayList[ti].scaleX = 0;
				youtubeDisplayList[ti].scaleY = 0;
					//TweenLite.to(youtubeDisplayList[ti],1,{alpha: 1});
					TweenMax.to(youtubeDisplayList[ti], 1.5, {alpha: 1, scaleX:1, scaleY:1, shortRotation:{rotation:Math.floor(Math.random() * (1+25-(-25))) + (-25)}});
				//trace("weg ", youtubeDisplay.x);
/*				var point1 = myMap.fromLatLngToViewport(myMarkerLatLng);
				//trace('point.x ', point1.x);
				tx = point1.x;
				ty = point1.y;*/

			/*	line = new CreateLine  ;
				lineList[ti] = line;
				addChild(lineList[ti]);*/


				//*****
				//wireStation();
				//dispatchEvent(new Event(Event.COMPLETE));
				tB = true;
			}
			YouTubeParser.dataSet = [];
			//removeChild(LaadIcon);
		}
	}

}