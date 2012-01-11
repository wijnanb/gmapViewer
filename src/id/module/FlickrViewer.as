package id.module
{
	import flash.events.Event;
	import id.core.TouchComponent;
	import id.component.FlickrDisplay;
	import id.element.FlickrParser;
	import id.element.FlickrDisplayParser;
	import id.core.ApplicationGlobals;
		import flash.display.Bitmap;
	
	import id.element.TextDisplay;
	 
	public class FlickrViewer extends TouchComponent
	{
		private var flickrDisplay:FlickrDisplay;
		public static var COMPLETE:String = "complete";
		/**
		 *
		 * The DisplayObject is an Array of all display objects added to the stage.
		 * <pre>
		 * <strong>displayObject.push(flickrDisplay);</strong></pre>
		 *
		 */
		public var displayObject:Array = new Array();
		private var _id:int;
		private var count:int;
		private var idDisplayed:Array = new Array();
		private var idWaiting:Array = new Array();	
		private var _moduleName:String="";
		private var isLoaded:Boolean;
				public static var txt:TextDisplay;
		var klik;
		var textItem = 0;
			
		
		/**
		 *
		 * The Constructor.
		 * <pre>
		 * <strong>var flickrViewer:FlickrViewer = new FlickrViewer();
		 * addChild(flickrViewer);</strong></pre>
		 *
		 */
		public function FlickrViewer(id)
		{
			super();
			FlickrParser.addEventListener(Event.COMPLETE, onParseComplete);
			FlickrParser.settingsPath="config/Content.xml";
			FlickrDisplayParser.settingsPath = "config/FlickrViewer.xml";
			FlickrParser.settingsId = id;
			klik= id;
			txt = new TextDisplay();
			txt.multilined = false;
			txt.size = 15;
			txt.color = 0x000000;
			addChild(txt);
			
			//trace("klik klik ", klik);
			txt.text = "Images are loading..."; // vervang met image
					txt.x=(500-txt.textWidth)/2;
		
		}
		
		override public function get id():int
		{
			return _id;
		}
		override public function set id(value:int):void
		{
			_id=value;
			
		}
		
		
		private function onParseComplete(event:Event):void
		{
			FlickrParser.removeEventListener(Event.COMPLETE, onParseComplete);
			for (var ti = 0; ti < FlickrParser.dataSet.length; ti++){
			var flickrDisplay:FlickrDisplay = new FlickrDisplay();
			
			
				
			//trace('nummer', FlickrParser.dataSet.length);
			flickrDisplay.x = Math.random() *50; //positie individueel foto
			flickrDisplay.y = Math.random() *50;

			flickrDisplay.id = ti;
			addChild(flickrDisplay);

			}
			removeChild(txt);
			dispatchEvent(new Event(Event.COMPLETE));
			FlickrParser.dataSet = [];
		}
		
	}
}