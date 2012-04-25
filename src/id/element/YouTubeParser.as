package id.element
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;

	/**
	 * This is the YouTubeParser class.
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	public class YouTubeParser extends EventDispatcher
	{
		public static var settings:XML;
		public static var dataSet:Array = new Array();
		public static var flickr:Array = new Array();
		private static var _settingsPath:String = "";
		private static var _settingsId:String = "";
		private static var niveau:String = "";
		private static var settingsLoader:URLLoader;
		protected static var dispatch:EventDispatcher;
		private static var count:int;
		public static var totalAmount:int;
		public static var amountToShow:int;
		private static var request:URLRequest;
		private static var object:Object;
		private static var authorString:String;
		private static var publishString:String;
		private static var regExpPattern:RegExp;
		public static var arrayId;
		public static var counter = 0;

		public static function get settingsPath():String
		{
			return _settingsPath;
		}
		public static function set settingsId(value:String):void
		{
			//trace("geklikt: ",value);
			_settingsId = value;
		}

		public static function set settingsNiveau(value:String):void
		{
			//trace("geklikt: ",value);
			niveau = value;
		}
		public static function set settingsPath(value:String):void
		{
			settingsLoader = new URLLoader();
			settingsLoader.addEventListener(Event.COMPLETE, settingsLoader_completeHandler);
			_settingsPath = value;
			settingsLoader.load(new URLRequest(_settingsPath));
		}

		private static function settingsLoader_completeHandler(event:Event):void
		{
			settings = new XML(settingsLoader.data);
			
			var content:XMLList = settings.Content.Source.(@id==_settingsId);
			var movies:XMLList;
			
			switch ( niveau ) {
				case "constructie":
					movies = content.constructie.youtube;
					break;
				case "concept":
					movies = content.concept.youtube;
					break;
				case "resultaat":
					movies = content.resultaat.youtube;
					break;
			}
			
			var movies_length:int = movies.length();
			amountToShow = movies_length;
			
			var i:int;
			
			if ( Player.runOffline ) {
				dataSet = new Array();
				
				for (i = 0; i < movies_length; i++)
				{
					var object:Object = new Object();
					object.videoSource = movies[i].url;
					object.title = movies[i].title;
					object.description = movies[i].description;
					object.author = movies[i].author;
					object.publish = movies[i].publish;
					object.qrCodeTag = "";
					object.thumbUrl = "";
					object.duration = 0;
					
					dataSet.push(object);
				}
				
				settingsLoader.removeEventListener(Event.COMPLETE, settingsLoader_completeHandler);
				settingsLoader = null;
				
				dispatchEvent(new Event(Event.COMPLETE));
				
			} else {
				for (i = 0; i < movies_length; i++)
				{
					var request:URLRequest = new URLRequest();
					if (movies[i].url.slice(0,15) ==  "http://youtu.be"){
						request.url = "http://gdata.youtube.com/feeds/api/videos/" + movies[i].url.slice(16,27);
					}
					else{
						request.url = "http://gdata.youtube.com/feeds/api/videos/" + movies[i].url.slice(31,42);
					}
					onYouTubeParseComplete(request);
				}
				
				settingsLoader.removeEventListener(Event.COMPLETE, settingsLoader_completeHandler);
				settingsLoader = null;
			}
		}

		private static function onYouTubeParseComplete(request:URLRequest):void
		{
			var loader:URLLoader=new URLLoader();
			loader.load(request);
			loader.addEventListener(Event.COMPLETE,onLoadCompleteHandle);
		}

		private static function onLoadCompleteHandle(e:Event):void
		{
			var XMLNS:Namespace = new Namespace("http://www.w3.org/2005/Atom");
			var OPENSEARCH:Namespace = new Namespace("http://a9.com/-/spec/opensearchrss/1.0/");
			var GEORSS:Namespace = new Namespace("http://www.georss.org/georss");
			var GML:Namespace = new Namespace("http://www.opengis.net/gml");
			var MEDIA:Namespace = new Namespace("http://search.yahoo.com/mrss/");

			var il:XML = new XML(e.target.data);
			//trace ("onloadcomplete",il);
			var ytId:String = il.XMLNS::id.slice(42,53);
			var thumb:XMLList = il.MEDIA::group.MEDIA::thumbnail;
			var duration:String = il.MEDIA::group.MEDIA::content[0]. @ duration;
			//trace('htijd: ',duration);
			var qrCode:String = il.MEDIA::group.MEDIA::player. @ url;
			var descript:String = il.MEDIA::group.MEDIA::description;
			var author:String = il.XMLNS::author.XMLNS::name;
			var geo:String = il.GEORSS::where.GML::Point.GML::pos;
			var geoArray:Array = geo.split(" ");
			var keywords:String = il.MEDIA::group.MEDIA::keywords;
			var myPattern:RegExp = /,/g;
			var str:String = keywords;
			var tag:String = str.replace(myPattern,"");

			object=new Object();
			object.title = il.XMLNS::title;
			object.qrCodeTag = qrCode;
			object.latitude = geoArray[0];
			object.longitude = geoArray[1];
			object.duration  = duration;
			object.imgUrl = thumb[3]. @ url;
			object.videoSource = ytId;
			object.thumbUrl = thumb[0]. @ url;

			object.fullUrl = il.MEDIA::group.MEDIA::player. @ url;

			var description:Array=new Array();
			description = descript.split("|");
			object.description = description[0];
			description.shift();

			for (var j:int=0; j<description.length; j++)
			{
				regExpPattern = /(||\n)/g;
				description[j] = description[j].replace(regExpPattern,"");

				var array:Array = description[j].split(":");

				regExpPattern = /\s/g;
				array[0] = array[0].replace(regExpPattern,"");

				if (array[0] == "Author" || array[0] == "author" || array[0] == "AUTHOR")
				{
					authorString = array[1];
				}

				if (array[0] == "Publish" || array[0] == "publish" || array[0] == "PUBLISH")
				{
					publishString = array[1];
				}
			}

			if (! authorString)
			{
				authorString = author;

			}
			if (! publishString)
			{
				publishString = "";
			}

			object.author = authorString;
			object.publish = publishString;

			dataSet.push(object);
			//trace('dataset: ', dataSet);
			counter++;
			if (counter == amountToShow)
			{
				//trace("counter: ",counter);
				counter = 0;
				dispatchEvent(new Event(Event.COMPLETE));
			}


		}

		public static function addEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void
		{
			if (dispatch == null)
			{
				dispatch = new EventDispatcher();
			}
			dispatch.addEventListener(p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
		}

		public static function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false):void
		{
			if (dispatch == null)
			{
				return;
			}
			dispatch.removeEventListener(p_type, p_listener, p_useCapture);
		}

		public static function dispatchEvent(event:Event):void
		{
			if (dispatch == null)
			{
				return;
			}
			dispatch.dispatchEvent(event);
		}
	}
}