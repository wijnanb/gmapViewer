package id.component
{
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.geom.*;
	import flash.ui.Mouse;
	import flash.text.*;
	import id.core.ApplicationGlobals;
	import id.core.TouchSprite;
	import gl.events.TouchEvent;
	import gl.events.GestureEvent;
	import id.core.TouchComponent;
	import id.element.ContentParser;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import id.element.TextDisplay;

	import com.google.maps.LatLng;
	import com.google.maps.Map3D;
	import com.google.maps.MapEvent;
	import com.google.maps.MapOptions;
	import com.google.maps.InfoWindowOptions;
	import com.google.maps.MapType;
	import com.google.maps.View;
	import com.google.maps.geom.Attitude;
	import com.google.maps.overlays.Marker;
	import com.greensock.*;
	import com.google.maps.overlays.GroundOverlay;
	import com.google.maps.overlays.GroundOverlayOptions;
	import com.google.maps.LatLngBounds;
	import com.google.maps.overlays.MarkerOptions;
		import flash.display.Sprite;
	import com.google.maps.MapMouseEvent;
	import com.google.maps.InfoWindowOptions;
	import com.lorentz.SVG.*;
	import flash.display.BitmapData;
	

	public class CreateMarker extends TouchComponent
	{
		private var marker:Marker;
		private var Lat:Number = -73.992062;
		private var Lng:Number = 40.736072;
		private var MarkerArray:Array = new Array();
		//ContentParser.settings.Content.Source[i].markerIcon
/*
		[Embed(source = "../../assets/interface/arrowpin.png")]
		private var markerIcon:Class;*/
		private var TMarker:TouchSprite;
		private var Container:TouchSprite;
		var circle:TouchSprite = new TouchSprite();

		var circleList:Array = new Array();
		var textList:Array = new Array();
		var descList:Array = new Array();
		var liveVideoList:Array = new Array();
		var guiList:Array = new Array();
		var box;
		var point2;

		var currMap;
		//var image:Bitmap;
		[Embed(source = "../../../assets/interface/info.svg")]
		public var infoClass:Class;
		private var info = new infoClass();

		public function CreateMarker(mapSet)
		{
			super();
			//loadImage();
			trace("new CreateMarker()");
			ContentParser.settingsPath = "FSCommand/Content.xml";
			ContentParser.addEventListener(Event.COMPLETE,onParseComplete);
			TMarker = new TouchSprite();
			currMap = mapSet;

			//var container:MagnifierViewer=new MagnifierViewer();
			//addChild(container);
			
/*			        var testLoader:Loader = new Loader();
        var urlRequest:URLRequest = new URLRequest("assets/Interface/PIT_FLYER_VERSO3.swf");
        testLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
			addChild(testLoader);
           var groundOverlay:GroundOverlay = new GroundOverlay(
                testLoader,
                new LatLngBounds( new LatLng(50.752314,5.244598), new LatLng( 50.825837,5.447845)));
            currMap.addOverlay(groundOverlay);
        });
        testLoader.load(urlRequest); */

		}
		/*public function loadImage():void
		{
		var loader:Loader = new Loader  ;
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
		loader.load(new URLRequest("assets/arrowpin.png"));
		}
		private function imageLoaded(event:Event):void
		{
		image = new Bitmap(event.target.content.bitmapData);
		}
		*/
var icoonWidth;
var icoonHeight;
var proxy:String = "http://maddoc.khlim.be/~dleen/Z33/gmapViewer/proxy.php?url=";

		private function onParseComplete(event:Event):void
		{

			for (var i=0; i<ContentParser.amountToShow; i++)
			{
				Lng = ContentParser.settings.Content.Source[i].longitude;
				Lat = ContentParser.settings.Content.Source[i].latitude;
				//trace('onparse: ' , i, ' Lat: ', Lat, ' long: ',  Lng);
				var latlng:LatLng = new LatLng(Lat,Lng);
				var markerOptions:MarkerOptions = new MarkerOptions();
				

				
				var icoon:String = ContentParser.settings.Content.Source[i].markerIcon;
				var imageLoader:Loader = new Loader();
				var image:URLRequest = new URLRequest(proxy + icoon);
				imageLoader.load(image);
				markerOptions.icon = imageLoader;
				markerOptions.icon.cacheAsBitmap = true;
				
				MarkerArray[i] = new Marker(latlng,markerOptions);


			}

			dispatchEvent(new Event(Event.COMPLETE));

			//parent.addChild(TMarker);
		}




		private var points:Array = new Array();

		public function addToMap()
		{

			for (var i=0; i<ContentParser.amountToShow; i++)
			{
				var latlngM = MarkerArray[i].getLatLng();// lat en lng van de marker

				points[i] = currMap.fromLatLngToViewport(latlngM);// lat en lng to viewport
				currMap.addOverlay(MarkerArray[i]);

			}
			DrawCircle(points);
		}
var images:Array = new Array();
		public function DrawCircle(point)
		{
			for (var i=0; i<ContentParser.amountToShow; i++)
			{
				circle = new TouchSprite();
				circle.graphics.beginFill(0xFF794B , 0.00001);
				circle.graphics.drawRect(0, 0, 100,100);
				circle.graphics.endFill();
				circle.name = i;
				//trace('nummer:' , ContentParser.settings.Content.Source[i].@id);
				circleList[i] = circle;
				parent.addChild(circleList[i]);
				
				
				/*imageLoader.x = 0;
				imageLoader.y = 0;
				images[i] = imageLoader; 
				addChild(images[i]);*/

				/*var myText:TextField = new TextField();
				myText.text = ContentParser.settings.Content.Source[i].title;
				textList[i] = myText;
				myText.textColor = 0xFFFFFF;
				parent.addChild(textList[i]);
				
				var Desc:TextField = new TextField();
				var myFormat:TextFormat = new TextFormat();
				myFormat.size = 9;
				Desc.defaultTextFormat = myFormat;
				Desc.text = ContentParser.settings.Content.Source[i].description;
				descList[i] = Desc;
				Desc.textColor = 0xFFFFFF;
				parent.addChild(descList[i]);
				*/

				circle.addEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
				circle.addEventListener(TouchEvent.TOUCH_UP, touchUpHandler);
			}
			UpdateCircle();
		}
		public function touchDownHandler(e:TouchEvent){
			trace(e.target.name);
			addChild(info);
			info.x = e.stageX - info.width;
			info.y = e.stageY - info.height;
			}
		public function touchUpHandler(e:TouchEvent){
			circle.removeEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
			removeChild(info);
		}
		public function UpdateCircle()
		{
			for (var i=0; i<ContentParser.amountToShow; i++)
			{

				var latlng = MarkerArray[i].getLatLng();// get center of screen = first marker
				point2 = currMap.fromLatLngToViewport(latlng);
				circleList[i].x = point2.x;
				circleList[i].y = point2.y;
				/*images[i].x = point2.x;
				images[i].y = point2.y;*/
				//trace(point2.x,point2.y);
				//trace(vB);
				//if (vB[i] == true)
//				{
					//trace('ha', point2.x, point2.y);
					//trace(nummerKlik.length);
//uncommenten
/*					for (var tulp = 0; tulp < nummerKlik.length; tulp++){
						youtubeList[nummerKlik[tulp]].wireStation();
						//trace("update");
						//}
					//
					
				}*/

				/*descList[i].x = point2.x + 40;
				descList[i].y = point2.y + 16;
				
				textList[i].x = point2.x + 40;
				textList[i].y = point2.y;*/
				/*var titleFormat:TextFormat = new TextFormat();
				titleFormat.bold = true;
				titleFormat.size = 10;
				titleFormat.color = 0xffffff;
				var contentFormat:TextFormat = new TextFormat("Arial",8);
				contentFormat.size = 8;
				contentFormat.font = "Arial";
				
				currMap.openInfoWindow(latlng, new InfoWindowOptions({
				  strokeStyle: {
				    color: 0xffffff
				  },
				  fillStyle: {
				    color: 0xffffff
				  },
				  titleFormat: titleFormat,
				  contentFormat: contentFormat,
				title: "Innercoma",
				content: "Z33 Phillip Mettens",
				
				  width: 160,
				  height:34,
				  cornerRadius:0,
				  hasCloseButton: false,
				  hasTail: false,
				  pointOffset: new Point(118, 55),
				  hasShadow: true
				}));*/
			}

		}
		}
		

}