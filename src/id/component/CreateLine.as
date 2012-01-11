package id.component
{
	import flash.events.Event;
	import id.core.TouchComponent;
	import id.component.YouTubeDisplay;
	import id.element.YouTubeParser;
	import id.element.ContentParser;
	import id.core.ApplicationGlobals;
	import id.module.YouTubeViewer;
	import id.element.YouTubeDisplayParser;
	import flash.display.Sprite;
	import flash.geom.*;
	import flash.display.Shape;
	
	import com.google.maps.LatLng;
	import id.core.TouchSprite;
	
	
	public class CreateLine extends TouchComponent
	{
		private var line:Shape = new Shape();
private var x1;
private var y1;
		
		public function CreateLine()
		{

			addChild(line);
			// constructor code
			
		}

		public function updateLine(xt, yt, map, mLatLng, firstX, firstY)
		{
			//trace(line.name);
		
			line.graphics.clear();
			var point1 = map.fromLatLngToViewport(mLatLng);
			line.graphics.lineStyle(10,0x333333);
			//trace('xt: ', xt , ' yt: ' , yt);
//			trace('point1: ' , point1.x, ' point1.y ' , point1.y);
//			trace('point1: ' , firstX, ' point1.y ' , firstY);
			line.graphics.moveTo(point1.x - firstX,point1.y - firstY);
			line.graphics.curveTo( point1.x,  point1.y, xt, yt );


}


	}

}