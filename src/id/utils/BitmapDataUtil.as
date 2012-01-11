////////////////////////////////////////////////////////////////////////////////
//
//  OPEN EXHIBITS
//  Copyright 2011 Open Exhibits
//  All Rights Reserved.
//
//  Magnifier Viewer Class
//
//  File:     MagnifierViewer.as
//  Author:    David Heath (davidh(at)ideum(dot)com)
//
//  NOTICE: Open Exhibits permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package id.utils
{
	
import flash.display.DisplayObjectContainer;
import flash.geom.Rectangle;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;

import mx.utils.MatrixUtil;
import flash.display.DisplayObject;
import flash.display.Bitmap;
import flash.display.BlendMode;

public class BitmapDataUtil
{


	/**
	 * @param region
	 *   The region within target for capturing.  Automated offset to stage specifications are performed.
	 *
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
	 */
	public static function CaptureRegion(
		
		target:DisplayObjectContainer,
		region:Rectangle,
		transformation:Matrix = null,
		cached:Boolean = false,
		depth:uint = 1,
		debug:DisplayObjectContainer = null
		
	):BitmapData
	{
		var regionOffset:Point = target.localToGlobal(new Point(0,0));
		var regionPoint:Point;
		var size:Point;

		var bitmapData:BitmapData = new BitmapData(region.width, region.height);
		
		var tempCollection:Array = [];
		var tempData:BitmapData;
		var tempTransform:Matrix;
		
		var bounds:Rectangle;
		
		var idx:int = 0;
		var layer:uint = 0;
		
		var container:DisplayObjectContainer = target;
		var child:DisplayObject;
		var childOffset:Point;
		var childRegion:Rectangle;
		
		//var childData:BitmapData;
		//var childPoint:Point = new Point(0, 0);
		
		region.offset(regionOffset.x, regionOffset.y);
		regionPoint = new Point(region.x, region.y);
		
		while(layer < depth)
		{
			for(idx=0; idx<container.numChildren; idx++)
			{
				child = container.getChildAt(idx);
				bounds = child.transform.pixelBounds;
				
				if(!bounds.intersects(region))
				{
					continue;
				}
				
				trace(child, "intersects!");
				
				tempTransform = child.transform.concatenatedMatrix;
				if (transformation)
				{
					tempTransform.concat(transformation);
					size = MatrixUtil.transformBounds
					(
						child.width,
						child.height,
						transformation
					);
				}
				else
				{
					size = new Point(child.width, child.height);
				}

				childOffset = child.globalToLocal(regionPoint);
				childRegion = region.clone();
				childRegion.offset(childOffset.x, childOffset.y);
				
				tempData = new BitmapData(size.x, size.y);
				tempData.draw(child, tempTransform, null, null, childRegion);
				
				tempCollection.push(tempData);
				
				bounds = null;
				size = null;
				tempTransform = null;
			}
			
			layer++;
		}
		
		trace("\ndrawing into bitmaps...");
		
		
		var debugBitmap:Bitmap;
		var debugPosition:Point = new Point();
		
		for(idx=tempCollection.length - 1; idx>=0; idx--)
		{
			if (debugBitmap)
			{
				debugPosition.x = debugBitmap.x;
				debugPosition.y = debugBitmap.y + debugBitmap.height + 10;
			}
			
			debugBitmap = new Bitmap(tempCollection[idx]);
			
			debugBitmap.width *= 0.25;
			debugBitmap.height *= 0.25;
			
			trace(debugBitmap.width, debugBitmap.height);
			
			debugBitmap.x = 0;
			debugBitmap.y = debugPosition.y;
			
			debug.addChild(debugBitmap);
		}
		
		return null;
	}
	
	public static function MergeBitmapDrawables
	(								
		targets:Array,
		transformations:Array,
		mergeAlpha:Boolean = true
		
	):BitmapData
	{
		var idx:uint;
		
		var target:DisplayObject;
		var targetBounds:Rectangle;
		var targetSize:Point;

		var transformed:Point;
		//var transformedSizes:Array = [];

		transformations ||= [] ;
		
		/*
		if
		(
			transformations.length != targets.length
		)
		{
			for(idx=0; idx<targets.length; idx++)
			{
				
			}
		}
		*/
		
		for(idx=0; idx<targets.length; idx++)
		{
			target = targets[idx] as DisplayObject;
			targetBounds = target.transform.pixelBounds;
			
			transformations[idx] ||= target.transform.concatenatedMatrix;
			
			transformed = MatrixUtil.transformSize
			(
			 	target.width,
				target.height,
				transformations[idx]
			);
			
			trace(target, target.width, target.height, transformed, targetSize);
			
			if(!targetSize)
			{
				targetSize = transformed.clone();
				continue;
			}
			
			if (targetSize.x < transformed.x)
			{
				targetSize.x = transformed.x
			}
			
			if (targetSize.y < transformed.y)
			{
				targetSize.y = transformed.y
			}
		}
		
		var merged:BitmapData = new BitmapData
		(
		 	targetSize.x,
			targetSize.y,
			mergeAlpha,
			mergeAlpha ? 0 : 0xFFFFFFFF
		);
		
		var tempData:BitmapData;
		
		for(idx=0; idx<targets.length; idx++)
		{
			merged.draw
			(
			 	targets[idx],
				transformations[idx],
				null,
				BlendMode.LAYER,
				null,
				true
			);
		}
		
		return merged;
	}
	
}

}