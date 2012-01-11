﻿////////////////////////////////////////////////////////////////////////////////
//
//  OPEN EXHIBITS
//  Copyright 2011 Open Exhibits
//  All Rights Reserved.
//
//  Magnifier Class
//
//  File:     Magnifier.as
//  Author:   Chris Gerber  (Prior done work by Chris Gerber at Ideum).
//
//  NOTICE: Open Exhibits permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package id.template
{

import id.core.id_internal;
import id.core.TouchObject;
import id.core.TouchSprite;

import gl.events.GestureEvent;
import gl.events.TouchEvent;

import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.PixelSnapping;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import mx.utils.MatrixUtil;
import flash.utils.Dictionary;
import flash.filters.DropShadowFilter;
import id.core.ApplicationGlobals;
	import flash.events.TimerEvent;
	import flash.utils.Timer;


public class Magnifier extends TouchSprite
{
	
	private static var magnifiers:Array = [];
	private static var zeroPoint:Point = new Point(0, 0);
	private var sizeMagnifier;
	
	private var id:uint;
	
	private var _initialized:Boolean;
	
	private var _bitmap:Bitmap;
	private var _bitmapData:BitmapData;

	private var _transformation:Matrix;
	
	private var _background:Sprite;
	private var _foreground:Sprite;
	private var _mask:Sprite;
	
	public var invisibleSet:DisplayObject;
	
	private var shape:String;
	private var color:String;
	private var style:String;
	private var sprite:Sprite;

	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
	
    /**
     *  Constructor.
     *  
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */ 
	public function Magnifier()
	{
		super();
		
		id = magnifiers.length;
		//trace("length", id);
		magnifiers.push(this);
		
		blobContainerEnabled = true;
		shape=ApplicationGlobals.dataManager.data.Template.magnifier.shape;
		color=ApplicationGlobals.dataManager.data.Template.magnifier.color;
		style=ApplicationGlobals.dataManager.data.Template.magnifier.style;
		
		createUI();
		updateUI();
		
		addEventListener(GestureEvent.GESTURE_ROTATE, gestureRotateHandler);
		addEventListener(GestureEvent.GESTURE_SCALE, gestureScaleHandler);
		addEventListener(GestureEvent.RELEASE, gestureReleaseHandler);
		addEventListener("dragging", draggingHandler);
	}
	
	override public function Dispose():void
	{
		parent.removeChild(this);
		magnifiers.splice(magnifiers.indexOf(this), 1);
	}
	
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  Background Target
    //----------------------------------
	
	protected var _backgroundTarget:DisplayObject;
	private var _backgroundTargetTranslation:Point;
	
	/**
	 *
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
	 */

	public function get backgroundTarget():DisplayObject { return _backgroundTarget; }
	public function set backgroundTarget(object:DisplayObject):void
	{
		if(object == _backgroundTarget)
		{
			return;
		}
		
		_backgroundTarget = object;
		
		captureBackground();
	}
	
    //----------------------------------
    //  Background Data
    //----------------------------------
	
	protected var _backgroundData:BitmapData;
	
	public function get backgroundData():BitmapData { return _backgroundData; }
	public function set backgroundData(object:BitmapData):void
	{
		_backgroundData = object;
	}

    //----------------------------------
    //  CaptureTarget
    //----------------------------------
	
	protected var _captureTarget:DisplayObject;
	private var _ctt:Point;
	
	/**
	 *
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
	 */
	public function get captureTarget():DisplayObject { return _captureTarget; }
	public function set captureTarget(object:DisplayObject):void
	{
		_captureTarget = object;
		
		if(!parent)
		{
			return;
		}

		calculateTargetTranslation();
	}
	
    //----------------------------------
    //  Continuous Renderer
    //----------------------------------
	
	protected var _continuousRenderer:Boolean;
	
	/**
	 *
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
	 */
	public function get continuousRenderer():Boolean { return _continuousRenderer; }
	public function set continuousRenderer(value:Boolean):void
	{
		if(value == _continuousRenderer)
		{
			return;
		}
		
		_continuousRenderer = value;
		
		if(value)
		{
			attachListeners();
		}
		else
		{
			removeListeners();
		}
	}
	
    //----------------------------------
    //  Image Scale
    //----------------------------------
	
	private var _scale:Number = 2.0;
	
	/**
	 * @default 2.0
	 * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
	 */
	public function get scale():Number { return _scale; }
	public function set scale(value:Number):void
	{
		if(value == _scale)
		{
			return;
		}
		
		_scale = value;
		
		if(_initialized)
		{
			captureBitmap();
		}
	}

    //----------------------------------
    //  Image Scale Adjustable
    //----------------------------------
	
	private var _scaleAdjustable:Boolean = true;
	
	/**
	 * @default 2.0
	 * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
	 */
	public function get scaleAdjustable():Boolean { return _scaleAdjustable; }
	public function set scaleAdjustable(value:Boolean):void
	{
		_scaleAdjustable = value;
	}

    //----------------------------------
    //  Image Scale Max
    //----------------------------------

	private var _scaleMax:Number = 10.0;
	
	/**
	 * @default 10.0
	 * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
	 */
	public function get maxScale():Number { return _scaleMax; }
	public function set maxScale(value:Number):void
	{
		if(value == _scaleMax)
		{
			return;
		}
		
		_scaleMax = value;
		_scaleMax = Math.min(_scale, value);
		
		if(_initialized)
		{
			captureBitmap();
		}
	}

    //----------------------------------
    //  Image Scale Min
    //----------------------------------

	private var _scaleMin:Number = 1.0;
	
	/**
	 * @default 2.0
	 * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
	 */
	public function get minScale():Number { return _scaleMin; }
	public function set minScale(value:Number):void
	{
		if(value == _scaleMin)
		{
			return;
		}
		
		_scaleMin = value;
		_scaleMin = Math.min(_scale, value);
		
		if(_initialized)
		{
			captureBitmap();
		}
	}
	
    //----------------------------------
    //  Size
    //----------------------------------
	
	private var _size:Number = 1.0;
	
	/**
	 * @default 1.0
	 * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
	 */
	public function get size():Number { return _size; }
	public function set size(value:Number):void
	{
		if(value == _size)
		{
			return;
		}
		
		_size = value;
		
		if(_initialized)
		{
			updateUI();
			captureBitmap();
		}
	}
	
    //----------------------------------
    //  Scale Adjustable
    //----------------------------------
	
	private var _sizeAdjustable:Boolean = true;
	
	/**
	 * @default true
	 * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
	 */
	public function get sizeAdjustable():Boolean { return _sizeAdjustable; }
	public function set sizeAdjustable(value:Boolean):void
	{
		_sizeAdjustable = value;
	}
	
    //----------------------------------
    //  Scale Max
    //----------------------------------
	
	private var _sizeMax:Number = 2.0;
	
	/**
	 * @default 1.0
	 * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
	 */
	public function get maxSize():Number { return _sizeMax; }
	public function set maxSize(value:Number):void
	{
		if(value == _sizeMax)
		{
			return;
		}
		
		_sizeMax = value;
		_size = Math.min(_size, value);
		
		if(_initialized)
		{
			updateUI();
			captureBitmap();
		}
	}
	
	//----------------------------------
    //  Scale Min
    //----------------------------------
	
	private var _sizeMin:Number = 1.0;
	
	/**
	 * @default 1.0
	 * 
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
	 */
	public function get minSize():Number { return _sizeMin; }
	public function set minSize(value:Number):void
	{
		if(value == _sizeMin)
		{
			return;
		}
		
		_sizeMin = value;
		_size = Math.max(_size, value);
		
		if(_initialized)
		{
			updateUI();
			captureBitmap();
		}
	}
	
    //----------------------------------
    //  Vector Renderer
    //----------------------------------
	
	private var _vectorRenderer:Boolean;
	
	/**
	 *
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
	 */
	public function get vectorRenderer():Boolean { return _vectorRenderer; }
	public function set vectorRenderer(value:Boolean):void
	{
		_vectorRenderer = value;
		
		if(_initialized)
		{
			
			captureBitmap();
		}
	}

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

	override protected function initialize():void 
	{
				
		if(!_captureTarget)
		{
			_captureTarget = parent;
		}
		
		if(!_ctt)
		{
			calculateTargetTranslation();
		}
		
		if(!_initialized)
		{
			captureBitmap();
			_initialized = true;
		}
		
		if(_continuousRenderer)
		{
			attachListeners();
		}
	}

    //--------------------------------------------------------------------------
    //
    //  Methods: Public
    //
    //--------------------------------------------------------------------------
	
	public function refresh():void
	{

		this.invalidateTactualObjects();
	}

    //--------------------------------------------------------------------------
    //
    //  Methods: Bitmap Capturing
    //
    //--------------------------------------------------------------------------
	
	private function calculateTargetTranslation():void 
	{
		_ctt = _captureTarget.globalToLocal(zeroPoint);
	}
	
	public function captureBackground():void
	{
		
		destroyBackground();
		
		var transformation:Matrix = new Matrix();
		transformation = _backgroundTarget.transform.matrix.clone();
		transformation.scale(_scale, _scale);

		var size:Point = MatrixUtil.transformBounds
		(
		 	_backgroundTarget.width,
			_backgroundTarget.height,
			transformation
		);

		_backgroundData = new BitmapData(size.x, size.y);
		_backgroundData.draw
		(
		 	_backgroundTarget,
			transformation,
			null,
			null,
			null,
			false
		);
		
		transformation = null;
	}
	
	private function destroyBackground():void
	{
		if(!_backgroundData)
		{
			return;
		}
		
		_backgroundData.dispose();
		_backgroundData = null;
	}
	
	/**
	 *
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
	 */
	 	var ring1:Sprite = new Sprite();
		var ring2:Sprite = new Sprite();
		var vount = 0;
		
	public function captureBitmap():void
	{
		//vount++;
		//trace('ik ben aan het werk' , vount);
		destroyBitmap();
		
		var tempData:BitmapData;
		var transformation:Matrix = new Matrix();
		var translated:Point;

		if(_vectorRenderer)
		{
			//transformation = _captureTarget.transform.matrix.clone();
			
			transformation.scale(_scale, _scale);
		}
		
		var coordX:int = x * scale - width / 2;
		var coordY:int = y * scale - height / 2;
		
		var rect:Rectangle = new Rectangle
		(
		 	coordX,
			coordY,
			width,
			height
		);
		
		var size:Point = MatrixUtil.transformBounds
		(
		 	_captureTarget.width,
			_captureTarget.height,
			transformation
		);
		
		if (size.x > rect.right)
		{
			size.x = rect.right ;
		}
		
		if (size.y > rect.bottom)
		{
			size.y = rect.bottom;
		}
		
		visible = false;
		
		
		tempData = new BitmapData
		(
		 	size.x, //_captureTarget.width,
			size.y, //_captureTarget.height,
			true,
			0
		);
		
		tempData.draw
		(
		 
			_captureTarget,
			transformation,
			null,
			null,
			rect,
			false
			
		);


		_bitmapData = new BitmapData(width, height);
		
		if (_backgroundData)
		{
			_bitmapData.copyPixels
			(
			 	_backgroundData,
				rect,
				zeroPoint,
				null,
				null,
				true
			);
		}

		_bitmapData.copyPixels
		(
			tempData,
			rect,
			zeroPoint,
			null,
			null,
			true
		);


		visible = true;
		
		_bitmap = new Bitmap(_bitmapData, PixelSnapping.AUTO, true);
		_bitmap.scaleX = 1 / scaleX;
		_bitmap.scaleY = 1 / scaleY;
		
		_bitmap.x = -_bitmap.width / 2;
		_bitmap.y = -_bitmap.height / 2;
		
		_bitmap.mask = _mask;

		tempData.dispose();
		translated = null;
		
		if(!_vectorRenderer)
		{
			transformBitmap();
		}
		
		if (shape=="oval")
		{
			sprite=new Sprite();
			sprite.graphics.lineStyle(16, 0x222223, 1 , true);
			sprite.graphics.beginBitmapFill(_bitmap.bitmapData,_bitmap.transform.matrix,true,false);
			sprite.graphics.drawCircle(_bitmap.x+_bitmap.width/2,_bitmap.y+_bitmap.height/2,112);
			
			sprite.graphics.endFill();
			addChildAt(sprite,0);
			
		}
		else
			addChildAt(_bitmap, 0);
		transformation = null;
	}

	/**
	 *
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
	 */

	public function destroyBitmap():void
	{
		if (shape=="oval")
		{
			if (!sprite)
			{
				return;
			}
			removeChild(sprite);
		
			sprite.mask = null;
			sprite = null;
		}
		else
		{
			if(!_bitmap)
			{
				return;
			}
			
			removeChild(_bitmap);
		
			_bitmap.mask = null;
			_bitmap = null;
		}
		_bitmapData.dispose();
		_bitmapData = null;

	}
	
	private function transformBitmap():void
	{
		if(!_bitmap)
		{
			return;
		}
		
		_transformation = null;
		_transformation = applyMatrixTransformation
		(
			new Matrix(),
			_scale,
			width / 2,
			height / 2
		);
		
		_bitmap.transform.matrix = _transformation;
	}
	
    //--------------------------------------------------------------------------
    //
    //  Methods: Gesture Detection
    //
    //--------------------------------------------------------------------------
	
	private var _gesturing:Boolean;
	private var _gesture:String;
	private var _gestureCount:Object;
	private var _gestureTimeout:uint;
	
	private function initiateGestureDetection():void
	{
		if(_gesturing)
		{
			return;
		}
		
		_gesture = "";
		_gesturing = true;
		_gestureCount = {};
		
		_gestureTimeout = setTimeout(establishGestureResponse, 100);
	}
	
	private function establishGestureResponse():void
	{
		var gesture:String;
		var gestureValue:Number = 0;
		
		var value:Number;
		
		for(var k:String in _gestureCount)
		{
			value = Math.abs(_gestureCount[k]);
			if(value > gestureValue)
			{
				gesture = k;
				gestureValue = value;
			}
		}

		_gesture = gesture;
		_gestureTimeout = 0;
	}
	
	private function pushGestureValue(gestureName:String, value:Number):void
	{
		if(!_gestureCount.hasOwnProperty(gestureName))
		{
			_gestureCount[gestureName] = value;
			return;
		}
		
		_gestureCount[gestureName] += value;
	}
	
    //--------------------------------------------------------------------------
    //
    //  Methods: UI Creation
    //
    //--------------------------------------------------------------------------
	//var shade:DropShadowFilter = new DropShadowFilter();
	
	private function createUI():void
	{
		if (style=="handles")
		{
			if (color=="brass")
			{
				
				if (shape=="square")
				{
					_background = new Magnifier_Handles_Background();
					_foreground = new Magnifier_Handles_Foreground();
				}
				else
				{
					_background = new Magnifier_Oval_Background();
					_foreground = new Magnifier_Oval_Foreground();
				}
			}
			else
			{
				if (shape=="square")
				{
					_background = new Magnifier_Silver_Handles_Background();
					_foreground = new Magnifier_Silver_Handles_Foreground();
				}
				else
				{
					_background = new Magnifier_Oval_Silver_NoHandles_Background();
					_foreground = new Magnifier_Oval_Silver_NoHandles_Foreground();
				}
			}
			
		}
		else 
		{
			if (color=="brass")
			{
				if (shape=="square")
				{
					_background = new Magnifier_NoHandles_Background();
					_foreground = new Magnifier_NoHandles_Foreground();
				}
				else
				{
					_background = new Magnifier_Oval_Background();
					_foreground = new Magnifier_Oval_Foreground();
				}
			}
			else
			{
				if (shape=="square")
				{
					_background = new Magnifier_Silver_NoHandles_Background();
					_foreground = new Magnifier_Silver_NoHandles_Foreground();
				}
				else
				{
					_background = new Magnifier_Oval_Silver_NoHandles_Background();
					_foreground = new Magnifier_Oval_Silver_NoHandles_Foreground();
				}
			}
		}

		
		//addChild(_background);
		
		
		//addChild(_foreground);
		ring1.graphics.lineStyle(15,0x36A9E1, 1, true);
			ring1.graphics.drawCircle(0,0,94);
			
			ring2.graphics.lineStyle(15,0xFFFFFF, 1 );
			ring2.graphics.drawCircle(0,0,100);
			//addChild(ring2);
			addChild(ring1);
			
			var mark:Sprite = new Sprite( );
			mark.graphics.lineStyle( 1.2 , 0x000000 );
			mark.graphics.moveTo( -5 , -5 );
			mark.graphics.lineTo( 5 , 5 );
			mark.graphics.moveTo( -5 , 5 );
			mark.graphics.lineTo( 5 , -5 );
			mark.rotation = 45;
			addChild( mark );

		_mask = new Magnifier_Handles_Mask();
		addChild(_mask);
		var timer:Timer = new Timer(1000, 0);
   

 
	//addEventListener(Event.ENTER_FRAME, animateShadow);
	

/*	shade.color = 0x000000;
	shade.blurX = 4;
	shade.blurY = 4;
	shade.angle = 45;
	shade.distance = 2;
	shade.alpha = .5;*/
		//filters = [new DropShadowFilter(4.0, 45, 0x000000, 1.0, 4, 4, 0.5, 2)];

	}
	/*var blurX =0;
	var blurY = 0;
	var speed = 0.3;
	var goUp =false;
	function animateShadow(event:Event):void{
		
		if (blurX <30 && goUp ==false)
		{
			blurX += speed;
	 		blurY += speed;
			//trace('1x:', blurX,'y:', blurY);
	 	}
		if (blurX > 29){
			goUp = true;
			//trace
			}
		if (goUp == true){
			blurX -= speed;
	 		blurY -= speed;
			//trace('2 x:', blurX,'y:', blurY);
			if (blurX <5){
				goUp = false;
				}
			}
		filters = [new DropShadowFilter(4.0, 45, 0x000000, 1.0, blurX,blurY, 0.5, 2)];
	}*/

	private function updateUI():void
	{
		if(!parent)
			return;
		
		scaleX = size;
		scaleY = size;
	}
	
    //--------------------------------------------------------------------------
    //
    //  Methods: Event Management
    //
    //--------------------------------------------------------------------------
	
	private var _listenersAttached:Boolean;
	
	private function attachListeners():void
	{
		if(_listenersAttached)
		{
			return;
		}
		
		_listenersAttached = true;
		ValidationHelper.getInstance().registerCallback(captureBitmap);
	}
	
	private function removeListeners():void
	{
		if(!_listenersAttached)
		{
			return;
		}
		
		_listenersAttached = false;
		ValidationHelper.getInstance().unregisterCallback(captureBitmap);
	}
	
    //--------------------------------------------------------------------------
    //
    //  Methods: Private
    //
    //--------------------------------------------------------------------------
	
	private function applyMatrixTransformation(source:Matrix, scaleValue:Number, tx:Number, ty:Number):Matrix
	{
		source.tx -= tx;
		source.ty -= ty;
		
		source.scale(scaleValue, scaleValue);
		
		source.tx += tx;
		source.ty += ty;
		
		return source;
	}

	private function destroyDragHandler():void
	{
		var handle:int;
		
		try
		{
//			handle = unregisterDragHandler(this, dragHandler, true);
//			
//			_dragging = false;
//			_draggingBounds = null;
//			_draggingReference = null;
//			
//			_dragging_dX = 0;
//			_dragging_dY = 0;
//			
//			dispatchEvent(new TouchEvent("stopTouchDrag"));
		}
		catch(e:Error)
		{
			// suppress
		}
	}

    //--------------------------------------------------------------------------
    //
    //  Events: Dragging
    //
    //--------------------------------------------------------------------------
	
	private function draggingHandler(event:TouchEvent):void
	{
		
		
		if(!_continuousRenderer)
		{
			captureBitmap();
			
		}
	}

		
	

	/*
	private function startTouchDragHandler(event:TouchEvent):void
	{
	}
	
	private function stopTouchDragHandler(event:TouchEvent):void
	{
	}
	*/

    //--------------------------------------------------------------------------
    //
    //  Events: Gestures
    //
    //--------------------------------------------------------------------------
	
	private function gestureScaleHandler(event:GestureEvent):void
	{
		var newValue:Number = _size + event.value;
		
		_size =
			newValue < _sizeMin ? _sizeMin :
			newValue > _sizeMax ? _sizeMax :
			newValue
		;
		
		updateUI();
		captureBitmap();
	}
	
	private function gestureRotateHandler(event:GestureEvent):void
	{
		return;
		
		if(!_gesturing)
		{
			initiateGestureDetection();
			destroyDragHandler();
			
			return;
		}
		
		if(_gesture == "")
		{
			pushGestureValue(event.type, event.value);
			return;
		}
		
		if(_gesture != event.type)
		{
			return;
		}
		
		if(!_scaleAdjustable)
		{
			return;
		}
		
		var newValue:Number = _scale + event.value / 20 ;
		
		_scale =
			newValue < _scaleMin ? _scaleMin :
			newValue > _scaleMax ? _scaleMax :
			newValue
		;
		
		captureBitmap();
	}
	
	private function gestureReleaseHandler(event:GestureEvent):void
	{
		
		if(event.name != _gesture)
		{
			return;
		}
		
		if(_gestureTimeout)
		{
			clearTimeout(_gestureTimeout);
		}
		
		// reset 
		_gesture = "";
		_gesturing = false;
		_gestureCount = null;
		_gestureTimeout = 0;

			//trace('release');
	}
	
}
	
}

import id.managers.ValidationManager;
import id.managers.ValidationManagerHook;

class ValidationHelper extends ValidationManagerHook
{

	private static var instance:ValidationHelper;
	public static function getInstance():ValidationHelper
	{
		if(!instance)
			instance = new ValidationHelper();
		
		return instance;
	}

	private var callback:Function;

	public function ValidationHelper()
	{
		super();
	}
	
	public function registerCallback(f:Function):void
	{
		if(callback == f)
		{
			return;
		}
		
		callback = f;
		
		ValidationManager.getInstance().addHook(this);
	}
	
	public function unregisterCallback(f:Function):void
	{
		if(callback != f)
		{
			return;
		}
		
		callback = null;
		
		ValidationManager.getInstance().removeHook(this);
	}
	
	
	override public function validationComplete():void
	{		
		callback();
	}

}

