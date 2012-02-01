package
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.net.URLRequest;
	
	import id.core.TouchSprite;
	
	public class Marker extends TouchSprite
	{
		public var lng:String;
		public var lat:String;
		public var u:Number;
		public var v:Number;
		protected var iconURL:String;
		protected var icon:DisplayObject;
		
		public static const ICON_OFFSET_X:Number = -2;
		public static const ICON_OFFSET_Y:Number = -25;
		
		public function Marker(lng:String, lat:String, iconURL:String )
		{
			super();
			
			this.lng = lng;
			this.lat = lat;
			this.iconURL = iconURL;
			
			iconURL = "http://localhost:8000/z33/images/Tentenkamp.png";
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onIconLoaded, false, 0, true);
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			loader.load( new URLRequest(iconURL) );
		}
		
		public function setMapLocation(u:Number, v:Number):void {
			this.x = this.u = u;
			this.y = this.v = v;
		}
		
		protected function onIconLoaded(e:Event):void {
			icon = (e.currentTarget as LoaderInfo).content;
			icon.x = ICON_OFFSET_X;
			icon.y = -icon.height - ICON_OFFSET_Y;
			addChild(icon);
		}
		
		protected function onHTTPStatus(e:HTTPStatusEvent):void{
			trace("HTTP status "+e.status);
		}
		
		override public function toString():String {
			return "[Marker lng:" + lng + " lat: " + lat + " iconURL: " + iconURL + "]"; 
		}
	}
}