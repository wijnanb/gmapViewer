package id.module
{
	import flash.events.Event;
	import id.element.LiveVideoParser;
	import id.core.TouchComponent;
	import id.component.LiveVideoDisplay;
	import id.core.ApplicationGlobals;

	/**
	 * 
	 * <p>The LiveVideoViewer is a module that uses the the flash video API to create interactive  live camera feeds.  
	 * Multiple touch object windows can independently display individual live videos with different sizes and orientations.  
	 * The live video windows can be interactively moved around stage, scaled and rotated using multitouch gestures. Multitouch frame gestures can be 
	 * activated and deactivated using the module XML settings.</p>
	 *
	 * <p><strong>Imported Components :</strong></p>
	 * <pre>
	 * LiveVideoDisplay
	 * LiveVideoParser</pre>
	 *
	 * <listing version="3.0">
	 * var livevideoViewer:LiveVideoViewer = new LiveVideoViewer();
	 *
	 * addChild(livevideoViewer);</listing>
	 *
	 * @includeExample LiveVideoViewer.as
	 * @see id.core.TouchComponent
	 * @see id.component.LiveVideoDisplay
	 *
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10.1
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */

	public class LiveVideoViewer extends TouchComponent
	{
		private var livevideoDisplay:LiveVideoDisplay;


		/**
		 *
		 * The DisplayObject is an Array of all display objects added to the stage.
		 * <pre>
		 * <strong>displayObject.push(livevideoDisplay);</strong></pre>
		 * 
		 */
		public static var COMPLETE:String = "complete";
		public var displayObject:Array = new Array();

		private var _id:int;
		private var count:int;
		private var idDisplayed:Array = new Array();
		private var idWaiting:Array = new Array();
		private var _moduleName:String = "";
		private var isLoaded:Boolean;

		/**
		 *
		 * The Constructor.
		 * <pre>
		 * <strong>var livevideoViewer:LiveVideoViewer = new LiveVideoViewer();
		 * addChild(livevideoViewer);</strong></pre> 
		 * 
		 */

		public function LiveVideoViewer()
		{
			super();
			LiveVideoParser.settingsPath = "config/LiveVideoViewer.xml";
			LiveVideoParser.addEventListener(Event.COMPLETE,onParseComplete);
		}

		override public function get id():int
		{
			return _id;
		}
		override public function set id(value:int):void
		{
			_id = value;
		}

		override public function get moduleName():String
		{
			return _moduleName;
		}
		override public function set moduleName(value:String):void
		{
			_moduleName = value;
		}


		private function onParseComplete(event:Event):void
		{
			LiveVideoParser.removeEventListener(Event.COMPLETE, onParseComplete);
			livevideoDisplay=new LiveVideoDisplay();
			
			livevideoDisplay.id = id;
			livevideoDisplay.moduleName = "LiveVideoViewer";
			idDisplayed.push(id);
			addChild(livevideoDisplay);
			dispatchEvent(new Event(LiveVideoViewer.COMPLETE));

		}

	}
}