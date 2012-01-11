////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2010-2011 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:     LiveVideoDisplay.as
//
//  Author:  Paul Lacey (paul(at)ideum(dot)com)		 
//
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.

////////////////////////////////////////////////////////////////////////////////
package id.component
{
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.geom.*;
	import flash.ui.Mouse;
	import flash.net.*;
	
	import flash.display.Sprite;
	import flash.media.Camera;
	import flash.media.Video;
	
	import id.core.ApplicationGlobals;
	import id.core.TouchSprite;
	import gl.events.TouchEvent;
	import gl.events.GestureEvent;
	import id.core.TouchComponent;
	import id.element.LiveVideoParser;

	 /**
	 * <p>The LiveVideoDisplay component is the main component for the LiveVideoViewer module.  It contains all the neccessary display objects for the module.</p>
	 *
	 * <p>The LiveVideoViewer is a module that uses the the flash video API to create interactive  live camera feeds.  
	 * Multiple touch object windows can independently display individual live videos with different sizes and orientations.  
	 * The live video windows can be interactively moved around stage, scaled and rotated using multitouch gestures. Multitouch frame gestures can be 
	 * activated and deactivated using the module XML settings.</p>
	 *
	 * <strong>Import Components :</strong>
	 * <pre>
	 * LiveVideoParser
	 * TouchGesturePhysics
	 * </pre>
	 *
	 * <listing version="3.0">
	 * var livevideoDisplay:LiveVideoDisplay = new LiveVideoDisplay();
	 *
	 * 		livevideoDisplay.id = Number;
	 *
	 * addChild(liveVideoDisplay);</listing>
	 *
	 * @see id.module.LiveVideoViewer
	 * 
	 * @includeExample LiveVideoDisplay.as
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10.1
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	 
	public class LiveVideoDisplay extends TouchComponent
	{
		private var _id:int;
		private var _intialize:Boolean;
		
		//------ LiveVideo settings ------//
		private var livevideoWidth:Number;
		private var livevideoHeight:Number;
		private var livevideo_cam:String;
		private var bandwidth:int = 16384.
 		private var quality:int = 200; 
		private var fps:int = 60; 
		private var favorArea:Boolean = false; 
		
		// ----- interactive object settings --//
		private var window:TouchSprite;
		private var capture:TouchSprite;
		private var stageWidth:Number;
		private var stageHeight:Number;
		
		//---------frame settings--//
		private var frame:TouchSprite;
		private var frameDraw:Boolean = true;
		private var frameMargin:Number = 50;
		private var frameRadius:Number = 20;
		private var frameFillColor:Number = 0xFFFFFF;
		private var frameFillAlpha:Number = 0.5;
		private var frameOutlineColor:Number = 0xFFFFFF;
		private var frameOutlineStroke:Number = 2;
		private var frameOutlineAlpha:Number = 1;
		//----LiveVideo gestures---//
		private var livevideoDragGesture:Boolean = true;
		private var livevideoScaleGesture:Boolean = true;
		//----frame gestures---//
		private var frameDragGesture:Boolean = true;
		private var frameScaleGesture:Boolean = true;
		private var frameRotateGesture:Boolean = true;
				 
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *
		 * The Constructor.
		 * <pre>
		 * <strong>var livevideoDisplay:LiveVideoDisplay = new LiveVideoDisplay();
		 * addChild(livevideoDisplay);</strong></pre>
		 *
		 */
	
		public function LiveVideoDisplay()
		{
			super();
			blobContainerEnabled=true;
			visible=false;
		}

		/**
		 *
		 * The Disposal method for the module. It will clean out and nullify all children.
		 * <pre>
		 * <strong>livevideoDisplay.Dispose();</strong></pre>
		 *
		 */
		override public function Dispose():void
		{
			
				if (livevideoDragGesture)
				{
					capture.removeEventListener(GestureEvent.GESTURE_DRAG, livevideoTiltHandler);
				}
				if (livevideoScaleGesture)
				{
					capture.removeEventListener(GestureEvent.GESTURE_SCALE, livevideoScaleHandler);
				}

			//-----------------------------//
			if(frameDraw){
				if (frameDragGesture)
				{
					removeEventListener(GestureEvent.GESTURE_DRAG, objectDragHandler);
				}
				if (frameScaleGesture)
				{
					removeEventListener(GestureEvent.GESTURE_SCALE, objectScaleHandler);
				}
				if (frameRotateGesture)
				{
					removeEventListener(GestureEvent.GESTURE_ROTATE, objectRotateHandler);
				}
			}
			super.updateUI();
			
			if (parent)
			{
				parent.removeChild(this);
			}
		}

		override public function get id():int
		{
			return _id;
		}
		
		override public function set id(value:int):void
		{
			_id=value;
			createUI();
			commitUI();
		}

		override protected function createUI():void
		{
			var xml:XML = LiveVideoParser.settings;
			stageWidth=ApplicationGlobals.application.stage.stageWidth;
			stageHeight=ApplicationGlobals.application.stage.stageHeight;
			
			//--livevideo Settings--//
			livevideo_cam = xml.Content.Source[id].livevideoCam;
			livevideoWidth = xml.Content.Source[id].livevideoWidth;
			livevideoHeight = xml.Content.Source[id].livevideoHeight;
			quality = xml.Content.Source[id].livevideoQualtity;
			bandwidth = xml.Content.Source[id].livevideoBandwidth;
			favorArea = xml.Content.Source[id].livevideoFavorArea;
			fps = xml.Content.Source[id].livevideoFPS;
			
			//--Frame Style--//
			frameDraw = xml.FrameStyle.frameDraw == "true"?true:false;
			frameMargin = xml.FrameStyle.padding;
			frameRadius = xml.FrameStyle.cornerRadius;
			frameFillColor = xml.FrameStyle.fillColor1;
			frameFillAlpha = xml.FrameStyle.fillAlpha;
			frameOutlineColor = xml.FrameStyle.outlineColor;
			frameOutlineStroke = xml.FrameStyle.outlineStroke;
			frameOutlineAlpha = xml.FrameStyle.outlineAlpha;
			
			//-- Object gestures --//
			livevideoDragGesture=xml.LiveVideoGestures.drag == "true" ?true:false;
			livevideoScaleGesture=xml.LiveVideoGestures.scale == "true" ?true:false;
			
			//--Frame Gestures--//
			frameDragGesture=xml.FrameGestures.drag == "true" ?true:false;
			frameScaleGesture=xml.FrameGestures.scale == "true" ?true:false;
			frameRotateGesture=xml.FrameGestures.rotate == "true" ?true:false;
			
			//---------- build frame ------------------------//
			if(frameDraw)
			{							
				frame = new TouchSprite();
				addChild(frame);
			}
			
			// -- build video object ---//
				var camera:Camera = Camera.getCamera(livevideo_cam);
					camera.setQuality(bandwidth, quality);
					camera.setMode(livevideoWidth,livevideoHeight,fps,true); 
				var video:Video = new Video(livevideoWidth,livevideoHeight);
					video.attachCamera(camera);
					video.x =0;
					video.y = 0;
				addChild(video)
			
			// -- create capture layer --//
				capture = new TouchSprite();
					capture.graphics.beginFill(0xFFFFFF,0);
					capture.graphics.drawRect(0,0,livevideoWidth,livevideoHeight);
					capture.graphics.endFill();
				addChild(capture);
				
			//-- Add --//
				capture.blobContainerEnabled=true;
				capture.addEventListener(GestureEvent.GESTURE_DRAG_1, livevideoTiltHandler);
				capture.addEventListener(GestureEvent.GESTURE_SCALE_2, livevideoScaleHandler);
			
			//-- Add Event Listeners to frame----------------------------------//
			if(frameDraw){
				addEventListener(GestureEvent.GESTURE_DRAG, objectDragHandler);
				addEventListener(GestureEvent.GESTURE_SCALE, objectScaleHandler);
				addEventListener(GestureEvent.GESTURE_ROTATE, objectRotateHandler);
			}
			
		}

		override protected function commitUI():void
		{						
			width=livevideoWidth;
			height=livevideoHeight;
			
			if(!frameMargin)
			{
				frameMargin=0;
			}
			
			if(frameDraw)
			{		
				frame.graphics.lineStyle(frameOutlineStroke,frameOutlineColor,frameOutlineAlpha);
				frame.graphics.beginFill(frameFillColor,frameFillAlpha);
				frame.graphics.drawRoundRect(-frameMargin/2,-frameMargin/2,livevideoWidth+frameMargin,livevideoHeight+frameMargin,frameRadius,frameRadius);
				frame.graphics.endFill();
				
				width=livevideoWidth+frameMargin;
				height=livevideoHeight+frameMargin;
			}
			trace(width, height);
			
			if (! _intialize)
			{
				_intialize=true;
				visible=true;
			}
		}
		
		override protected function updateUI():void
		{
			if( (x-(frameMargin/2)>stageWidth) || (x+width-(frameMargin/2)<0) || (y-(frameMargin/2)>stageHeight) || (y+height-(frameMargin/2)<0) )
			{
				Dispose();
			}
		}

		// yaw and pitch control
		private function livevideoTiltHandler(e:GestureEvent):void 
		{
			//trace("video drag");
		}
		// scale control
		private function livevideoScaleHandler(e:GestureEvent):void 
		{
			//trace("video scale");
		}
		
		// -- window event handlers ----//
		private function objectDragHandler(event:GestureEvent):void
		{
			x += event.dx;
			y += event.dy;
		}
		private function objectScaleHandler(event:GestureEvent):void
		{
			scaleX += event.value;
			scaleY += event.value;
		}
		private function objectRotateHandler(event:GestureEvent):void
		{
			rotation += event.value;
		}
		
	}
}