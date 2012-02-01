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
		protected var iconURL:String;
		protected var icon:DisplayObject;
		
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
		
		protected function onIconLoaded(e:Event):void {
			icon = (e.currentTarget as LoaderInfo).content;
			addChild(icon);
		}
		
		protected function onHTTPStatus(e:HTTPStatusEvent):void{
			trace("HTTP status "+e.status);
		}
	}
}