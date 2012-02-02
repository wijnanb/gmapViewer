package
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import id.core.TouchSprite;
	
	public class Marker extends TouchSprite
	{
		public var lng:String;
		public var lat:String;
		public var u:Number;
		public var v:Number;
		public var radius:Number;
		public var center:Point;
		public var locationIsSet:Boolean = false;
		protected var relative_center:Point;
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
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onIconLoaded, false, 0, true);
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			loader.load( new URLRequest(iconURL) );
			addChild(loader);
		}
		
		public function setMapLocation(u:Number, v:Number):void {
			this.x = this.u = u;
			this.y = this.v = v;
			
			if ( icon ) 	center = new Point( this.x + relative_center.x, this.y + relative_center.y );
			locationIsSet = true;
		}
		
		protected function onIconLoaded(e:Event):void {
			icon = (e.currentTarget as LoaderInfo).content;
			icon.x = ICON_OFFSET_X;
			icon.y = -icon.height - ICON_OFFSET_Y;
			
			relative_center = new Point(icon.x + icon.width/2, icon.y + icon.height/2);
			if ( locationIsSet ) 	center = new Point( this.x + relative_center.x, this.y + relative_center.y );
			radius = (icon.width/2 + icon.height/2)/2 * 1.4;
			
			reset();
		}
		
		public function highlight():void {
			graphics.clear();
			graphics.lineStyle(1, 0xff0000, 0.5);
			graphics.drawCircle( relative_center.x, relative_center.y, radius);
		}
		
		public function reset():void {
			graphics.clear();
			graphics.lineStyle(1, 0xffe293, 0.5);
			graphics.drawCircle( relative_center.x, relative_center.y, radius);
		}
		
		protected function onHTTPStatus(e:HTTPStatusEvent):void{
			if ( e.status != 200 ) {
				trace("loading icon: HTTP status "+e.status);
			}
		}
		
		override public function toString():String {
			return "[Marker lng:" + lng + " lat: " + lat + " iconURL: " + iconURL + "]"; 
		}
	}
}