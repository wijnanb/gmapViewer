////////////////////////////////////////////////////////////////////////////////
//
//  OPEN EXHIBITS
//  Copyright 2011 Open Exhibits
//  All Rights Reserved.
//
//  Magnifier Viewer Class
//
//  File:     MagnifierViewer.as
//  Authors:    David Heath (davidh(at)ideum(dot)com) but is based on prior work by Chris Gerber at Ideum.
//
//  NOTICE: Open Exhibits permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
//
////////////////////////////////////////////////////////////////////////////////
package id.template
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import gl.events.GestureEvent;
	import gl.events.TouchEvent;
	
	import id.component.Content;
	import id.core.ApplicationGlobals;
	import id.core.TouchComponent;
	import id.core.TouchSprite;
	import id.core.id_internal;
	import id.element.ContentParser;
	import id.element.TextDisplay;
	import id.module.FlickrViewer;
	import id.utils.BitmapDataUtil;
	FlickrViewer;
	import id.module.ImageViewer;
	ImageViewer;
	import id.module.VideoViewer;
	VideoViewer;
	import id.module.YouTubeViewer;
	YouTubeViewer;
	import id.module.KeyViewer;
	KeyViewer;
	import id.module.GMapViewer;
	//import flash.events.GestureEvent;

	GMapViewer;
	/**
	     *  Constructor.
	     *  
	     * @langversion 3.0
	     * @playerversion AIR 1.5
	     * @playerversion Flash 10
	     * @playerversion Flash Lite 4
	     * @productversion GestureWorks 1.5
	     */
	public class MagnifierViewer extends TouchComponent
	{
		private var templates:Object;
		private var _id:int;
		private var count:int;
		private var moduleClass:Class;
		private var module:DisplayObject;
		private var txt:TextDisplay;
		public var loadingTimer:Timer;
		private var layoutCalled:Boolean;
		private var secondTime:Boolean;
		private var templateLoaded:Boolean;
		private var objects:Array = new Array();
		private var isTemplateLoaded:Boolean;
		private var moduleDictionary:Dictionary = new Dictionary();
		private var moduleID:Array = new Array();
		private var moduleNameArray:Array = new Array();
		private var magnifierGlasses:Array = new Array();
		private var contentHolders:Array = new Array();
		private var backgroundUrl:String;
		private var _moduleName:String = "";

		private var _background:Sprite;
		private var _backgroundLoader:Loader;

		private var _displayMask:Sprite;
		private var _magnifier:Magnifier;
		private var stageWidth:int;
		private var stageHeight:int;
		private var alreadyMoving:int = 0;

		private var container:TouchComponent;

		private var containerGlass:TouchComponent;

		public var containerContent:TouchSprite = new TouchSprite();
		private var contentHolder:Content;

		private var markerlijst:Array= new Array();
		private var counter = 0;
		private var naam:Number = new Number();
		private var eigenKlasse;

		private var aantalVergrootGlazen = Player.isAir ? 1 : 3; //number of magnifier glasses
		private var addMa:TouchSprite = new TouchSprite();
		private var addMag:TouchSprite = new TouchSprite();
		private var ring1:TouchSprite  = new TouchSprite();

		private var testHolder:TouchSprite = new TouchSprite();
		private var firstTime:Boolean = false;

		private var test:Boolean = true;
		private var markerLijst:Array = new Array();
		private var bt;
		private var vout = 0;
		private var zout = 0;
		private var prevNum:String = "";
		private var nummerArray:Array = new Array("","","","","","");
		private var nogGoed = 0;
		
		private var friction:Number = 0.9;
		private var dx:Number = 0;
		private var dy:Number = 0;
		private var updateLensTimer:Timer;
		
		public var myGMapViewer:GMapViewer;


		public function MagnifierViewer()
		{
			super();
			templates = ApplicationGlobals.dataManager.data.Template;
			createUI();
			commitUI();
			addChild(testHolder);
			addChild(containerContent);
		}
		
		public function reset():void {
			trace('MagnifierViewer.reset()');
			
			for(var i=0;i<contentHolders.length;i++) {
				contentHolders[i].deleteIt();
			}
			
			while (containerContent.numChildren > 0) {
 				containerContent.removeChildAt(0);
			}
			
			magnifierGlasses[0].x = stageWidth / 2;
			magnifierGlasses[0].y = stageHeight / 2;
			gui(0);
			magnifierGlasses[0].captureBitmap();
			var deKaart = container.getChildAt(0);
			deKaart.resetter();
			
			while(magnifierGlasses.length > 1)
			{
				removeChild(magnifierGlasses[magnifierGlasses.length - 1]);
    			magnifierGlasses.pop();
			}

			counter = 0;			//magnifiers added  = 0
			// put the icon for more magnifiers back in place...
			addChild(addMag);
			addChild(ring1);
			addChild(addMa);
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
		override protected function createUI():void
		{
			stageWidth = ApplicationGlobals.application.stage.stageWidth;
			stageHeight = ApplicationGlobals.application.stage.stageHeight;

		}

		override protected function commitUI():void
		{
			alreadyMoving = 0;
			width = ApplicationGlobals.application.stage.stageWidth;
			height = ApplicationGlobals.application.stage.stageHeight;
			stageWidth = ApplicationGlobals.application.stage.stageWidth;
			stageHeight = ApplicationGlobals.application.stage.stageHeight;

			backgroundUrl = templates.background;

			_background = new Sprite();
			_backgroundLoader = new Loader();
			_backgroundLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, backgroundLoader_completeHandler);
			_backgroundLoader.load(new URLRequest(backgroundUrl));
			_background.addChild(_backgroundLoader);
			//addChild(_background);

			container= new TouchComponent();
			addChild(container);

			containerGlass = new TouchComponent();
			addChild(containerGlass);

			txt = new TextDisplay();
			addChild(txt);

			loadingTimer = new Timer(500);
			loadingTimer.addEventListener(TimerEvent.TIMER, updateLoadingText);

			if (aantalVergrootGlazen - 1 > 0)
			{

				addMag.graphics.lineStyle(16, 0x222223, 1 , true);
				addMag.graphics.drawCircle(0, 0, 116);
				addChild(addMag);

				ring1.graphics.lineStyle(15,0x36A9E1, 1, true);
				ring1.graphics.drawCircle(0,0,94);


				addChild(ring1);

				addMa.graphics.beginFill(0xff0000, 0.000001);
				addMa.graphics.drawCircle(0, 0, 116);
				addMa.graphics.endFill();
				addChild(addMa);
				addMa.addEventListener(TouchEvent.TOUCH_UP,moreMagnifiers);
				addMa.addEventListener(TouchEvent.TOUCH_MOVE, moreMagnifiers1);
			}

			_magnifier = new Magnifier();
			magnifierGlasses[0] = _magnifier;
			magnifierGlasses[0].name = counter;

			txt.multilined = false;
			txt.color = 0xFFFFFF;
			callModuleClass();

		}

		private function moreMagnifiers1(e:TouchEvent)
		{
			if (counter < aantalVergrootGlazen - 1 && alreadyMoving == 0)
			{
				counter++;
				//trace('counter yeeah: ', counter);//_magnifier 
				magnifierGlasses[counter] = new Magnifier();
				magnifierGlasses[counter].name = counter;
				backgroundLoader_completeHandler(e);
				if (aantalVergrootGlazen - 1 == counter)
				{
					removeChild(addMa);
					removeChild(addMag);
					removeChild(ring1);
				}
			}
				 if (alreadyMoving==1)
				{
					//trace('already moving');
					magnifierGlasses[counter].x = e.localX;
					magnifierGlasses[counter].y = e.localY;
					naam = counter;
				//magnifierGlasses[naam].captureBitmap();
					gui(naam);
				}
				
		}
		
		private function moreMagnifiers(e:Event)
		{

			alreadyMoving = 0;
		}

		override protected function layoutUI():void
		{
			trace("layoutUI");
			
			layoutCalled = true;

			var moduleObject:Object = getModule(moduleDictionary);

			addToObjectsArray(moduleObject.displayObject);

			if (isTemplateLoaded)
			{
				addModulesToStage();

			}
		}

		override protected function updateUI():void
		{
			var moduleObject:Object = getModule(moduleDictionary);
			moduleObject.callNewObject(id);

		}

		private function backgroundLoader_completeHandler(event:Event):void
		{
			if (counter > 1)
			{
				alreadyMoving = 1;
			}

			_backgroundLoader.width = stageWidth;
			_backgroundLoader.height = stageHeight;
			magnifierGlasses[counter].minSize = 1;
			magnifierGlasses[counter].maxSize = 3;
			magnifierGlasses[counter].scaleAdjustable = false;

			if (firstTime == false)
			{
				magnifierGlasses[counter].x = stageWidth / 2;
				magnifierGlasses[counter].y = stageHeight / 3;
				firstTime = true;
			}
			else
			{
				magnifierGlasses[counter].x = 0;
				magnifierGlasses[counter].y = 0;
			}

			magnifierGlasses[counter].continuousRenderer = true;
			magnifierGlasses[counter].vectorRenderer = true;

			magnifierGlasses[counter].addEventListener(TouchEvent.TOUCH_DOWN, magnifier_touchDownHandler);
			magnifierGlasses[counter].addEventListener(TouchEvent.TOUCH_UP, magnifier_touchUpHandler);
			magnifierGlasses[counter].addEventListener(TouchEvent.TOUCH_MOVE,  magnifier_touchMove);
			magnifierGlasses[counter].addEventListener(GestureEvent.GESTURE_FLICK,flickGestureHandler);

			//  ============================;
			// now adding maginifier to parent, which in this case = Main document class.
			//  ============================

			addChild(magnifierGlasses[counter]);
			contentHolder = new Content(containerContent,magnifierGlasses,counter); // important --> calls content class!
			contentHolders[counter] = contentHolder;
			magnifierGlasses[counter].addChild(contentHolders[counter]);
		}

		public function gui(vt)
		{

			var pta:Point = new Point(magnifierGlasses[vt].x,magnifierGlasses[vt].y);
			var objectsa:Array = container.getObjectsUnderPoint(pta);
			//looks for objects under point, if the name is a number he found something
			for (var i = 0; i < objectsa.length; i++)
			{
				//trace(typeof objectsa[i]);
				if (isNaN(objectsa[i].name))
				{
					nogGoed = i;
					if (nogGoed == objectsa.length - 1)
					{
						if (nummerArray[vt] != "")
						{
							
							contentHolders[vt].outFocus(nummerArray[vt]);
							nummerArray[vt] = "";
						}
					}
				}
				else
				{
					// the magnifierglass doesn't have anything underneath it
					if (nummerArray[vt] != objectsa[i].name)
					{
						if (nummerArray[vt] != "")
						{
							contentHolders[vt].outFocus(nummerArray[vt]);
						}
						contentHolders[vt].inFocus(objectsa[i].name);
						nummerArray[vt] = objectsa[i].name;

					}

					nogGoed = 0;
				}
			}
		}

		private function magnifier_touchMove(event:TouchEvent):void
		{
			if (isNaN(naam))
			{
				//trace('niet goed');
			}
			else
			{
				naam = event.target.name;
				magnifierGlasses[naam].captureBitmap();
				gui(naam);
			}
		}

		private function magnifier_touchDownHandler(event:TouchEvent):void
		{
			//  ============================
			//  no longer need to pop magnifier to the top because it is a child to the parent class, Main.
			//  ============================
			naam = event.target.name;
			if (isNaN(naam))
			{
				//trace('niet goed');
			}
			else
			{
				//trace("hallo");
				magnifierGlasses[naam].startTouchDrag(-1, true, new Rectangle(0, 0,stageWidth,stageHeight));
			}

		}
		
		private function magnifier_touchUpHandler(event:TouchEvent):void
		{
			if (isNaN(naam))
			{
				//trace('niet goed up');
			}
			else
			{
				naam = event.target.name;
				magnifierGlasses[naam].stopTouchDrag(-1);
				gui(naam);
			}
		}
		
		private function flickGestureHandler(e:GestureEvent):void
		{
			dx = e.velocityX;
			dy = e.velocityY;
			addEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
		}

		private function onEnterFrameHandler(e:Event):void
		{
			if (magnifierGlasses[naam].x <= 0)
			{
				dx =  -  dx;
				magnifierGlasses[naam].x = 0;
			}
			if (magnifierGlasses[naam].x >= stageWidth)
			{
				dx =  -  dx;
				magnifierGlasses[naam].x = stageWidth;
			}
			if (Math.abs(dx) <= 1)
			{
				dx = 0;
				removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
			}
			magnifierGlasses[naam].x +=  dx;
			dx *=  friction;

			if (magnifierGlasses[naam].y <= 0)
			{
				dy =  -  dy;
				magnifierGlasses[naam].y = 0;
			}
			if (magnifierGlasses[naam].y >= stageHeight)
			{
				dy =  -  dy;
				magnifierGlasses[naam].y = stageHeight;

			}
			if (Math.abs(dy) <= 1)
			{
				dy = 0;
				removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
			}
			magnifierGlasses[naam].y +=  dy;
			dy *=  friction;
			try
			{
				magnifierGlasses[naam].captureBitmap();
			}
			catch (error:Error)
			{
				magnifierGlasses[naam].x = 5;
				magnifierGlasses[naam].y = 5;
				magnifierGlasses[naam].captureBitmap();
			}
		}
		
		private function updateLoadingText(event:TimerEvent):void
		{
			if (secondTime)
			{
				loadingTimer.reset();
				loadingTimer.stop();

				count++;

				if (count == templates.module.length())
				{
					isTemplateLoaded = true;
					txt.text = "The Template is complete.";
					txt.x=(stageWidth-txt.textWidth)/2;
					loadingTimer.removeEventListener(TimerEvent.TIMER, updateLoadingText);
					loadingTimer = null;
					TweenLite.to(txt, 1, { alpha:0, delay:1, onComplete:addModulesToStage});

					return;
				}
				else
				{
					callModuleClass();
				}
				return;
			}

			if (layoutCalled)
			{
				loadingTimer.reset();
				loadingTimer.start();
				txt.text = "The \"" + templates.module[count] + "\" module has loaded.";
				txt.x=(stageWidth-txt.textWidth)/2;
			}
			else
			{
				loadingTimer.reset();
				loadingTimer.stop();
				loadingTimer.start();
			}
			secondTime = true;
		}

		private function callModuleClass():void
		{
			layoutCalled = false;
			secondTime = false;
			loadingTimer.start();
			txt.text = "Loading the \"" + templates.module[count] + "\" module.";
			txt.x=(stageWidth-txt.textWidth)/2;
			txt.y=(stageHeight-txt.height)/2;
			moduleClass = getDefinitionByName("id.module." + templates.module[count]) as Class;

			trace( "callModuleClass " + moduleClass);
			
			module = new moduleClass(magnifierGlasses,this);
			
			if ( module is GMapViewer ) {
				myGMapViewer = GMapViewer(module);
			}
			
			//  ============================
			// modules are added to the touchComponent object "contatiner".  This is so that communication between the modules and this class is still transparent and clean.
			//  ============================
			container.addChild(module);
			
			//trace(container.numChildren);
			moduleName = templates.module[count];
			moduleDictionary[module] = templates.module[count];
			//trace(moduleDictionary[module]);
			
		}

		private function addModulesToStage():void
		{
			for (var i:int=0; i<objects.length; i++)
			{
				txt.Dispose();

				//  ============================
				// objects are added to the touchComponent object "contatiner".  This is so that communication between the modules and this class is still transparent and clean.
				//  ============================
				container.addChild(objects[i]);
				TweenLite.to(objects[i], 1, { alpha:1});
				
			}
			objects = [];
			updateLensTimer = new Timer(10,100);
			updateLensTimer.addEventListener(TimerEvent.TIMER, updateLens);
			updateLensTimer.start();
			

		}
		
		function updateLens(e:TimerEvent):void
		{

			if (isNaN(naam))
			{
				//trace('niet goed up');

			}
			else
			{
				magnifierGlasses[naam].captureBitmap();
			}
		}

		public function updateLenzen(delens):void
		{
			magnifierGlasses[delens].captureBitmap();
		}

		private function addToObjectsArray(value:Array):void
		{
			for (var i:int=0; i<value.length; i++)
			{
				objects.push(value[i]);
			}
		}

		private function getModule(value:Dictionary):Object
		{
			var moduleObject:Object = new Object();

			for (var object:Object in value)
			{
				if (value[object] == moduleName)
				{
					moduleObject = object;
				}
			}

			return moduleObject;
		}
		
		override public function Dispose():void {
			if ( myGMapViewer ) {
				myGMapViewer.Dispose();
				myGMapViewer = null;
			}
			
			trace(this + ".Dispose()");
			
			super.Dispose();
		}
	}
}