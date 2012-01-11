package id.element
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLVariables;
		import id.element.TextDisplay;
		import flash.text.TextColorType;
			
	/**
	 * This is the FlickrParser class.
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	public class FlickrParser extends EventDispatcher
	{
		public static var settings:XML;
		public static var dataSet:Array = new Array();
		public static var txt:TextDisplay;
		public static var nummers:Array = new Array();
		private static var _settingsPath:String="";
		private static var _settingsId:String="";
		private static var settingsLoader:URLLoader;
		protected static var dispatch:EventDispatcher;
		private static var count:int = 0;
		public static var amountToShow:int;
		public static var totalAmount:int;
		private static var request:URLRequest;
		private static var vars:URLVariables = new URLVariables();
		private static var object:Object;
		public static var initialXml:XML;
		private static var type:Object;

		private static var authorString:String;
		private static var publishString:String;
		private static var regExpPattern:RegExp;
				

		public static function get settingsPath():String
		{
			return _settingsPath;
		}
		public static function set settingsId(value:String):void
		{
			//trace("geklikt: ",value);
			_settingsId = value;
		}
		public static function set settingsPath(value:String):void
		{
		/*if (_settingsPath==value)
			{
				dataSet = [];
			}*/
			count= 0;
			//dataSet = [];
			request=new URLRequest("http://api.flickr.com/services/rest/");
			settingsLoader = new URLLoader();
			settingsLoader.addEventListener(Event.COMPLETE, settingsLoader_completeHandler);
			_settingsPath=value;
			settingsLoader.load(new URLRequest(_settingsPath));
		}

		private static function settingsLoader_completeHandler(event:Event):void
		{
			settings=new XML(settingsLoader.data);
			
			amountToShow= 4;
			
			if(!amountToShow)
			{
				amountToShow=ImageParser.settings.Content.Source.length();
			}

			onFlickrParseComplete();

			settingsLoader.removeEventListener(Event.COMPLETE, settingsLoader_completeHandler);
			settingsLoader=null;
		}

		private static function onFlickrParseComplete():void
		{
			
				vars.method="flickr.photos.search";
				trace("keywords: ", settings.Content.Source[_settingsId].flickrTags);
				vars.tags= settings.Content.Source[_settingsId].flickrTags;
			vars.per_page = settings.Content.Source[_settingsId].flickrAmount;
			vars.api_key=settings.GlobalSettings.FlickrApiKey;
			request.data=vars;
			request.method=URLRequestMethod.POST;
			var groupLoader:URLLoader = new URLLoader();
			groupLoader.load(request);
			groupLoader.addEventListener(Event.COMPLETE, settingsParsed, false, 0, true);
		}

		private static function settingsParsed(event:Event):void
		{
			initialXml=XML(event.target.data);
			totalAmount=initialXml.photos.photo.length();
			
			//trace(initialXml);
			//trace("totalAmount", totalAmount);

			callUpInfo();
		}

		private static function callUpInfo():void
		{
			vars.method="flickr.photos.getInfo";
			vars.api_key=settings.GlobalSettings.FlickrApiKey;

		
			vars.photo_id=initialXml.photos.photo[count].@id;
			
			

			request.data=vars;
			request.method=URLRequestMethod.POST;
			var loader:URLLoader = new URLLoader();
			loader.load(request);
			loader.addEventListener(Event.COMPLETE,getInfo);
		}
		private static function getInfo(e:Event):void
		{
			var xml:XML=XML(e.target.data);
			var photo:XMLList=xml.photo;
			//trace(xml);
			object = new Object();
			object.title=photo.title;
			object.qrCodeTag=photo.urls.url;
			
			var description:Array=new Array();
			description=photo.description.split("|");
			object.description=description[0];
			description.shift();
			
			for (var i:int=0; i<description.length; i++)
			{
				regExpPattern=/(||\n)/g;
				description[i]=description[i].replace(regExpPattern,"");
				
				var array:Array=description[i].split(":");

				regExpPattern=/\s/g;
				array[0]=array[0].replace(regExpPattern,"");

				if (array[0]=="Author"||array[0]=="author"||array[0]=="AUTHOR")
				{
					authorString=array[1];
				}

				if (array[0]=="Publish"||array[0]=="publish"||array[0]=="PUBLISH")
				{
					publishString=array[1];
				}
			}
			
			if (! authorString)
			{
				authorString=photo.owner.@username;
				
			}
			if (! publishString)
			{
				publishString="";
			}
			
			object.author=authorString;
			object.publish=publishString;

			vars.method="flickr.photos.getSizes";
			vars.api_key=settings.GlobalSettings.FlickrApiKey;
			vars.photo_id=xml.photo.@id;
			request.data=vars;
			request.method=URLRequestMethod.POST;
			var loader1:URLLoader = new URLLoader();
			loader1.load(request);
			loader1.addEventListener(Event.COMPLETE, addSizes);
		}

		private static function addSizes(e:Event):void
		{
			var sizeXml:XML=XML(e.target.data);

			object.imgUrl=sizeXml.sizes.size[sizeXml.sizes.size.length()-3].@source;
			object.videoSource=null;

			var label:Object=sizeXml.sizes.size[sizeXml.sizes.size.length()-3].@label;
			if (label=="Mobile MP4")
			{
				object.imgUrl=sizeXml.sizes.size[sizeXml.sizes.size.length()-4].@source;
				object.videoSource=sizeXml.sizes.size[sizeXml.sizes.size.length()-2].@source;
			}

			dataSet.push(object);
			//trace([_settingsId],[count]);
			
			//dataSet[_settingsId][count];
			//dataSet[_settingsId] = object;
			//trace("wat zit er in data set: ", dataSet[_settingsId][0]);
			
			
			count++;
			
			if(!amountToShow)
			{
				amountToShow=totalAmount;
			}

			if (totalAmount==count)
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
			else
			{
				callUpInfo();
			}
		}

		public static function addEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void
		{
			if (dispatch==null)
			{
				dispatch = new EventDispatcher();
			}
			dispatch.addEventListener(p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
		}

		public static function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false):void
		{
			if (dispatch==null)
			{
				return;
			}
			dispatch.removeEventListener(p_type, p_listener, p_useCapture);
		}

		public static function dispatchEvent(event:Event):void
		{
			if (dispatch==null)
			{
				return;
			}
			dispatch.dispatchEvent(event);
		}
		
	}

}