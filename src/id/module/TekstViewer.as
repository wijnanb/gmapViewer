package id.module
{
	import flash.events.Event;
	import id.core.TouchComponent;
	import id.component.TekstDisplay;
	import id.element.TekstDisplayParser;
	import id.element.TekstParser;
	import id.core.ApplicationGlobals;
	import com.greensock.TweenMax;

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

	public class TekstViewer extends TouchComponent
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
		private var tekstDisplay:TekstDisplay;
		private var _id:int;
		private var _settingsPath:String="";
		private var count:int;
		private var idDisplayed:Array = new Array();
		private var idWaiting:Array = new Array();		
		public var moduleID:int;
		private var _moduleName:String="";
		private var tekstDisplayList:Array = new Array();
		private var isLoaded:Boolean;
		private var parserIsCalled:Boolean;
		private var markerNr;
		private var depth;
		private var counter:int;
		private var magnifier;
		/**
		 *
		 * The Constructor.
		 * <pre>
		 * <strong>var imageViewer:ImageViewer = new ImageViewer();
		 * addChild(imageViewer);</strong></pre>
		 *
		 */

		public function TekstViewer(idp , niveau , magnifi)
		{
			super();
			counter = 0;
			TekstParser.addEventListener(Event.COMPLETE,onParseComplete);
			TekstDisplayParser.addEventListener(Event.COMPLETE,onParseComplete);
			TekstParser.settingsPath = "FSCommand/Content.xml";
			TekstDisplayParser.settingsPath="config/TekstViewer.xml";
			
			TekstParser.settingsId = idp;
			TekstParser.settingsNiveau = niveau;
			markerNr = idp;
			depth = niveau;
			magnifier = magnifi;
			//trace('id:',idp)
		}
		
		/*public function get settingsPath():String
		{
			return _settingsPath;
		}
		
		public function set settingsPath(value:String):void
		{
			if(_settingsPath==value)
			{
				return;
			}
			
			_settingsPath=value
			
			ImageParser.settingsPath=value;
			ImageParser.addEventListener(Event.COMPLETE,onParseComplete);
		}*/
		
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
		counter++;
		if (counter == 2){
		TekstParser.removeEventListener(Event.COMPLETE, onParseComplete);
			//trace('amount:',ImageParser.amountToShow);
			for (var ti = 0; ti < TekstParser.amountToShow; ti++)
			{
			//trace('zoveel keer?', ti, 'depth: ' , depth, 'marker' , markerNr);
			tekstDisplay=new TekstDisplay(markerNr, depth, magnifier);
			tekstDisplay.id=ti;
				tekstDisplayList[ti] = tekstDisplay;
/*			tekstDisplayList[ti].scaleX = 0;
			tekstDisplayList[ti].scaleY = 0;
			*/
			tekstDisplayList[ti].rotation= Math.floor(Math.random() * (1+25-(-25))) + (-25);
		
			//TweenMax.to(tekstDisplayList[ti], 0.5, {shortRotation:{rotation:Math.floor(Math.random() * (1+25-0)) + 0}});
			//trace('id:',id);
			addChild(tekstDisplayList[ti]);
			
			}
		}
		}
	}
}