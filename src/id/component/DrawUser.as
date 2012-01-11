package id.component
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import id.core.TouchSprite;
	import gl.events.TouchEvent;
	import gl.events.GestureEvent;
	import id.core.TouchComponent;
	import flash.geom.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.net.FileReference;
	import flash.events.Event;
	import flash.display.MovieClip;

	public class DrawUser extends TouchComponent
	{

		private var drawing:Boolean;
		private var isDrawing:Boolean = false;
		private var squareA:TouchSprite = new TouchSprite();
		private var line:TouchSprite = new TouchSprite();
		var myBitmapData:BitmapData = new BitmapData (1920, 1080, false, 0x00FFFFFF);
		var bytes:ByteArray;
		private var drawEase:Number; //acceleration for pencil (helps smooth lines)
		private var lastPoint:Point;
		private var drawGraphics:Graphics;
		private var huidigX;
		private var huidigY;
		private var drawClip:TouchSprite = new TouchSprite();

		public function DrawUser(widthScreenX:int,widthScreenY:int )
		{
		
			//this.addChild(drawClip); //you create a clip to draw into
		
			
			
			squareA.graphics.beginFill(0x36A9E1);
			squareA.graphics.drawCircle(400,600,10);
			squareA.graphics.endFill();
			//squareA.z = -600;
			
			addChild(drawClip); //you create a clip to draw into
			drawClip.z = -600;
			drawClip.graphics.beginFill(0xFFFFFF , 0.5);
			drawClip.graphics.drawRect(0,0,widthScreenX,widthScreenY);
			drawGraphics = drawClip.graphics; 
			drawClip.graphics.endFill();

			drawGraphics.lineStyle(4, 0x000000, 1); //set up line style for drawing
			
			drawing = false;//to start with
			drawClip.addEventListener(TouchEvent.TOUCH_DOWN,startDrawing);
			drawClip.addEventListener(TouchEvent.TOUCH_MOVE,drawIt);
			drawClip.addEventListener(TouchEvent.TOUCH_UP,stopDrawing);
			drawClip.addChild(line);
			
			drawEase = 0.3; 
			drawClip.addChild(squareA);
			//squareA.addEventListener(TouchEvent.TOUCH_DOWN,touchLayer);

		}
		private function onFrame(e:Event):void {
			var currentPoint = new Point(huidigX,huidigY); //get mouseX, mouseY
				//correct current point for easing:
				//the easing works in the usual way-find a point along the line between the 
				//lastPoint and the currentPoint. An easing factor of 0.5 puts the new point 
				//halfway between the currentPoint and the lastPoint. 
				currentPoint = new Point(lastPoint.x + (currentPoint.x-lastPoint.x)*drawEase, lastPoint.y+(currentPoint.y-lastPoint.y)*drawEase); //adjust for easing
				
				//draw the line from the lastPoint to the adjusted currentPoint:
				drawGraphics.lineTo(currentPoint.x, currentPoint.y); 
				
				//reset lastPoint to new value:
				lastPoint = currentPoint;
			
		}
		public function touchLayer(){
			
			//drawClip.z = -1000;
			
		}
		public function startDrawing(event:TouchEvent):void
		{
			if (!isDrawing) {
				isDrawing = true;
				lastPoint = new Point(event.localX, event.localY);
				drawGraphics.moveTo(lastPoint.x, lastPoint.y);
				addEventListener(Event.ENTER_FRAME, onFrame); //start the ENTER_FRAME handler
				huidigX = event.localX;
			huidigY = event.localY;
			}
			
		}
		
		public function drawIt(event:TouchEvent)
		{
			
			huidigX = event.localX;
			huidigY = event.localY;
			
		}

		public function stopDrawing(event:TouchEvent)
		{
			if (isDrawing) {
				isDrawing = false;
				removeEventListener(Event.ENTER_FRAME, onFrame); //stop the ENTER_FRAME handler
			}
			drawing = false;
			var rect:Rectangle = new Rectangle(0,0,squareA.width,squareA.height);
			myBitmapData.draw(squareA);
			bytes = myBitmapData.getPixels(rect);
			bytes.position = 0;
			//var saveFileRef:FileReference = new FileReference();
			//saveFileRef.save(bytest);

		}

	}

}