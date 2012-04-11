package id.module
{
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	
	import id.component.ImageDisplay;
	import id.component.LaderIcoon;
	import id.core.ApplicationGlobals;
	import id.core.TouchComponent;
	import id.element.ImageDisplayParser;
	import id.element.ImageParser;
	import id.template.Magnifier;

	/**
	 * 
	 * <p>
	 * The ImageViewer is a module designed to display media content in the form of static images. Bitmap data files such as PNG, GIF and JPG along with associated meta data and basic formatting can be defined using a simple XML file.
	 * Multiple touch object images can be displayed on stage and each touch object can be manipulated using the TAP, DRAG, SCALE and ROTATE multitouch gestures.
	 * All multitouch gestures can be activated and deactivated using the module XML settings.</p>
	 *
	 * <strong>Imported Components :</strong>
	 * <pre>
	 * ImageDisplay
	 * ImageParser</pre>
	 * 
	 *
	 * <listing version="3.0">
	 * var imageViewer:ImageViewer = new ImageViewer();
	 *
	 * addChild(imageViewer);</listing>
	 *
	 * @see id.core.TouchComponent
	 * @see id.component.ImageDisplay
	 * 
	 * @includeExample ImageViewer.as
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10.1
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */

	public class ImageViewer extends TouchComponent
	{
		/**
		 *
		 * The DisplayObject is an Array of all display objects added to the stage.
		 * <pre>
		 * <strong>displayObject.push(imageDisplay);</strong></pre>
		 *
		 */
		public var displayObject:Array = new Array();
		public static var COMPLETE:String = "complete";
		private var imageDisplay:ImageDisplay;
		private var _id:int;
		private var _settingsPath:String = "";
		private var count:int;
		private var idDisplayed:Array = new Array();
		private var idWaiting:Array = new Array();
		public var moduleID:int;
		private var _moduleName:String = "";
		private var imageDisplayList:Array = new Array();
		private var isLoaded:Boolean;
		private var parserIsCalled:Boolean;
		private var markerNr;
		private var depth;
		private var counter:int;
		private var magnifier;
		private var LaadIcon:LaderIcoon = new LaderIcoon();

		/**
		 *
		 * The Constructor.
		 * <pre>
		 * <strong>var imageViewer:ImageViewer = new ImageViewer();
		 * addChild(imageViewer);</strong></pre>
		 *
		 */

		public function ImageViewer(idp , niveau, magnifi)
		{
			//trace('nieuwe imageviewer'à
			super();
			counter = 0;
			ImageParser.addEventListener(Event.COMPLETE,onParseComplete);
			ImageDisplayParser.addEventListener(Event.COMPLETE,onParseComplete);
			ImageParser.settingsPath = "FSCommand/Content.xml";
			ImageDisplayParser.settingsPath = "config/"+Global.environment+"/ImageViewer.xml";

			ImageParser.settingsId = idp;
			ImageParser.settingsNiveau = niveau;
			markerNr = idp;
			depth = niveau;
			magnifier = magnifi;
		}

		override public function get id():int
		{
			return _id;
		}
		override public function set id(value:int):void
		{
			_id = value;
		}

		protected function onParseComplete(event:Event):void
		{
			counter++;
			if (counter == 2)
			{
				ImageParser.removeEventListener(Event.COMPLETE, onParseComplete);
				for (var ti = 0; ti < ImageParser.amountToShow; ti++)
				{
					imageDisplay = new ImageDisplay(markerNr,depth,magnifier);
					imageDisplay.id = ti;
					imageDisplayList[ti] = imageDisplay;
					imageDisplayList[ti].scaleX = 0;
					imageDisplayList[ti].scaleY = 0;
					TweenMax.to(imageDisplayList[ti], 1.5, {scaleX:1, scaleY:1, shortRotation:{rotation:Math.floor(Math.random() * (1+25-(-25))) + (-25)}});
					addChild(imageDisplayList[ti]);
					
				}
			}
		}
	}
}