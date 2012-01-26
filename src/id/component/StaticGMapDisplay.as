package id.component
{
	import com.google.maps.LatLng;
	import com.google.maps.MapEvent;
	import com.google.maps.MapOptions;
	import com.google.maps.StyledMapType;
	import com.google.maps.StyledMapTypeOptions;
	import com.google.maps.services.*;
	import com.google.maps.styles.MapTypeStyle;
	import com.google.maps.styles.MapTypeStyleElementType;
	import com.google.maps.styles.MapTypeStyleFeatureType;
	import com.google.maps.styles.MapTypeStyleRule;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.*;
	import flash.net.URLRequest;
	
	import gl.events.TouchEvent;
	
	import id.core.ApplicationGlobals;
	import id.core.TouchComponent;
	import id.core.TouchSprite;
	import id.element.MapParser;
	





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

	public class StaticGMapDisplay extends TouchComponent
	{
		private var _id:int;
		
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
		
		private var iconLogoSub:TouchSprite = new TouchSprite();
		private var iconLogoSubExt:TouchSprite = new TouchSprite();
		
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

		public function StaticGMapDisplay()
		{
			super();
			
			if (stage)		onStageReady();
			else			addEventListener(Event.ADDED_TO_STAGE, onStageReady, false, 0, true);
		}
		
		protected function onStageReady(e:Event=null):void {
			iconLogo.x = stageWidth -150;
			iconLogo.y = 50;
			addChild(iconLogo);
			
			iconLogoSub.graphics.beginFill(0x000000, 0.000001);
			iconLogoSub.graphics.drawRect(stageWidth -150,50,200,100);
			iconLogoSub.graphics.endFill();
			iconLogoSub.addEventListener(TouchEvent.TOUCH_DOWN, changeLogo, false, 0, true);
			addChild(iconLogoSub);
		}
					
		override public function get id():int
		{
			return _id;
		}

		override public function set id(value:int):void
		{
			_id = value;
		}
		
		public function init():void {
			configure();
			loadMap();
		}

		protected function configure():void
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
		}

		protected function loadMap():void {
			var url:String = "http://maps.google.com/maps/api/staticmap?sensor=false&size=640x640&scale=2&zoom=14&center=Borgloon+Belgium&style=feature:all|element:labels|visibility:off&style=feature:all|element:geometry|hue:0xffe293|lightness:31|gamma:0.63";
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onMapLoaded, false, 0, true);
			loader.load( new URLRequest(url) );
			addChild(loader);
		}

		protected function onMapLoaded(e:Event):void {
			trace("map loaded");
		}
		
		
		public function resetter():void {
		
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

			//map.setInitOptions(mOptions);
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
			//newMarker = new CreateMarker(map);
			//newMarker.addEventListener(Event.COMPLETE, dataReadyHandler);
		}



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
			//screen2.addChild(newMarker);
			//newMarker.addToMap();

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
			iconLogoSubExt.removeEventListener(TouchEvent.TOUCH_DOWN, changeLogoBack);
			//newMarker.removeEventListener(Event.COMPLETE, dataReadyHandler);		
				
			if ( iconLogoSub )			iconLogoSub.Dispose();
			if ( iconLogoSubExt )		iconLogoSubExt.Dispose();
			
			if (parent)
			{
				parent.removeChild(this);
			}
		}
		

	}
}