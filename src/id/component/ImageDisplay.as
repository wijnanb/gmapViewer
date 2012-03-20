package id.component
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Video;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.text.*;
	import flash.text.TextField;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import gl.events.GestureEvent;
	import gl.events.TouchEvent;
	
	import id.component.ControlBtns;
	import id.core.ApplicationGlobals;
	import id.core.TouchComponent;
	import id.core.TouchSprite;
	import id.element.BitmapLoader;
	import id.element.Graphic;
	import id.element.ImageDisplayParser;
	import id.element.ImageParser;
	import id.element.Outline;
	import id.element.QRCodeDisplay;
	import id.element.TextDisplay;
	import id.element.ThumbLoader;

	public class ImageDisplay extends TouchComponent
	{
		private var thumbnail:ThumbLoader;
		private var media:BitmapLoader;
		private var metadata:TouchComponent;
		private var controlBtns:ControlBtns;
		private var outline:Outline;
		private var backgroundGraphic:Graphic;
		private var title:TextDisplay;
		private var description:TextField = new TextField;
		private var author:TextField = new TextField;
		private var publish:TextDisplay;
		private var qrCode:QRCodeDisplay;
		var lineDrawing2:Shape = new Shape();
		private var _id:int;
		private var infoPadding:Number=10;
		private var intialize:Boolean;
		private var globalScale:Number;
		private var scale:Number;
		private var imagesNormalize:Number;
		private var infoPaddingNumber:Number;
		private var maxScale:Number;
		private var minScale:Number;
		private var infoBtnStyle:Object;
		private var backgroundOutlineStyle:Object;
		private var backgroundGraphicStyle:Object;
		private var titleStyle:Object;
		private var descriptionStyle:Object;
		private var authorStyle:Object;
		private var publishStyle:Object;
		private var mediaUrl:String;
		private var thumbUrl:String;
		private var qrCodeTag:String;
		private var titleText:String;
		private var descriptionText:String;
		private var authorText:String;
		private var publishText:String;
		private var dragGesture:Boolean=true;
		private var rotateGesture:Boolean=true;
		private var scaleGesture:Boolean=true;
		private var doubleTapGesture:Boolean=true;
		private var flickGesture:Boolean=true;
		private var information:Boolean;
		private var stageWidth:Number;
		private var stageHeight:Number;
		private var disposeArray:Array = new Array();

		private var friction:Number = 2;
		private var dx:Number = 0;
		private var dy:Number = 0;
		private static var _settingsId:String = "";
		private static var niveau:String = "";
		var square:Sprite = new Sprite();
		var square2:Sprite = new Sprite();
		//var square3:Sprite = new Sprite();
		var magnifier;
		var format:TextFormat = new TextFormat;
		var format2:TextFormat = new TextFormat;
		var stringTemp:String;
		var TextDesc:TextField = new TextField;
		var format4:TextFormat = new TextFormat;
		[Embed(source = "../../../assets/interface/foto_Tekstvlak.svg")]
		public var tekstImageClass:Class;
		private var guiImage = new tekstImageClass();
		[Embed(source = "../../../assets/interface/videovlak_ds.png")]
		public var shade:Class;
		private var shaduw = new shade();
		private var aantal = 0;
		
		protected var updateIntervalId:int;
		
		/**
		 *
		 * The Constructor.
		 * <pre>
		 * <strong>var imageDisplay:ImageDisplay = new ImageDisplay();
		 * addChild(imageDisplay);</strong></pre>
		 *
		 */
		 
		public function ImageDisplay(markerNr, depth, magnifi)
		{
			super();
			
			trace( "ImageDisplay constructor" );
			
			blobContainerEnabled=true;
			visible=false;
			_settingsId = markerNr;
			niveau = depth;
			magnifier = magnifi;
			//Security.allowDomain("*");
			//Security.allowInsecureDomain("*");
			Security.loadPolicyFile("http://193.190.10.77/crossdomain.xml");	
		}
		


		private function destroyChildren(child:*):void
		{
			if (! child)
			{
				return;
			}

			disposeArray.push(child);

			for (var idx:int=0; idx<child.numChildren; idx++)
			{
				var nested:* =child.getChildAt(idx);

				var sprite:Sprite=nested as Sprite;
				if (sprite)
				{
					nested.parent.removeChild(sprite);
					sprite=null;
					return;
				}
				var touchSprite:TouchSprite=nested as TouchSprite;
				if (touchSprite)
				{
					nested.parent.removeChild(touchSprite);
					touchSprite=null;
					return;
				}
				var shape:Shape=nested as Shape;
				if (shape)
				{
					nested.parent.removeChild(shape);
					shape=null;
					return;
				}

				var txtField:TextField=nested as TextField;
				if (txtField)
				{
					nested.parent.removeChild(txtField);
					txtField=null;
					return;
				}

				var video:Video=nested as Video;
				if (video)
				{
					nested.parent.removeChild(video);
					video=null;
					return;
				}

				var loader:Loader=nested as Loader;
				if (loader)
				{
					loader.unload();
					nested.parent.removeChild(loader);
					loader=null;
					return;
				}

				var bitmap:Bitmap=nested as Bitmap;
				if (bitmap)
				{
					bitmap.bitmapData.dispose();
					nested.parent.removeChild(bitmap);
					bitmap.bitmapData=null;
					bitmap=null;
					return;
				}

				nested.Dispose();
				nested=null;
			}
		}
		/**
		 *
		 * The Disposal method for the module. It will clean out and nullify all children.
		 * <pre>
		 * <strong>imageDisplay.Dispose();</strong></pre>
		 *
		 */
		override public function Dispose():void
		{
			for (var i:int=0; i<numChildren; i++)
			{
				destroyChildren(getChildAt(i) as DisplayObjectContainer);
			}

			for (var j:int=0; j<disposeArray.length; j++)
			{
				//disposeArray[j].Dispose();
				disposeArray[j]=null;
			}

			disposeArray=[];
			disposeArray=null;

			if (dragGesture)
			{
				removeEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
				removeEventListener(TouchEvent.TOUCH_UP, touchUpHandler);
				removeEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
			}

			if (doubleTapGesture)
			{
				removeEventListener(TouchEvent.TOUCH_DOUBLE_TAP, doubleTapHandler);
			}

			if (flickGesture)
			{
				removeEventListener(GestureEvent.GESTURE_FLICK, flickGestureHandler);
			}

			if (scaleGesture)
			{
				removeEventListener(GestureEvent.GESTURE_SCALE, scaleGestureHandler);
			}

			if (rotateGesture)
			{
				removeEventListener(GestureEvent.GESTURE_ROTATE, rotateGestureHandler);
			}

			removeEventListener(ControlBtns.INFO_CALL, informationHandler);

			clearInterval(updateIntervalId);
			
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
			// Style
			globalScale=ImageDisplayParser.settings.GlobalSettings.globalScale;
			scale=ImageDisplayParser.settings.GlobalSettings.scale;
			imagesNormalize=ImageDisplayParser.settings.GlobalSettings.imagesNormalize;
			infoPaddingNumber=ImageDisplayParser.settings.GlobalSettings.infoPadding;
			maxScale=ImageDisplayParser.settings.GlobalSettings.maxScale;
			minScale=ImageDisplayParser.settings.GlobalSettings.minScale;
			stageWidth=ApplicationGlobals.application.stage.stageWidth;
			stageHeight=ApplicationGlobals.application.stage.stageHeight;

			if (! maxScale||! minScale)
			{
				maxScale=2;
				minScale=.5;
			}

			infoBtnStyle=ImageDisplayParser.settings.ControlBtns;
			backgroundOutlineStyle=ImageDisplayParser.settings.BackgroundOutline;
			backgroundGraphicStyle=ImageDisplayParser.settings.BackgroundGraphic;
			titleStyle=ImageDisplayParser.settings.InfoText.TitleText;
			descriptionStyle=ImageDisplayParser.settings.InfoText.DescriptionText;
			authorStyle=ImageDisplayParser.settings.InfoText.AuthorText;
			publishStyle=ImageDisplayParser.settings.InfoText.PublishText;

			// Gestures
			if (ImageDisplayParser.settings.Gestures!=undefined)
			{
				dragGesture=ImageDisplayParser.settings.Gestures.drag=="true"?true:false;
				rotateGesture=ImageDisplayParser.settings.Gestures.rotate=="true"?true:false;
				scaleGesture=ImageDisplayParser.settings.Gestures.scale=="true"?true:false;
				doubleTapGesture=ImageDisplayParser.settings.Gestures.doubleTap=="true"?true:false;
				flickGesture=ImageDisplayParser.settings.Gestures.flick=="true"?true:false;
			}

			// Data
			if(niveau == "concept"){
			mediaUrl=ImageParser.settings.Content.Source.(@id==_settingsId).concept.image[id].url;
			//trace('ide', id);
			thumbUrl=ImageParser.settings.Content.Source.(@id==_settingsId).concept.image[id].url;
			qrCodeTag=ImageParser.settings.Content.Source.(@id==_settingsId).concept.image[id].qrCodeTag;
			titleText=ImageParser.settings.Content.Source.(@id==_settingsId).concept.image[id].title;
			descriptionText=ImageParser.settings.Content.Source.(@id==_settingsId).concept.image[id].description;
			authorText=ImageParser.settings.Content.Source.(@id==_settingsId).concept.image[id].author;
			publishText=ImageParser.settings.Content.Source.(@id==_settingsId).concept.image[id].publish;
			}
			if(niveau == "constructie"){
			mediaUrl=ImageParser.settings.Content.Source.(@id==_settingsId).constructie.image[id].url;
			//trace('op', mediaUrl);
			thumbUrl=ImageParser.settings.Content.Source.(@id==_settingsId).constructie.image[id].url;
			qrCodeTag=ImageParser.settings.Content.Source.(@id==_settingsId).constructie.image[id].qrCodeTag;
			titleText=ImageParser.settings.Content.Source.(@id==_settingsId).constructie.image[id].title;
			descriptionText=ImageParser.settings.Content.Source.(@id==_settingsId).constructie.image[id].description;
			authorText=ImageParser.settings.Content.Source.(@id==_settingsId).constructie.image[id].author;
			publishText=ImageParser.settings.Content.Source.(@id==_settingsId).constructie.image[id].publish;
			}
			if(niveau == "resultaat"){
			mediaUrl=ImageParser.settings.Content.Source.(@id==_settingsId).resultaat.image[id].url;
			//trace('resul', mediaUrl);
			thumbUrl=ImageParser.settings.Content.Source.(@id==_settingsId).resultaat.image[id].url;
			qrCodeTag=ImageParser.settings.Content.Source.(@id==_settingsId).resultaat.image[id].qrCodeTag;
			titleText=ImageParser.settings.Content.Source.(@id==_settingsId).resultaat.image[id].title;
			descriptionText=ImageParser.settings.Content.Source.(@id==_settingsId).resultaat.image[id].description;
			authorText=ImageParser.settings.Content.Source.(@id==_settingsId).resultaat.image[id].author;
			publishText=ImageParser.settings.Content.Source.(@id==_settingsId).resultaat.image[id].publish;
			}

			// Objects
			thumbnail = new ThumbLoader();
			media = new BitmapLoader();
			controlBtns = new ControlBtns();
			outline = new Outline();
			backgroundGraphic = new Graphic();
			title = new TextDisplay();
			publish = new TextDisplay();
			qrCode = new QRCodeDisplay();
			
			var myFont:Font = new Neutra();
			format.align = "left";
			format.size = 16;
			format.font = myFont.fontName;
			format.bold = true;
			format.color = 0x000000;
			format.leftMargin = 20;
			format.rightMargin = 20;


			format2.align = "left";
			format2.size = 26;
			format2.font = myFont.fontName;
			format2.bold = true;
			format2.color = 0xffffff;
			format2.leftMargin = 20;
			format2.rightMargin = 20;
			
			format4.align = "left";
			format4.size = 20;
			format4.font = myFont.fontName;
			format4.bold = true;
			format4.color = 0xffffff;
			format4.leftMargin = 20;
			format4.rightMargin = 20;
			
			author.embedFonts = true;
			author.antiAliasType = AntiAliasType.ADVANCED;
			author.defaultTextFormat = format2;


			metadata = new TouchComponent();

			// Add Children
			
			metadata.addChild(backgroundGraphic);
			if (qrCodeTag)
			{
				metadata.addChild(qrCode);
			}
			
			metadata.addChild(description);
			
			metadata.addChild(publish);
			metadata.addChild(thumbnail);
			
			
	
			addChild(shaduw);
			addChild(square);
			addChild(square2);
		
			//addChild(controlBtns);
			addChild(metadata);
			addChild(media);
			addChild(outline);
			//trace(height);
			addChild(description);
			addChild(author);
			// Add Event Listeners
			if (dragGesture)
			{
				addEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
				addEventListener(TouchEvent.TOUCH_UP, touchUpHandler);
				addEventListener(TouchEvent.TOUCH_UP, touchMoveHandler);
			}

			if (doubleTapGesture)
			{
				addEventListener(TouchEvent.TOUCH_DOUBLE_TAP, doubleTapHandler);
			}

			if (flickGesture)
			{
				addEventListener(GestureEvent.GESTURE_FLICK, flickGestureHandler);
			}

			if (scaleGesture)
			{
				addEventListener(GestureEvent.GESTURE_SCALE, scaleGestureHandler);
			}

			if (rotateGesture)
			{
				addEventListener(GestureEvent.GESTURE_ROTATE, rotateGestureHandler);
			}

			addEventListener(ControlBtns.INFO_CALL, informationHandler);
		}

var proxy:String = "http://maddoc.khlim.be/~dleen/Z33/gmapViewer/proxy.php?url=";
		override protected function commitUI():void
		{
			if (scale)
			{
				media.scale=scale;
			}

			if (imagesNormalize)
			{
				media.pixels=imagesNormalize;
			}

			qrCode.string=qrCodeTag;

			controlBtns.styleList=infoBtnStyle;
			outline.styleList=backgroundOutlineStyle;
			backgroundGraphic.styleList=backgroundGraphicStyle;
			title.styleList=titleStyle;
			///description.styleList=descriptionStyle;
			//author.styleList=authorStyle;
			publish.styleList=publishStyle;

			media.url= mediaUrl;
			trace(media.url);
			thumbnail.url=thumbUrl;

			title.text=titleText;
			description.text=descriptionText;
			if (id == 0){
			stringTemp = ImageParser.settings.Content.Source.(@id==_settingsId).name;
			author.text= stringTemp.toUpperCase();
			}
			publish.text=publishText;

			if (infoPaddingNumber)
			{
				infoPadding=infoPaddingNumber;
			}

			metadata.alpha=0;
		}

		override protected function layoutUI():void
		{
			if (! intialize)
			{
				if (globalScale)
				{
					scaleX=globalScale;
					scaleY=globalScale;
				}
				intialize=true;
			}

			backgroundGraphic.width=media.width;
			backgroundGraphic.height=media.height;

			media.x=0-media.width/2;
			media.y=0-media.height/2;

			outline.width=media.width;
			outline.height=media.height;

			thumbnail.x=infoPadding;
			thumbnail.y=media.height-thumbnail.height-infoPadding;

			qrCode.x=media.width-qrCode.width-infoPadding;
			qrCode.y=media.height-qrCode.height-infoPadding;

			title.textWidth=224;
			title.x=- 224/2;
			title.y= 303/2-25;
			shaduw.x = -249/2-5;
			shaduw.y = -303/2+11;
			shaduw.width = 249+15;
			shaduw.height = 303+38;
			
			guiImage.x = - 224/2;
			guiImage.y =  303/2-25;
			
			
			description.embedFonts = true;
			description.antiAliasType = AntiAliasType.ADVANCED;
			description.defaultTextFormat = format;
			description.width= 224;
			description.x=- 224/2;
			description.y= 303/2-25;
			
if (id == 0){
	
			author.autoSize=  TextFieldAutoSize.LEFT;
			author.x= (-249/2) - (author.width - 249/2) ;
			author.y=  (-303/2) - (author.height*2-15) ;
			author.background = true;
			author.backgroundColor = 0x222223;

}
			publish.textWidth=media.width-(thumbnail.x+thumbnail.width)-(infoPadding*2);
			publish.x=thumbnail.x+thumbnail.width+infoPadding;
			publish.y=thumbnail.y+thumbnail.height-publish.height;

			metadata.x=media.x;
			metadata.y=media.y;

			width=media.width;
			height=media.height;

			visible=true;
			controlBtns.visible=false;
			metadata.visible=false;
			
			square.graphics.beginFill(0xffffff);
			//square.graphics.lineStyle(1,0x000000, 1, true, "normal", "SQUARE", "mitter");
			square.graphics.drawRect(-imagesNormalize/2 -12,-303/2 +20,249, 310);
			square.graphics.endFill();
			
			//square2.graphics.beginFill(0xffffff);
/*			square3.graphics.lineStyle(4,0xff0000, 1, true, "normal", "SQUARE", "mitter");
			square3.graphics.drawRect(0,0,stageWidth, stageHeight);
			square3.graphics.endFill();*/
			
			square2.graphics.beginFill(0x000000);
			square2.graphics.drawRect(-imagesNormalize/2 -1 ,-303/2 +39,226, 226);
			square2.graphics.endFill();
			
			
			
			var mark:TouchSprite = new TouchSprite( );
			mark.graphics.lineStyle( 3 , 0x000000 );
			mark.graphics.moveTo( -5 , -5 );
			mark.graphics.lineTo( 5 , 5 );
			mark.graphics.moveTo( -5 , 5 );
			mark.graphics.lineTo( 5 , -5 );
			mark.x = 303/2-32;
			mark.y = -303/2+10;
			addChild( mark );
			
			var touchWeg:TouchSprite = new TouchSprite( );
			touchWeg.graphics.beginFill(0xffffff, 0.00001);
			touchWeg.graphics.drawRect(303/2-55, -303/2-10, 40,40);
			touchWeg.graphics.endFill();
			addChild(touchWeg);
			if (id == 0){
				trace(aantal);
			TextDesc.embedFonts = true;
			TextDesc.antiAliasType = AntiAliasType.ADVANCED;
			TextDesc.defaultTextFormat = format4;
			TextDesc.x = (-249/2) - (TextDesc.width - 249/2);
			TextDesc.y = (-303/2) - (TextDesc.height-15);
			TextDesc.autoSize = TextFieldAutoSize.LEFT;
			TextDesc.background = true;
			TextDesc.backgroundColor = 0x36A9E1;
			stringTemp = niveau;
			TextDesc.text = stringTemp.toUpperCase();
			addChild(TextDesc);
						
			lineDrawing2.graphics.clear();
			lineDrawing2.graphics.beginFill(0x36A9E1);
			//lineDrawing2.graphics.lineStyle( 5 , 0x000000 );
			lineDrawing2.graphics.moveTo(TextDesc.x + TextDesc.width ,TextDesc.y+TextDesc.height-2); ///This is where we start drawing
			lineDrawing2.graphics.lineTo(TextDesc.x + TextDesc.width, TextDesc.y+45);
			
			lineDrawing2.graphics.lineTo(TextDesc.x + TextDesc.width- 20,TextDesc.y +TextDesc.height-2);
			lineDrawing2.graphics.lineTo(TextDesc.x + TextDesc.width ,TextDesc.y +TextDesc.height-2);
			addChild(lineDrawing2);
			}
			touchWeg.addEventListener(TouchEvent.TOUCH_UP, doeWeg);
			
		}
		private function doeWeg(e:Event){
	
			Dispose();
		}
		override protected function updateUI():void
		{
			/*width=media.width*scaleX;
			height=media.height*scaleY;

			if (scaleX<1)
			{
				controlBtns.visible=false;
			}
			else
			{
				controlBtns.visible=true;
				controlBtns.scale=scaleX;
				controlBtns.x=media.width/2;
				controlBtns.y=media.height/2;
			}*/

			/*if ( (x-(width/2)>stageWidth) || (x+(width/2)<0) || (y-(height/2)>stageHeight) || (y+(height/2)<0) )
			{
				if (hasEventListener(Event.ENTER_FRAME))
				{
					removeEventListener(Event.ENTER_FRAME, flickEnterFrameHandler);
				}

				Dispose();
			}*/
		}

		private function touchDownHandler(event:TouchEvent):void
		{
			startTouchDrag(-1);
			parent.setChildIndex(this as DisplayObject,parent.numChildren-1);
			
			clearInterval(updateIntervalId);
			updateIntervalId = setInterval(onUpdate, 40); //25FPS
		}

		private function touchUpHandler(event:TouchEvent):void
		{
			stopTouchDrag(-1);
			
			clearInterval(updateIntervalId);
		}

		private function rotateGestureHandler(event:GestureEvent):void
		{
			rotation+=event.value;
		}

		private function doubleTapHandler(event:TouchEvent):void
		{
			TweenLite.to(this, .5, {scaleX:1, scaleY:1, onUpdate:updateUI});
		}
		
		private function touchMoveHandler(event:TouchEvent)
		{
			// strange behaviour: is only called when move has finished
			onUpdate();
		}
		
		protected function onUpdate():void {
			Global.viewer.updateAllMagnifiers();
		}
		
		var stageX =0;
		var stageY = 0;
		
		private function flickGestureHandler(event:GestureEvent):void
		{
			dx = event.velocityX;
			dy = event.velocityY;
			stageX = event.stageX;
			stageY = event.stageY;
			
			//trace('flick');
			//addEventListener(Event.ENTER_FRAME, flickEnterFrameHandler);
		}

		private function scaleGestureHandler(event:GestureEvent):void
		{
			scaleX+=event.value;
			scaleY+=event.value;

			scaleY=scaleY>Number(maxScale)?Number(maxScale):scaleY<Number(minScale)?Number(minScale):scaleY;
			scaleX=scaleX>Number(maxScale)?Number(maxScale):scaleX<Number(minScale)?Number(minScale):scaleX;

			updateUI();
		}

		private function informationHandler(event:Event):void
		{
			if (! information)
			{
				metadata.visible=true;
				information=true;
				TweenLite.to(media, .5, { alpha:0});
				TweenLite.to(metadata, .5, { alpha:1, onComplete:visibility});
			}
			else
			{
				media.visible=true;
				information=false;
				TweenLite.to(media, .5, { alpha:1});
				TweenLite.to(metadata, .5, { alpha:0, onComplete:visibility});
			}
		}

		private function visibility():void
		{
			if (! information)
			{
				metadata.visible=false;
			}
			else
			{
				media.visible=false;
			}
		}
		
/*		private function onAdded(e:Event):void


{


	world = parent as World;


	bounds = world.bounds;

}
*/
		// Flick Physics EnterFrame Handler \\
		private function flickEnterFrameHandler(event:Event):void
		{

		/*	
				if(tx + vx &gt; bounds.right - radius)

	{

	

		tx = bounds.right - radius;


		vx *= -1;


	}

	

	//	Collision Detection with left wall


	if(tx + vx &lt; bounds.left + radius) 	{


 		tx = bounds.left + radius;



 		vx *= -1;


	}



  	//	Collision Detection with floor


	if(ty + vy &gt; bounds.bottom - radius)


	{


		ty = bounds.bottom - radius;



		vy *= -1;


	}



	if(ty + vy &lt; bounds.top + radius)



	{



		ty = bounds.top + radius;


		vy *= -1;


	}

	tx += vx;


	ty += vy;

	x = tx;

	y = ty;
				
		/*if (rP.x < stageWidth/2)
			{
				dx =  -  dx;
				
				this.x = -stageWidth/2;
			
			}
			if (rP.x > stageWidth - stageWidth/2)
			{
				dx =  -  dx;
				this.x = stageWidth - stageWidth/2;
				
				//trace(media.width / 2);
			}
			if (Math.abs(dx) <= 1)
			{
				dx = 0;
				removeEventListener(Event.ENTER_FRAME,flickEnterFrameHandler);
			}
			this.x +=  dx;

			dx *=  friction;*/

			/*if (this.y < stageHeight/2)
			{
				dy =  -  dy;
				this.y = -stageHeight;
			}
			if (this.y> stageHeight - stageHeight/2)
			{
				dy =  -  dy;=
				this.y = stageHeight - stageHeight/2;

			}
			if (Math.abs(dy) <= 1)
			{
				dy = 0;
				removeEventListener(Event.ENTER_FRAME,flickEnterFrameHandler);
			}
			this.y +=  dy;
			dy *=  friction;*/
		}
	}
}