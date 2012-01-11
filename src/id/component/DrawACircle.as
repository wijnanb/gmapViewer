package id.component
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.LineScaleMode;
	import flash.display.CapsStyle;
	import flash.events.Event;
	import flash.utils.Timer;

	public class DrawACircle extends Sprite {

		//Circle Variables
		private var _speed:Number = 12;
		private var _timerTime:Number; //= (5000/360)*_speed; //19  <--- use to calculate based off how long you want it to take
		private var _theTimer:Timer; //= new Timer(_timerTime);
		private var _theCircle:Shape = new Shape();
		private var _start_num:Number = new Number; //for timing
		
		private var _xPos:Number;
		private var _yPos:Number;
		private var _centerX:Number = 0;
		private var _centerY:Number = 0;
		private var _angle:Number = 270;
		private var _startAngle:Number;
		private var _radius:Number = 27;
		
		public function DrawACircle(xt:int, yt:int):void {
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			_centerX = xt;
			_centerY = yt;
			//trace('hierzo');
		}
		
		private function init(e:Event):void {
			//trace('daarzo');

			//_timerTime = Math.round((5000/360)*_speed); //19
			_timerTime = 20;  //change this value or use the calculated _timerTime at the top
			_theTimer = new Timer(_timerTime);
			_theTimer.addEventListener("timer", drawIt);
			//Circle
			_theCircle.x = stage.stageWidth/2;
			_theCircle.y = stage.stageHeight/2;
			addChild(_theCircle);
			initCircle();
			//trace('_timerTime: ' + _timerTime);
		
		}

		//called to first create the circle, then called to create it again after the circle finishes drawing
		private function initCircle():void {
			var startTime:Date = new Date();
			_start_num = startTime.getTime();
			
			_theCircle.graphics.clear();
			_theCircle.graphics.lineStyle(6, 0xFF0000,1,false,LineScaleMode.NORMAL,CapsStyle.NONE);
			_startAngle = _angle;
			//trace('initCircle ' + _startAngle);
			_xPos = (Math.cos(deg2rad(_startAngle)) * _radius) + _centerX;
			_yPos = (Math.sin(deg2rad(_startAngle)) * _radius) + _centerY;
			_theCircle.graphics.moveTo (_xPos, _yPos);
			
			//if (_theTimer.currentCount != 0) {
				//_theTimer.reset();
				_theTimer.start();
			//}
			
		}
		//called by the timer to draw the circle
		private function drawIt (e:Event):void {
			//trace('drawIt, _angle: ' + _angle + '; _xPos:' + _xPos + '; _yPos: ' + _yPos);
			_angle += _speed + .1; //   TODO

			_xPos = (Math.cos(deg2rad(_angle)) * _radius) + _centerX;
			_yPos = (Math.sin(deg2rad(_angle)) * _radius) + _centerY;

			_theCircle.graphics.lineTo (_xPos,_yPos);

			if (_angle - 360 >= _startAngle) {
				_theTimer.stop(); //TODO
				//trace('drawIt _angle: ' + _angle);
				_angle = 270;
				//trace('drawIt _angle2: ' + _angle);
				var endTime:Date = new Date();
				var total_num:Number = endTime.getTime() - _start_num;
				//trace('Loop met, total time: ' + total_num);
				initCircle();
			}
		}
		//Helper utility to convert degrees to radians
		private function deg2rad (deg:Number):Number {
			return deg * Math.PI / 180;
		}
	}
}