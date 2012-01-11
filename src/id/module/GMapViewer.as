package id.module
{
	import flash.events.Event;
	import id.element.MapParser;
	import id.core.TouchComponent;
	import id.component.GMapDisplay;
	import id.core.ApplicationGlobals;
	/**
	 * 
	 * <p>The GMapViewer is a module that uses the Google Maps API to create interactive mapping window.  
	 * Multiple touch object windows can independently display maps with different sizes and orientations.  
	 * Each map can have be centered on different coordinates, use different types and views.
	 * The map windows can be interactively moved around stage, scaled and rotated using multitouch gestures.  
	 * Additionally map type, latitude and longitude, zoom level, attitude and pitch
	 * can also be controls using multitouch gesture inside the mapping window.  All multitouch gestures
	 * can be activated and deactivated using the module XML settings.</p>
	 *
	 * <p><strong>Imported Components :</strong></p>
	 * <pre>
	 * GMapDisplay
	 * MapParser</pre>
	 *
	 * <listing version="3.0">
	 * var gmapViewer:GMapViewer = new GMapViewer();
	 *
	 * addChild(gmapViewer);</listing>
	 *
	 * @includeExample GMapViewer.as
	 * @see id.core.TouchComponent
	 * @see id.component.GMapDisplay
	 *
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10.1
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */

	public class GMapViewer extends TouchComponent
	{
		public var mapDisplay:GMapDisplay;
		
		
		/**
		 *
		 * The DisplayObject is an Array of all display objects added to the stage.
		 * <pre>
		 * <strong>displayObject.push(mapDisplay);</strong></pre>
		 * 
		 */
		public static var COMPLETE:String = "complete";
		public var displayObject:Array = new Array();
		
		private var _id:int;
		private var count:int;
		private var idDisplayed:Array = new Array();
		private var idWaiting:Array = new Array();		
		private var _moduleName:String="";
		private var isLoaded:Boolean;
		private var vergroot:Array = new Array();
		private var zichzelf;
		/**
		 *
		 * The Constructor.
		 * <pre>
		 * <strong>var gmapViewer:GMapViewer = new GMapViewer();
		 * addChild(gmapViewer);</strong></pre> 
		 * 
		 */

		public function GMapViewer(magnifier, eigen)
		{
			super();
			MapParser.settingsPath="config/GMapViewer.xml";
			MapParser.addEventListener(Event.COMPLETE,onParseComplete);
			vergroot = magnifier;
			zichzelf = eigen;
			
		}
		
		override public function get id():int
		{
			return _id;
		}
		override public function set id(value:int):void
		{
			_id=value;
		}
		
		override public function get moduleName():String
		{
			return _moduleName;
		}
		override public function set moduleName(value:String):void
		{
			_moduleName=value;
		}
		
		override protected function updateUI():void
		{
			callNewObject(id);
		}
		
		private function onParseComplete(event:Event):void
		{
			for (count=0; count<MapParser.amountToShow; count++)
			{
				addObject(count);
				//trace('count: ',count);
			}
			
			for (var id:int=count; id<MapParser.totalAmount; id++)
			{
				idWaiting.push(id);
				
			}
		}
		
		public function callNewObject(idNumber:int):void
		{
			for (var i:int=0; i<idDisplayed.length; i++)
			{
				if(idDisplayed[i]==idNumber)
				{
					idWaiting.push(idDisplayed[i]);
					idDisplayed.splice(i, 1);
				}				
			}
			
			addObject(idWaiting[0]);
			idWaiting.shift();
		}
		
		public function resetter(){
			mapDisplay.resetter();
			//trace('hallo');
		}
			
			
		private function addObject(id:int):void
		{
			mapDisplay=new GMapDisplay(vergroot, zichzelf);
			mapDisplay.id=id;
			mapDisplay.moduleName="GMapViewer";
			idDisplayed.push(id);
			
			displayObject.push(mapDisplay);
						
			if (parent is TouchComponent)
			{
				mapDisplay.alpha=0;
				
				if(count+1==MapParser.amountToShow)
				{
					isLoaded=true;
				}
				
				if(isLoaded)
				{
					super.layoutUI();
					displayObject=[];
				}
			}
			else
			{
				addChild(mapDisplay);
			
				if(count+1==MapParser.amountToShow)
				{
					isLoaded=true;
				}
				
				if(isLoaded)
				{
					dispatchEvent(new Event(GMapViewer.COMPLETE));
					displayObject=[];
				}
			}
		}

	}
}