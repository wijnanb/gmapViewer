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
	import id.component.StaticGMapDisplay;
	import flash.display.LoaderInfo;

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
		protected var templates:Object;
		protected var modules:Object;
		
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
		private var magnifiers:Array = new Array();
		private var contentHolders:Array = new Array();
		private var _moduleName:String = "";

		private var splashScreen:Sprite;
		
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

		private var numMagnifiers = Player.isAir ? 1 : 1; //number of magnifier glasses
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
		
		public var gMapViewer:GMapViewer;
		
		public var mapViewerLayer:Sprite;
		public var magnifierLayer:TouchSprite;
		public var splashScreenLayer:Sprite;


		public function MagnifierViewer()
		{
			super();
			
			width = stageWidth = ApplicationGlobals.application.stage.stageWidth;
			height = stageHeight = ApplicationGlobals.application.stage.stageHeight;
			
			splashScreenLayer = new Sprite();
			addChild(splashScreenLayer);
			
			mapViewerLayer = new Sprite();
			mapViewerLayer.graphics.beginFill(0xFFFFFF);
			mapViewerLayer.graphics.drawRect(0,0,stageWidth,stageHeight);
			addChild(mapViewerLayer);
			
			magnifierLayer = new TouchSprite();
			addChild(magnifierLayer);
			
			templates = ApplicationGlobals.dataManager.data.Template;
			initModules(templates[0]);
			
			splashScreen = new Sprite();
			var splashScreenLoader:Loader = new Loader();
			splashScreenLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
				(e.target as LoaderInfo).content.width = stageWidth;
				(e.target as LoaderInfo).content.height = stageHeight;
			}, false, 0, true);
			splashScreenLoader.load(new URLRequest(templates.background));
			splashScreen.addChild(splashScreenLoader);
			if ( !StaticGMapDisplay.DEBUG_COLLISION_DETECTION ) splashScreenLayer.addChild(splashScreen);
			
			for ( var i:int=0; i<numMagnifiers; i++ ) {
				var m:Magnifier = new Magnifier();
				m.x = Math.random() * width;
				m.y = Math.random() * height;
				
				m.minSize = 1;
				m.maxSize = 3;
				m.scaleAdjustable = false;
				m.continuousRenderer = true;
				m.vectorRenderer = true;
				m.captureTarget = mapViewerLayer;
				
				m.addEventListener(TouchEvent.TOUCH_DOWN, magnifier_touchDownHandler, false, 0, true);
				m.addEventListener(TouchEvent.TOUCH_UP, magnifier_touchUpHandler, false, 0, true);
				m.addEventListener(TouchEvent.TOUCH_MOVE,  magnifier_touchMove, false, 0, true);
				m.addEventListener(GestureEvent.GESTURE_FLICK,flickGestureHandler, false, 0, true);
				
				magnifiers.push( m );
				
				magnifierLayer.addChild( m );
			}
		}
		
		protected function initModules(template:Object):void {	
			modules = template.module;
			
			for ( var i:int=0; i<modules.length(); i++) {
				var moduleClass:Class = getDefinitionByName("id.module." + modules[i]) as Class;
				moduleDictionary[module] = modules[i];
				switch(String(modules[i])) {
					case "GMapViewer":
						gMapViewer = new GMapViewer();
						mapViewerLayer.addChild(gMapViewer);
						break;
				}
			}
		}
		
		public function reset():void {
			trace('MagnifierViewer.reset()');
			
			/*
			for(var i=0;i<contentHolders.length;i++) {
				contentHolders[i].deleteIt();
			}
			
			while (containerContent.numChildren > 0) {
 				containerContent.removeChildAt(0);
			}
			
			magnifiers[0].x = stageWidth / 2;
			magnifiers[0].y = stageHeight / 2;
			gui(0);
			magnifiers[0].captureBitmap();
			
			while(magnifiers.length > 1)
			{
				removeChild(magnifiers[magnifiers.length - 1]);
    			magnifiers.pop();
			}

			counter = 0;			
			addChild(addMag);
			addChild(ring1);
			addChild(addMa);
			*/
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

		override protected function commitUI():void
		{
			alreadyMoving = 0;
			width = ApplicationGlobals.application.stage.stageWidth;
			height = ApplicationGlobals.application.stage.stageHeight;
			stageWidth = ApplicationGlobals.application.stage.stageWidth;
			stageHeight = ApplicationGlobals.application.stage.stageHeight;

			splashScreen = new Sprite();
			var _backgroundLoader:Loader = new Loader();
			_backgroundLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, backgroundLoader_completeHandler, false, 0, true);
			_backgroundLoader.load(new URLRequest(templates.background));
			splashScreen.addChild(_backgroundLoader);
			if ( !StaticGMapDisplay.DEBUG_COLLISION_DETECTION ) addChild(splashScreen);

			container= new TouchComponent();
			addChild(container);

			containerGlass = new TouchComponent();
			addChild(containerGlass);

			txt = new TextDisplay();
			addChild(txt);

			loadingTimer = new Timer(500);
			loadingTimer.addEventListener(TimerEvent.TIMER, updateLoadingText);

			if (numMagnifiers - 1 > 0)
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
			magnifiers[0] = _magnifier;
			magnifiers[0].name = counter;

			txt.multilined = false;
			txt.color = 0xFFFFFF;
			callModuleClass();

		}

		private function moreMagnifiers1(e:TouchEvent)
		{
			if (counter < numMagnifiers - 1 && alreadyMoving == 0)
			{
				counter++;
				//trace('counter yeeah: ', counter);//_magnifier 
				magnifiers[counter] = new Magnifier();
				magnifiers[counter].name = counter;
				backgroundLoader_completeHandler(e);
				if (numMagnifiers - 1 == counter)
				{
					removeChild(addMa);
					removeChild(addMag);
					removeChild(ring1);
				}
			}
				 if (alreadyMoving==1)
				{
					//trace('already moving');
					magnifiers[counter].x = e.localX;
					magnifiers[counter].y = e.localY;
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

			(event.target as LoaderInfo).content.width = stageWidth;
			(event.target as LoaderInfo).content.height = stageHeight;
			magnifiers[counter].minSize = 1;
			magnifiers[counter].maxSize = 3;
			magnifiers[counter].scaleAdjustable = false;

			if (firstTime == false)
			{
				magnifiers[counter].x = stageWidth / 2;
				magnifiers[counter].y = stageHeight / 3;
				firstTime = true;
			}
			else
			{
				magnifiers[counter].x = 0;
				magnifiers[counter].y = 0;
			}

			magnifiers[counter].continuousRenderer = true;
			magnifiers[counter].vectorRenderer = true;

			magnifiers[counter].addEventListener(TouchEvent.TOUCH_DOWN, magnifier_touchDownHandler);
			magnifiers[counter].addEventListener(TouchEvent.TOUCH_UP, magnifier_touchUpHandler);
			magnifiers[counter].addEventListener(TouchEvent.TOUCH_MOVE,  magnifier_touchMove);
			magnifiers[counter].addEventListener(GestureEvent.GESTURE_FLICK,flickGestureHandler);

			//  ============================;
			// now adding maginifier to parent, which in this case = Main document class.
			//  ============================

			addChild(magnifiers[counter]);
			//contentHolder = new Content(containerContent,magnifiers,counter); // important --> calls content class!
			contentHolders[counter] = contentHolder;
			magnifiers[counter].addChild(contentHolders[counter]);
		}

		public function gui(vt)
		{
			var pta:Point = new Point(magnifiers[vt].x,magnifiers[vt].y);
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

		protected function magnifier_touchMove(event:TouchEvent):void
		{
			if ( gMapViewer ) {			
				if ( StaticGMapDisplay.DEBUG_COLLISION_DETECTION ) 		gMapViewer.mapDisplay.graphics.clear();
				
				for each( var magnifier:Magnifier in magnifiers) {
					//magnifier.captureBitmap();
					
					var target:Marker = gMapViewer.mapDisplay.collisionDetect(magnifier.x, magnifier.y);
					if ( target )	{
						// show content if not shown yet
						var contentId:int = target.contentId;
						magnifier.collapse(contentId);
					}
				}
			}
		}

		protected function magnifier_touchDownHandler(event:TouchEvent):void
		{
			(event.target as Magnifier).startTouchDrag(-1, true, new Rectangle(0, 0,stageWidth,stageHeight));
		}
		
		protected function magnifier_touchUpHandler(event:TouchEvent):void
		{
			(event.target as Magnifier).stopTouchDrag(-1);
		}
		
		private function flickGestureHandler(e:GestureEvent):void
		{
			dx = e.velocityX;
			dy = e.velocityY;
			//addEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
		}

		private function onEnterFrameHandler(e:Event):void
		{
			if (magnifiers[naam].x <= 0)
			{
				dx =  -  dx;
				magnifiers[naam].x = 0;
			}
			if (magnifiers[naam].x >= stageWidth)
			{
				dx =  -  dx;
				magnifiers[naam].x = stageWidth;
			}
			if (Math.abs(dx) <= 1)
			{
				dx = 0;
				removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
			}
			magnifiers[naam].x +=  dx;
			dx *=  friction;

			if (magnifiers[naam].y <= 0)
			{
				dy =  -  dy;
				magnifiers[naam].y = 0;
			}
			if (magnifiers[naam].y >= stageHeight)
			{
				dy =  -  dy;
				magnifiers[naam].y = stageHeight;

			}
			if (Math.abs(dy) <= 1)
			{
				dy = 0;
				removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
			}
			magnifiers[naam].y +=  dy;
			dy *=  friction;
			try
			{
				magnifiers[naam].captureBitmap();
			}
			catch (error:Error)
			{
				magnifiers[naam].x = 5;
				magnifiers[naam].y = 5;
				magnifiers[naam].captureBitmap();
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
			
			module = new moduleClass(magnifiers,this);
			
			if ( module is GMapViewer ) {
				gMapViewer = GMapViewer(module);
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
				magnifiers[naam].captureBitmap();
			}
		}

		public function updateLenzen(delens):void
		{
			magnifiers[delens].captureBitmap();
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
			if ( gMapViewer )			gMapViewer.Dispose();
			if ( container )			container.Dispose();
			if ( containerGlass )		containerGlass.Dispose();
			
			if ( addMa )				addMa.Dispose();
			if ( addMag )				addMag.Dispose();
			if ( ring1 )				ring1.Dispose();
			
			if ( testHolder )			testHolder.Dispose();
				
			if (loadingTimer)	loadingTimer.removeEventListener(TimerEvent.TIMER, updateLoadingText);
			addMa.removeEventListener(TouchEvent.TOUCH_UP,moreMagnifiers);
			addMa.removeEventListener(TouchEvent.TOUCH_MOVE, moreMagnifiers1);
			magnifiers[counter].removeEventListener(TouchEvent.TOUCH_DOWN, magnifier_touchDownHandler);
			magnifiers[counter].removeEventListener(TouchEvent.TOUCH_UP, magnifier_touchUpHandler);
			magnifiers[counter].removeEventListener(TouchEvent.TOUCH_MOVE,  magnifier_touchMove);
			magnifiers[counter].removeEventListener(GestureEvent.GESTURE_FLICK,flickGestureHandler);
			removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
			
			trace(this + ".Dispose()");
			
			super.Dispose();
		}
	}
}