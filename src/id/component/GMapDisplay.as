package id.component
{
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.geom.*;
	import flash.ui.Mouse;
	import id.core.ApplicationGlobals;
	import id.core.TouchSprite;
	import gl.events.TouchEvent;
	import gl.events.GestureEvent;
	import id.core.TouchComponent;
	import id.element.MapParser;
	import id.module.YouTubeViewer;
	import flash.display.LineScaleMode;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Shape;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.net.URLLoader;
	import flash.net.URLRequest;


	import com.google.maps.LatLng;
	import com.google.maps.Map3D;
	import com.google.maps.MapEvent;
	import com.google.maps.MapOptions;
	import com.google.maps.MapType;
	import com.google.maps.View;
	import com.google.maps.geom.Attitude;
	import com.google.maps.overlays.Marker;
	import com.greensock.TweenLite;

	import com.google.maps.controls.MapTypeControl;
	import com.google.maps.StyledMapType;
	import com.google.maps.StyledMapTypeOptions;
	import com.google.maps.styles.MapTypeStyleElementType;
	import com.google.maps.styles.MapTypeStyleFeatureType;
	import com.google.maps.styles.MapTypeStyleRule;
	import com.google.maps.styles.MapTypeStyle;

	import com.google.maps.MapMouseEvent;
	import com.google.maps.InfoWindowOptions;

	import com.google.maps.MapTypeOptions;
	import com.google.maps.interfaces.IMapType;
	import com.google.maps.controls.ZoomControl;
	import com.google.maps.controls.MapTypeControl;
	import com.google.maps.controls.ControlPosition;
	import com.google.maps.services.*;
	





	/**
	 * <p>The GMapDisplay component is the main component for the GMapViewer module.  It contains all the neccessary display objects for the module.</p>
	 *
	 * <p>
	 * The GMapViewer is a module that uses the Google Maps API to create interactive mapping window.  
	 * Multiple touch object windows can independently display maps with different sizes and orientations.  
	 * Each map can have be centered on different coordinates, use different types and views.
	 * The map windows can be interactively moved around stage, scaled and rotated using multitouch gestures additionally map type, latitude and longitude, zoom level, attitude and pitch can also be controls using multitouch gesture inside the mapping window.
	 * All multitouch gestures can be activated and deactivated using the module XML settings.</p>
	 *
	 * <strong>Import Components :</strong>
	 * <pre>
	 * Map3D
	 * MapParser
	 * TouchGesturePhysics
	 * </pre>
	 *
	 * <listing version="3.0">
	 * var mapDisplay:GMapDisplay = new GMapDisplay();
	 *
	 * mapDisplay.id = Number;
	 *
	 * addChild(mapDisplay);</listing>
	 *
	 * @see id.module.GMapViewer
	 * 
	 * @includeExample GMapDisplay.as
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10.1
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */

	public class GMapDisplay extends TouchComponent
	{
		private var _id:int;
		private var _intialize:Boolean;
		public var map:Map3D;
		private var map_holder:TouchSprite;
		private var frame:TouchSprite;
		private var screen:TouchSprite;
		private var screen2:TouchSprite;
		private var newMarker:CreateMarker;
		private var MArray:Array = new Array();
		private var circle:Array = new Array();
		var image:Bitmap;
		//------ map settings ------//
		private var mapApiKey:String = "";
		private var stageWidth:Number;
		private var stageHeight:Number;
		private var currLat:Number = -73.992062;
		private var currLng:Number = 40.736072;
		private var currType:Number = 0;
		private var currSc:Number = 15;
		private var currAng:Number = 0;
		private var currtiltAng:Number = 0;
		private var stepSc:Number = 0;
		private var mapWidth:Number = 0;
		private var mapHeight:Number = 0;
		private var mapRotation:Number = 0;
		private var numberOfMarkers:Number = 0;
		private var logoOn = "false";

		//---------frame settings--//
		private var frameDraw:Boolean = true;
		private var frameMargin:Number = 50;
		private var frameRadius:Number = 20;
		private var frameFillColor:Number = 0xFFFFFF;
		private var frameFillAlpha:Number = 0.5;
		private var frameOutlineColor:Number = 0xFFFFFF;
		private var frameOutlineStroke:Number = 2;
		private var frameOutlineAlpha:Number = 1;
		private var iconLogoSub:TouchSprite =new TouchSprite();
		private var iconLogoSubExt:TouchSprite =new TouchSprite();
		// ---map gestures---//
		private var mapDoubleTapGesture:Boolean = true;
		private var mapDragGesture:Boolean = true;
		private var mapFlickGesture:Boolean = true;
		private var mapScaleGesture:Boolean = true;
		private var mapRotateGesture:Boolean = true;
		private var mapTiltGesture:Boolean = true;

		//----frame gestures---//
		private var frameDragGesture:Boolean = true;
		private var frameScaleGesture:Boolean = true;
		private var frameRotateGesture:Boolean = true;
		private var vergroot:Array = new Array();
		private var eigen;
		
		
		[Embed(source = "../../../assets/interface/pit_logo.svg")]
		public var iconLogoClass:Class;
		private var iconLogo = new iconLogoClass();
		
		[Embed(source = "../../../assets/interface/pit_info.svg")]
		public var iconLogoInfoClass:Class;
		private var iconLogoInfo = new iconLogoInfoClass();

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 *
		 * The Constructor.
		 * <pre>
		 * <strong>var mapDisplay:GMapDisplay = new GMapDisplay();
		 * addChild(mapDisplay);</strong></pre>
		 *
		 */

		public function GMapDisplay(magnifier, zichzelf)
		{
			super();
			blobContainerEnabled = true;
			visible = false;
			//Mouse.hide();
			vergroot = magnifier;
			eigen = zichzelf;
			//trace('blaat', eigen);
			
		}
					
		

	

		override public function get id():int
		{
			//trace('id: ',_id);
			return _id;
		}

		override public function set id(value:int):void
		{
			_id = value;
			createUI();
			commitUI();
		}

		override protected function createUI():void
		{
			//--Map Settings--//
			mapApiKey = MapParser.settings.GlobalSettings.apiKey;
			stageWidth = ApplicationGlobals.application.stage.stageWidth;
			stageHeight = ApplicationGlobals.application.stage.stageHeight;

			currLng = MapParser.settings.Content.Source[id].longitude;//-73.992062;
			currLat = MapParser.settings.Content.Source[id].latitude;//40.736072;
			stepSc = MapParser.settings.Content.Source[id].zoomStep;//1;
			currType = MapParser.settings.Content.Source[id].initialType;//1;
			currSc = MapParser.settings.Content.Source[id].initialZoom;//10;
			currAng = MapParser.settings.Content.Source[id].initialAttitude;//0;
			currtiltAng = MapParser.settings.Content.Source[id].initialTilt;//0;
			mapWidth = MapParser.settings.Content.Source[id].mapWidth;
			mapHeight = MapParser.settings.Content.Source[id].mapHeight;
			mapRotation = MapParser.settings.Content.Source[id].mapRotation;


			//---Map Gestures--//
			mapDoubleTapGesture = MapParser.settings.MapGestures.doubleTap == "true" ? true:false;
			mapDragGesture = MapParser.settings.MapGestures.drag == "true" ? true:false;
			mapFlickGesture = MapParser.settings.MapGestures.flick == "true" ? true:false;
			mapScaleGesture = MapParser.settings.MapGestures.scale == "true" ? true:false;
			mapRotateGesture = MapParser.settings.MapGestures.rotate == "true" ? true:false;
			mapTiltGesture = MapParser.settings.MapGestures.tilt == "true" ? true:false;






			//---------- build map ------------------------//
			map = new Map3D();
			map.url = "http://maddoc.khlim.be";
			
			screen = new TouchSprite();
			addChild(screen);
			//trace('screen');
			screen2 = new TouchSprite();
			addChild(screen2);
			//trace('screen2');
			screen.addChild(map);
			
			iconLogo.x = stageWidth -150;
			iconLogo.y = 50;
			addChild(iconLogo);
			
			iconLogoSub.graphics.beginFill(0x000000, 0.000001);
			iconLogoSub.graphics.drawRect(stageWidth -150,50,200,100);
			iconLogoSub.graphics.endFill();
			addChild(iconLogoSub);
			iconLogoSub.addEventListener(TouchEvent.TOUCH_DOWN, changeLogo);
			//trace('add map');


			//-- Add Event Listeners----------------------------------//
			map.addEventListener(MapEvent.MAP_PREINITIALIZE, onMapPreInt);
			map.addEventListener(MapEvent.MAP_READY, onMapReady);

			if (mapDragGesture)
			{
				screen.addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
				screen.addEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
				screen.addEventListener(TouchEvent.TOUCH_UP, touchUpHandler);
				//screen2.addEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
			}
			if (mapDoubleTapGesture)
			{
				screen.addEventListener(TouchEvent.TOUCH_DOUBLE_TAP, doubleTapHandler);
			}
			if (mapScaleGesture)
			{
				screen.addEventListener(GestureEvent.GESTURE_SCALE, gestureScaleHandler);
			}
			if (mapRotateGesture)
			{
				screen.addEventListener(GestureEvent.GESTURE_ROTATE, gestureRotateHandler);
			}
			if (mapTiltGesture)
			{
				screen.addEventListener(GestureEvent.GESTURE_TILT, gestureTiltHandler);
			}
		}



		override protected function commitUI():void
		{
			width = mapWidth;
			height = mapHeight;

			//trace(width, height);

			map.key = mapApiKey;
			map.setSize(new Point(mapWidth,mapHeight));
			map.sensor = "false";
			screen.blobContainerEnabled = true;

			rotation = mapRotation;

			if (! _intialize)
			{
				_intialize = true;
				visible = true;
			}
		}
		public function resetter(){
			map.setCenter(new LatLng(currLat,currLng), currSc); 
			newMarker.UpdateCircle();
			}

		private function touchDownHandler(event:TouchEvent):void
		{

			startTouchDrag(-1);
			//parent.setChildIndex(this as DisplayObject,parent.numChildren-1);
		}

		private function touchUpHandler(event:TouchEvent):void
		{

			newMarker.UpdateCircle();

			stopTouchDrag(-1);
		}

		private function onMapPreInt(event:MapEvent):void
		{
			var mOptions:MapOptions = new MapOptions();
			mOptions.zoom = currSc;
			mOptions.center = new LatLng(currLat,currLng);
			//mOptions.viewMode = View.VIEWMODE_PERSPECTIVE;
			//mOptions.attitude = new Attitude(currtiltAng,currAng,0);



			///////////////

			var Zout:Array = [
			
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD_HIGHWAY,
			        MapTypeStyleElementType.GEOMETRY,
			        [MapTypeStyleRule.hue(0xffe293),
			MapTypeStyleRule.visibility("simplified"), 
			MapTypeStyleRule.visibility("on")]),
			
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD_HIGHWAY,
			        MapTypeStyleElementType.LABELS,
			        [MapTypeStyleRule.visibility("off")]),
			
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD_ARTERIAL,
			        MapTypeStyleElementType.GEOMETRY,
			        [MapTypeStyleRule.hue(0xffe293),
			        MapTypeStyleRule.visibility("simplified"), 
					MapTypeStyleRule.visibility("on")]),
			
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD_ARTERIAL,
			        MapTypeStyleElementType.LABELS,
			        [MapTypeStyleRule.visibility("off")]),
			
						
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD_LOCAL,
			        MapTypeStyleElementType.GEOMETRY,
			        [MapTypeStyleRule.hue(0xffe293),
					 MapTypeStyleRule.lightness(-50), 
					 MapTypeStyleRule.gamma(3),
					 MapTypeStyleRule.saturation(-30), 
			        MapTypeStyleRule.visibility("simplified"), 
					MapTypeStyleRule.visibility("on")]),
			
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD_LOCAL,
			        MapTypeStyleElementType.LABELS,
			        [MapTypeStyleRule.visibility("off")]),
			
			
			new MapTypeStyle(MapTypeStyleFeatureType.LANDSCAPE,
			MapTypeStyleElementType.GEOMETRY,
			        [MapTypeStyleRule.hue(0xffe293),
			MapTypeStyleRule.visibility("simplified"), 
			MapTypeStyleRule.visibility("on")]),
			
			new MapTypeStyle(MapTypeStyleFeatureType.LANDSCAPE,
			MapTypeStyleElementType.LABELS,
			        [MapTypeStyleRule.visibility("off")]),
			
			new MapTypeStyle(MapTypeStyleFeatureType.LANDSCAPE_MAN_MADE,
			MapTypeStyleElementType.GEOMETRY,
			        [MapTypeStyleRule.hue(0xffe293),
MapTypeStyleRule.visibility("off"), 
			MapTypeStyleRule.visibility("simplified")]),
			
			new MapTypeStyle(MapTypeStyleFeatureType.LANDSCAPE_NATURAL,
			MapTypeStyleElementType.GEOMETRY,
			        [MapTypeStyleRule.hue(0xffe293),
					 MapTypeStyleRule.visibility("on"),
			MapTypeStyleRule.visibility("simplified")]),
			
			    new MapTypeStyle(MapTypeStyleFeatureType.ROAD_LOCAL,
			        MapTypeStyleElementType.GEOMETRY,
			       [MapTypeStyleRule.hue(0xffe293),
			        MapTypeStyleRule.visibility("off")]),
			
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD_LOCAL,
			        MapTypeStyleElementType.LABELS,
			        [MapTypeStyleRule.visibility("off")]),
			
			    new MapTypeStyle(MapTypeStyleFeatureType.ADMINISTRATIVE,
			        MapTypeStyleElementType.GEOMETRY,
			        [MapTypeStyleRule.visibility("off")]),
			
			new MapTypeStyle(MapTypeStyleFeatureType.ADMINISTRATIVE,
			        MapTypeStyleElementType.LABELS,
			        [MapTypeStyleRule.visibility("off")]),
			  
			new MapTypeStyle(MapTypeStyleFeatureType.POI,
			        MapTypeStyleElementType.GEOMETRY,
			        [MapTypeStyleRule.visibility("off")]),
			
			new MapTypeStyle(MapTypeStyleFeatureType.POI,
			        MapTypeStyleElementType.LABELS,
			        [MapTypeStyleRule.visibility("off")]),
			
			
			new MapTypeStyle(MapTypeStyleFeatureType.WATER,
			        MapTypeStyleElementType.GEOMETRY,
			        [MapTypeStyleRule.visibility("off"),
			 MapTypeStyleRule.hue(0xffe293),
			MapTypeStyleRule.visibility("simplified")]),
			
			new MapTypeStyle(MapTypeStyleFeatureType.WATER,
			        MapTypeStyleElementType.LABELS,
			        [MapTypeStyleRule.visibility("off")]),
			

			
			new MapTypeStyle(MapTypeStyleFeatureType.ALL,
			        MapTypeStyleElementType.GEOMETRY,
			        [MapTypeStyleRule.visibility("on"), 
					 MapTypeStyleRule.hue(0xffe293), 
					MapTypeStyleRule.saturation(80), 
					MapTypeStyleRule.lightness(25),
					MapTypeStyleRule.gamma(0),
					MapTypeStyleRule.visibility("simplified")]) ,
			
						new MapTypeStyle(MapTypeStyleFeatureType.TRANSIT,
			        MapTypeStyleElementType.GEOMETRY,
			        [MapTypeStyleRule.visibility("on"), 
					 MapTypeStyleRule.hue(0x000000), 
					  MapTypeStyleRule.lightness(1), 
					   MapTypeStyleRule.saturation(-1), 
					    MapTypeStyleRule.gamma(0.1)]) ,
				
			new MapTypeStyle(MapTypeStyleFeatureType.TRANSIT,
			        MapTypeStyleElementType.LABELS,
			        [MapTypeStyleRule.visibility("off")]) ,
			    
			
			];

			var styledMapOptions:StyledMapTypeOptions = new StyledMapTypeOptions({
			    name: 'Z-out',
			//minResolution: 2,
			//maxResolution: 20, 
			    alt: 'Z-out'
			});

			var styledMapType:StyledMapType = new StyledMapType(Zout,styledMapOptions);




			//////////////


			mOptions.mapType = styledMapType;

			map.setInitOptions(mOptions);
		}
		private function changeLogo(event:TouchEvent){
			//trace('klik');
			if(logoOn == "false"){
				
				
			iconLogoInfo.x = stageWidth -380; 
			iconLogoInfo.y = 55;
			addChild(iconLogoInfo);
			
			iconLogoSubExt.graphics.beginFill(0x000000, 0.00001);
			iconLogoSubExt.graphics.drawRect(stageWidth -350,50,400,400);
			iconLogoSubExt.graphics.endFill();
			addChild(iconLogoSubExt);
			iconLogoSubExt.addEventListener(TouchEvent.TOUCH_DOWN, changeLogoBack);
			logoOn = "true";
			}
			
			}
		private function changeLogoBack(event:TouchEvent){
			removeChild(iconLogoSubExt);
			removeChild(iconLogoInfo);
			logoOn = "false";
			
			}
		private function onMapReady(event:MapEvent):void
		{

			newMarker = new CreateMarker(map);
			newMarker.addEventListener(Event.COMPLETE, dataReadyHandler);
			//loadImage();
			//loadLogo();
			/*map.addControl(new ZoomControl());
			map.addControl(new MapTypeControl());*/

		}


		/*public function loadImage():void
		{
		var loader:Loader = new Loader  ;
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, backLoaded);
		loader.load(new URLRequest("assets/overlay.png"));
		}
		private function backLoaded(event:Event):void
		{
		var image = new Bitmap(event.target.content.bitmapData);
		map.addChild(image);
		}*/

		public function loadLogo():void
		{
			var loader:Loader = new Loader  ;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, logoLoaded, false, 0, false);
			loader.load(new URLRequest("assets/interface/pit_info.svg"));
		}
		private function logoLoaded(event:Event):void
		{
			var logo = new Bitmap(event.target.content.bitmapData);
			logo.x = 40;
			logo.y = 40;
			//screen.addChild(logo);
		}
		function dataReadyHandler(event:Event):void
		{
			screen2.addChild(newMarker);
			newMarker.addToMap();

		}

		private function objectScaleHandler(event:GestureEvent):void
		{
			scaleX +=  event.value;
			scaleY +=  event.value;
		}

		private function objectRotateHandler(event:GestureEvent):void
		{
			rotation +=  event.value;
		}

		private function touchMoveHandler(event:TouchEvent):void
		{
			var point:Point = map.fromLatLngToPoint(map.getCenter());
			var ang:Number = this.rotation*(Math.PI/180);
			var COS:Number = Math.cos(ang);
			var SIN:Number = Math.sin(ang);
			var pdx:Number = (point.x - (event.dy*SIN + event.dx*COS));
			var pdy:Number = (point.y - (event.dy*COS - event.dx*SIN));
			var newPoint:Point = new Point(pdx,pdy);
			newMarker.UpdateCircle();
			//trace("it's alive", event.dx, event.dy);
			
	
			var newLatLng:LatLng = map.fromPointToLatLng(newPoint);
			map.setCenter(newLatLng);
			map.cancelFlyTo();
			
			for (var i = 0; i<vergroot.length;i++){
				vergroot[i].captureBitmap();
				eigen.gui(i);
				}
		}

		private function doubleTapHandler(event:TouchEvent):void
		{
			//var newPoint:Point = new Point(event.localX,event.localY);
			//var nLatLng:LatLng = map.fromViewportToLatLng(newPoint,true);
			//currSc +=  stepSc;
			//map.flyTo(nLatLng, currSc, new Attitude(currAng,currtiltAng,0), 2);
		}



		private function gestureScaleHandler(event:GestureEvent):void
		{

			//newMarker.UpdateCircle();
			//trace('schaal: ' + count);
			//trace('event value: ' + event.value);
			if(event.value+currSc>2 && event.value+currSc<=17) 
			{
				currSc +=  event.value;
				//trace('currSc: ' + currSc);
			}

			//trace('map zoom before' + map.getZoom());
			map.setZoom(currSc, true);
			//trace('map zoom after' + map.getZoom());
			map.cancelFlyTo();
			newMarker.UpdateCircle();

		}


		private function gestureRotateHandler(event:GestureEvent):void
		{
			newMarker.UpdateCircle();
			currAng -=  event.value;
			map.setAttitude(new Attitude(currAng,currtiltAng,0));
			map.cancelFlyTo();
		}

		private function gestureTiltHandler(event:GestureEvent):void
		{
			newMarker.UpdateCircle();
			//trace(currtiltAng);
			currtiltAng +=  event.tiltY;
			map.setAttitude(new Attitude(currAng,currtiltAng,0));
			map.cancelFlyTo();
		}
		
		
		/**
		 *
		 * The Disposal method for the module. It will clean out and nullify all children.
		 * <pre>
		 * <strong>mapDisplay.Dispose();</strong></pre>
		 *
		 */
		override public function Dispose():void
		{
			trace( this + ".Dispose()" );
			
			iconLogoSub.removeEventListener(TouchEvent.TOUCH_DOWN, changeLogo);
			map.removeEventListener(MapEvent.MAP_PREINITIALIZE, onMapPreInt);
			map.removeEventListener(MapEvent.MAP_READY, onMapReady);
			iconLogoSubExt.removeEventListener(TouchEvent.TOUCH_DOWN, changeLogoBack);
			newMarker.removeEventListener(Event.COMPLETE, dataReadyHandler);		
			
			if ( map_holder )			map_holder.Dispose();
			if ( frame )				frame.Dispose();
			if ( screen )				screen.Dispose();
			if ( screen2 )				screen2.Dispose();
			
			if ( iconLogoSub )			iconLogoSub.Dispose();
			if ( iconLogoSubExt )		iconLogoSubExt.Dispose();
			
			if (mapDragGesture)
			{
				removeEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
				removeEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
				removeEventListener(TouchEvent.TOUCH_UP, touchUpHandler);
			}
			if (mapDoubleTapGesture)
			{
				removeEventListener(TouchEvent.TOUCH_DOUBLE_TAP, doubleTapHandler);
			}
			if (mapScaleGesture)
			{
				removeEventListener(GestureEvent.GESTURE_SCALE, gestureScaleHandler);
			}
			if (mapRotateGesture)
			{
				removeEventListener(GestureEvent.GESTURE_ROTATE, gestureRotateHandler);
			}
			if (mapTiltGesture)
			{
				removeEventListener(GestureEvent.GESTURE_TILT, gestureTiltHandler);
			}
			
			// Don't do this :-)
			//super.updateUI();
			
			if (parent)
			{
				parent.removeChild(this);
			}
		}
		

	}
}