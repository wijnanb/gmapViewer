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
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.*;
	import flash.net.URLRequest;
	
	import gl.events.TouchEvent;
	
	import id.core.ApplicationGlobals;
	import id.core.TouchComponent;
	import id.core.TouchSprite;
	import id.element.ContentParser;
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
		private var logoCollapsed:Boolean = false;
		
		private var iconLogoHitarea:TouchSprite = new TouchSprite();
		
		protected var markers:Array;
		protected var pinpointLocations:Array;
		
		protected var logoLayer:TouchSprite;
		protected var markerLayer:TouchSprite;
		protected var mapLayer:Sprite;
		
		public static const DEBUG_COLLISION_DETECTION:Boolean = false;
		
		public static const GREENKEY_COLOR:uint = 0x65ba4a;
		public static const GREENKEY_WIDTH:uint = 6;
		public static const GREENKEY_HEIGHT:uint = 10;
		
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
			
			mapLayer = new Sprite();
			markerLayer = new TouchSprite();
			logoLayer = new TouchSprite();
			
			addChild(mapLayer);
			addChild(markerLayer);
			addChild(logoLayer);
			
			if (stage)		onStageReady();
			else			addEventListener(Event.ADDED_TO_STAGE, onStageReady, false, 0, true);
		}
		
		protected function onStageReady(e:Event=null):void {
			iconLogo.x = stageWidth -150;
			iconLogo.y = 50;
			logoLayer.addChild(iconLogo);
			
			iconLogoHitarea.graphics.beginFill(0x000000, 0.000001);
			iconLogoHitarea.graphics.drawRect(stageWidth -150,50,200,100);
			iconLogoHitarea.graphics.endFill();
			iconLogoHitarea.addEventListener(TouchEvent.TOUCH_DOWN, onLogoTouched, false, 0, true);
			logoLayer.addChild(iconLogoHitarea);
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
			parseContent();
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
			
			mapHeight = Math.min(1280, mapHeight - 0);  // remove Google advertising
		}

		protected function loadMap():void {
			var url:String = "http://maps.google.com/maps/api/staticmap?sensor=false";
			url += "&center=" + currLat + "," + currLng;
			url += "&size=" + Math.ceil(mapWidth/2) + "x" + Math.ceil(mapHeight/2);
			url += "&scale=2"
			url += "&zoom=" + currSc
			url += MapData.getStyle(MapData.COLORSCHEME_YELLOW);
			
			var markersUrl:String = url + MapData.getMarkers(markers);	
			trace( markersUrl );
			
			var markersLoader:Loader = new Loader();
			markersLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onMapLoaded, false, 0, true);
			markersLoader.load( new URLRequest(markersUrl) );
			
			var loader:Loader = new Loader();
			loader.load( new URLRequest(url) );
			if ( !DEBUG_COLLISION_DETECTION )	mapLayer.addChild(loader);
		}

		protected function onMapLoaded(e:Event):void {
			trace("map loaded");
			
			var image:Bitmap = Bitmap( (e.target as LoaderInfo).content );
			pinpointLocations = findPinpointLocations(image.bitmapData);
			
			// match pinpointLocations with markers
			for ( var i:int=0; i<markers.length; i++ ) {
				var marker:Marker = markers[i];
				var pinpoint:Point = pinpointLocations[i];
				
				marker.setMapLocation(pinpoint.x, pinpoint.y);
			}
			
			Global.viewer.updateAllMagnifiers();
		}
		
		protected function findPinpointLocations(bitmapData:BitmapData):Array {
			var output:Array = new Array();
			
			var imgWidth:int = bitmapData.width;
			var imgHeight:int = bitmapData.height;
			var pixelColor:uint;
			
			var cnt:int = 0;
			
			bitmapData.lock();
			
			for ( var u:int = 0; u<imgWidth; u++ ) {
				for ( var v:int = 0; v<imgHeight; v++ ) {
					pixelColor = bitmapData.getPixel(u,v);
					
					if ( pixelColor === GREENKEY_COLOR ) {
						
						if ( bitmapData.getPixel(u+GREENKEY_WIDTH-1,v) == GREENKEY_COLOR && bitmapData.getPixel(u,v+GREENKEY_HEIGHT-1) == GREENKEY_COLOR && bitmapData.getPixel(u+GREENKEY_WIDTH-1,v+GREENKEY_HEIGHT-1) == GREENKEY_COLOR ) {
							bitmapData.setPixel(u+Math.floor(GREENKEY_WIDTH/2)-1,v+GREENKEY_HEIGHT,0xFFFF00);
							output.push( new Point(u,v) );
						}
					}
				}
			}
			
			bitmapData.unlock();
			
			return output;
		}
		
		protected function parseContent():void {
			ContentParser.settingsPath = "FSCommand/Content.xml";
			ContentParser.addEventListener(Event.COMPLETE,onContentParseComplete);
		}
		
		protected function onContentParseComplete(e:Event):void {
			markers = new Array();
			
			for (var i=0; i<ContentParser.settings.Content.Source.length(); i++)
			{
				var id:int = parseInt(ContentParser.settings.Content.Source[i].@id);
				var lng:String = ContentParser.settings.Content.Source[i].longitude;
				var lat:String = ContentParser.settings.Content.Source[i].latitude;
				var iconURL:String = ContentParser.settings.Content.Source[i].markerIcon;
				
				if ( lng!="" && lat!="" ) {	
					var marker:Marker = new Marker(id, lng, lat, iconURL);
					markers.push(marker);
					
					markerLayer.addChild(marker);
				}
			}
			
			markers.sortOn(['lng', 'lat'], Array.NUMERIC); // order markers bij lng, lat
			
			loadMap();
		}
		
		
		public function resetter():void {
		
		}

		
		protected function onLogoTouched(event:TouchEvent){
			if(!logoCollapsed){
				iconLogoInfo.x = stageWidth -380; 
				iconLogoInfo.y = 55;
				logoLayer.addChild(iconLogoInfo);
				logoLayer.setChildIndex(iconLogoHitarea, logoLayer.numChildren-1);
				logoCollapsed = true;
			}
			else
			{
				logoLayer.removeChild(iconLogoInfo);
				logoCollapsed = false;	
			}
		}
		
		public function collisionDetect(posX:Number, posY:Number):Marker {
			var m:Marker;
			var markers_length:int = markers.length;
			var dx:Number;
			var dy:Number;
			var d:Number;
			var list:Array = new Array();
			
			if ( DEBUG_COLLISION_DETECTION ) {
				graphics.lineStyle(1, 0xFFFFFF, 0.5);
			}
				
			for ( var i:int=0; i<markers_length; i++ ) {
				m = markers[i];
				
				if ( ! m.center ) break;
				
				dx = m.center.x - posX;
				dy = m.center.y - posY;
				d = Math.sqrt( dx*dx + dy*dy );
				
				if ( d <= m.radius ) {
					list.push(m);
				}
				
				if ( DEBUG_COLLISION_DETECTION ) {
					m.reset();
					graphics.moveTo(posX, posY);
					graphics.lineTo(m.center.x, m.center.y);
					
					if ( d <= m.radius ) {
						trace(d + " " + m.radius + " *");
					}
					else {
						trace(d + " " + m.radius);
					}
				}
			}
			
			if ( DEBUG_COLLISION_DETECTION )	trace( "detected :" + list.length );
			
			if (list.length > 1 ) {
				// Always take the smallest hotspot
				list.sortOn("radius", Array.NUMERIC);
			}
			
			if ( list.length > 0 ) {
				if ( DEBUG_COLLISION_DETECTION )	(list[0] as Marker).highlight();
				return list[0];
			}
			
			return null;
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
			
			iconLogoHitarea.removeEventListener(TouchEvent.TOUCH_DOWN, onLogoTouched);
			//newMarker.removeEventListener(Event.COMPLETE, dataReadyHandler);		
				
			if ( iconLogoHitarea )			iconLogoHitarea.Dispose();
			
			if (parent)
			{
				parent.removeChild(this);
			}
		}
		

	}
}