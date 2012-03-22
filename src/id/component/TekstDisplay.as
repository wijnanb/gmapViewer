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
	import flash.media.Video;
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
	import id.element.Outline;
	import id.element.QRCodeDisplay;
	import id.element.TekstDisplayParser;
	import id.element.TekstParser;
	import id.element.TextDisplay;
	import id.element.ThumbLoader;

	public class TekstDisplay extends TouchComponent
	{
		private var thumbnail:ThumbLoader;
		private var media:BitmapLoader;
		private var metadata:TouchComponent;
		private var controlBtns:ControlBtns;
		private var outline:Outline;
		private var backgroundGraphic:Graphic;
		private var title:TextField = new TextField  ;
		private var description:TextField = new TextField;
		private var author:TextField = new TextField;
		private var publish:TextDisplay;
		private var qrCode:QRCodeDisplay;

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

		private var friction:Number = 0.97;
		private var dx:Number = 0;
		private var dy:Number = 0;
		private static var _settingsId:String = "";
		private static var niveau:String = "";
		var square:Sprite = new Sprite();
		var square2:Sprite = new Sprite();
		private var noImage:Boolean = false;
		var magnifier;
		var mark:TouchSprite = new TouchSprite();
		var format:TextFormat = new TextFormat;
		var format2:TextFormat = new TextFormat;
		var format3:TextFormat = new TextFormat;
		var format4:TextFormat = new TextFormat;
		var TextDesc:TextField = new TextField;
				var stringTemp:String
		[Embed(source = "../../../assets/interface/videovlak_ds.png")]
		public var shade:Class;
		private var shaduw = new shade();
		var lineDrawing2:Shape = new Shape();
		
		
		protected var updateIntervalId:int;
		
		/**
		 *
		 * The Constructor.
		 * <pre>
		 * <strong>var textDisplay:ImageDisplay = new ImageDisplay();
		 * addChild(textDisplay);</strong></pre>
		 *
		 */
		 
		public function TekstDisplay(markerNr, depth, magnifi)
		{
			super();
			blobContainerEnabled=true;
			visible=false;
			_settingsId = markerNr;
			niveau = depth;
			magnifier = magnifi;
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
		 * <strong>textDisplay.Dispose();</strong></pre>
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
			var myFont:Font = new Neutra();
			format.align = "left";
			format.size = 18;
			format.font = myFont.fontName;
			format.bold = false;
			format.color = 0x000000;
			format.leftMargin = 20;
			format.rightMargin = 20;
			
			format2.align = "left";
			format2.size = 35;
			format2.font = myFont.fontName;
			format2.bold = true;
			format2.color = 0xffffff;
			format2.leftMargin = 20;
			format2.rightMargin = 20;
			
				format4.align = "left";
			format4.size = 30;
			format4.font = myFont.fontName;
			format4.bold = true;
			format4.color = 0xffffff;
			format4.leftMargin = 20;
			format4.rightMargin = 20;
			
			format3.align = "left";
			format3.size = 26;
			format3.font = myFont.fontName;
			format3.bold = true;
			format3.color = 0x000000;
			format3.leftMargin = 20;
			format3.rightMargin = 20;
			
			description.embedFonts = true;
			description.antiAliasType = AntiAliasType.ADVANCED;
			description.defaultTextFormat = format;
			
			
			author.embedFonts = true;
			author.antiAliasType = AntiAliasType.ADVANCED;
			author.defaultTextFormat = format2;
			
			
			title.embedFonts = true;
			title.antiAliasType = AntiAliasType.ADVANCED;
			title.defaultTextFormat = format3;
			
			// Style
			globalScale=TekstDisplayParser.settings.GlobalSettings.globalScale;
			scale=TekstDisplayParser.settings.GlobalSettings.scale;
			imagesNormalize=TekstDisplayParser.settings.GlobalSettings.imagesNormalize;
			infoPaddingNumber=TekstDisplayParser.settings.GlobalSettings.infoPadding;
			maxScale=TekstDisplayParser.settings.GlobalSettings.maxScale;
			minScale=TekstDisplayParser.settings.GlobalSettings.minScale;
			stageWidth=ApplicationGlobals.application.stage.stageWidth;
			stageHeight=ApplicationGlobals.application.stage.stageHeight;

			if (! maxScale||! minScale)
			{
				maxScale=2;
				minScale=.5;
			}

			infoBtnStyle=TekstDisplayParser.settings.ControlBtns;
			backgroundOutlineStyle=TekstDisplayParser.settings.BackgroundOutline;
			backgroundGraphicStyle=TekstDisplayParser.settings.BackgroundGraphic;
			titleStyle=TekstDisplayParser.settings.InfoText.TitleText;
			descriptionStyle=TekstDisplayParser.settings.InfoText.DescriptionText;
			authorStyle=TekstDisplayParser.settings.InfoText.AuthorText;
			publishStyle=TekstDisplayParser.settings.InfoText.PublishText;

			// Gestures
			if (TekstDisplayParser.settings.Gestures!=undefined)
			{
				dragGesture=TekstDisplayParser.settings.Gestures.drag=="true"?true:false;
				rotateGesture=TekstDisplayParser.settings.Gestures.rotate=="true"?true:false;
				scaleGesture=TekstDisplayParser.settings.Gestures.scale=="true"?true:false;
				doubleTapGesture=TekstDisplayParser.settings.Gestures.doubleTap=="true"?true:false;
				flickGesture=TekstDisplayParser.settings.Gestures.flick=="true"?true:false;
			}

			// Data
			if(niveau == "concept"){
			//trace ("bee bop" , TekstParser.settings.Content.Source.(@id==_settingsId).concept.text[id].url.length());
			if (TekstParser.settings.Content.Source.(@id==_settingsId).concept.text[id].url.length() > 0){
			mediaUrl=TekstParser.settings.Content.Source.(@id==_settingsId).concept.text[id].url;
			//trace('ide', mediaUrl);
			thumbUrl=TekstParser.settings.Content.Source.(@id==_settingsId).concept.text[id].url;
			noImage = false;
			}
			else{
				noImage = true;
				mediaUrl="assets/Interface/leeg.jpg";
				thumbUrl="assets/Interface/leeg.jpg";
				}
			qrCodeTag=TekstParser.settings.Content.Source.(@id==_settingsId).concept.text[id].qrCodeTag;
			titleText=TekstParser.settings.Content.Source.(@id==_settingsId).concept.text[id].title;
			descriptionText=TekstParser.settings.Content.Source.(@id==_settingsId).concept.text[id].description;
			authorText=TekstParser.settings.Content.Source.(@id==_settingsId).concept.text[id].author;
			publishText=TekstParser.settings.Content.Source.(@id==_settingsId).concept.text[id].publish;
			}
			if(niveau == "constructie"){
			mediaUrl=TekstParser.settings.Content.Source.(@id==_settingsId).constructie.text[id].url;
			//trace('op', mediaUrl);
			thumbUrl=TekstParser.settings.Content.Source.(@id==_settingsId).constructie.text[id].url;
			qrCodeTag=TekstParser.settings.Content.Source.(@id==_settingsId).constructie.text[id].qrCodeTag;
			titleText=TekstParser.settings.Content.Source.(@id==_settingsId).constructie.text[id].title;
			descriptionText=TekstParser.settings.Content.Source.(@id==_settingsId).constructie.text[id].description;
			authorText=TekstParser.settings.Content.Source.(@id==_settingsId).constructie.text[id].author;
			publishText=TekstParser.settings.Content.Source.(@id==_settingsId).constructie.text[id].publish;
			}
			if(niveau == "resultaat"){
			mediaUrl=TekstParser.settings.Content.Source.(@id==_settingsId).resultaat.text[id].url;
			//trace('resul', mediaUrl);
			thumbUrl=TekstParser.settings.Content.Source.(@id==_settingsId).resultaat.text[id].url;
			qrCodeTag=TekstParser.settings.Content.Source.(@id==_settingsId).resultaat.text[id].qrCodeTag;
			titleText=TekstParser.settings.Content.Source.(@id==_settingsId).resultaat.text[id].title;
			descriptionText=TekstParser.settings.Content.Source.(@id==_settingsId).resultaat.text[id].description;
			authorText=TekstParser.settings.Content.Source.(@id==_settingsId).resultaat.text[id].author;
			publishText=TekstParser.settings.Content.Source.(@id==_settingsId).resultaat.text[id].publish;
			}

			// Objects
			thumbnail = new ThumbLoader();
			media = new BitmapLoader();
			controlBtns = new ControlBtns();
			outline = new Outline();
			backgroundGraphic = new Graphic();

			
			publish = new  TextDisplay();
			qrCode = new QRCodeDisplay();

			metadata = new TouchComponent();

			// Add Children
			
			metadata.addChild(backgroundGraphic);
			if (qrCodeTag)
			{
				metadata.addChild(qrCode);
			}
			
			
			
			metadata.addChild(publish);
			metadata.addChild(thumbnail);
			
			
	
			addChild(shaduw);
			addChild(square);
			
			//addChild(square2);
			
			//addChild(controlBtns);
			addChild(metadata);
			addChild(media);
			
			addChild(title);
			if ( noImage ==  true){
				addChild(description);
				}
			
			addChild(outline);
			addChild(author);
			
			// Add Event Listeners
			if (dragGesture)
			{
				addEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
				addEventListener(TouchEvent.TOUCH_UP, touchUpHandler);
				addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
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

		override protected function commitUI():void
		{
			if (scale)
			{
				//media.scale=scale;
			}

			if (imagesNormalize)
			{
				media.pixels=imagesNormalize;
			}

			qrCode.string=qrCodeTag;

			controlBtns.styleList=infoBtnStyle;
			outline.styleList=backgroundOutlineStyle;
			backgroundGraphic.styleList=backgroundGraphicStyle;
/*			title.styleList=titleStyle;
			description.styleList=descriptionStyle;*/
			//author.styleList=authorStyle;
			publish.styleList=publishStyle;
			
			media.url=mediaUrl;
			thumbnail.url=thumbUrl;
	

			title.text=titleText;
			description.text=descriptionText;
			
			stringTemp = TekstParser.settings.Content.Source.(@id==_settingsId).name;
			author.text= stringTemp.toUpperCase();
			
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

			square.graphics.beginFill(0xffffff);
			//square.graphics.lineStyle(1,0xff0000, 1, true, "normal", "SQUARE", "mitter");
			square.graphics.drawRect(-media.width/2-50,-media.height/2-150,media.width+100, media.height+200);
			square.graphics.endFill();
			
			media.x=0-media.width/2;
			media.y=0-media.height/2;

			outline.width=media.width;
			outline.height=media.height;

			thumbnail.x=infoPadding;
			thumbnail.y=media.height-thumbnail.height-infoPadding;

			qrCode.x=media.width-qrCode.width-infoPadding;
			qrCode.y=media.height-qrCode.height-infoPadding;

			title.width =  800;
			
			if (noImage ==  true){
				//trace('nooo');
				
		
			
			title.x=-  media.width/2;;
			title.y= - media.height/2;
			
			//description.textWidth= 700;
			description.x= - media.width/2;
			description.y=- media.height/2 + 40;
			description.width = 800;
			description.wordWrap = true;
			shaduw.x = -media.width/2-63;
			shaduw.y = -media.height/2-164;
			shaduw.width = square.width+46;
			shaduw.height = square.height+50;
			publish.textWidth=media.width-(thumbnail.x+thumbnail.width)-(infoPadding*2);
			publish.x=thumbnail.x+thumbnail.width+infoPadding;
			publish.y=thumbnail.y+thumbnail.height-publish.height;

			}
			else{
				//trace('bleh');
			//title.textWidth=224;
			title.x=- media.width/2;
			title.y= 303/2-25;
			//description.textWidth=media.width-(infoPadding*2);
			description.x= - media.width/2;
			description.y=- media.height/2 - 20;
			shaduw.x = -square.width/2-10;
			shaduw.y = -square.height/2-70;
			shaduw.width = square.width+30;
			shaduw.height = square.height+70;
			publish.textWidth=media.width-(thumbnail.x+thumbnail.width)-(infoPadding*2);
			publish.x=thumbnail.x+thumbnail.width+infoPadding;
			publish.y=thumbnail.y+thumbnail.height-publish.height;
			}
			
			author.autoSize=  TextFieldAutoSize.LEFT;
			author.x=media.width/2 - author.width + 51;
			author.y=  -media.height/2 -120;
			author.background = true;
			author.backgroundColor = 0x222223;

			metadata.x=media.x;
			metadata.y=media.y;

			width=media.width;
			height=media.height;

			visible=true;
			controlBtns.visible=false;
			metadata.visible=false;
			
			
			
			/*square2.graphics.beginFill(0xffffff);
			square2.graphics.lineStyle(4,0x000000, 1, true, "normal", "SQUARE", "mitter");
			square2.graphics.drawRect(-imagesNormalize/2- 13 ,-height/2 - 9,imagesNormalize +26, height + 87);
			square2.graphics.endFill();*/
/*			
			square2.graphics.beginFill(0x000000);
			square2.graphics.drawRect(-imagesNormalize/2 -1 ,-303/2 +39,226, 226);
			square2.graphics.endFill();*/

			mark.graphics.clear();
			mark.graphics.lineStyle( 5 , 0x000000 );
			mark.graphics.moveTo( -10 , -10 );
			mark.graphics.lineTo( 10, 10);
			mark.graphics.moveTo( -10 , 10 );
			mark.graphics.lineTo( 10 , -10 );
			mark.x = media.width/2 +35;
			mark.y = -media.height/2 -165;
			addChild( mark );

			var touchWeg:TouchSprite = new TouchSprite( );
			touchWeg.graphics.beginFill(0xffffff, 0.0001);
			touchWeg.graphics.drawRect(media.width/2 +15,-media.height/2 -185, 40,40);
			touchWeg.graphics.endFill();
			addChild(touchWeg);

			
			TextDesc.embedFonts = true;
			TextDesc.antiAliasType = AntiAliasType.ADVANCED;
			TextDesc.defaultTextFormat = format4;
			TextDesc.x = media.width/2 - TextDesc.width + 51;
			TextDesc.y = -media.height/2 -67;
			TextDesc.autoSize = TextFieldAutoSize.LEFT;
			TextDesc.background = true;
			TextDesc.backgroundColor = 0x36A9E1;
			stringTemp = niveau;
			TextDesc.text = stringTemp.toUpperCase();
			addChild(TextDesc);
						
			lineDrawing2.graphics.clear();
			lineDrawing2.graphics.beginFill(0x36A9E1);
			//lineDrawing2.graphics.lineStyle( 5 , 0x000000 );
			lineDrawing2.graphics.moveTo(TextDesc.x,TextDesc.y+30); ///This is where we start drawing
			lineDrawing2.graphics.lineTo(TextDesc.x, TextDesc.y+55);
			
			lineDrawing2.graphics.lineTo(TextDesc.x + 30,TextDesc.y+30);
			lineDrawing2.graphics.lineTo(TextDesc.x,TextDesc.y+30);
			addChild(lineDrawing2);
			
			
			touchWeg.addEventListener(TouchEvent.TOUCH_UP, doeWeg);
			
		}
		private function doeWeg(e:Event){
	
			Dispose();
		}
		override protected function updateUI():void
		{
			width=media.width*scaleX;
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
			}

/*			if ( (x-(width/2)>stageWidth) || (x+(width/2)<0) || (y-(height/2)>stageHeight) || (y+(height/2)<0) )
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
			
			if ( Global.MAGNIFIER_ON_TOP ) {
				updateIntervalId = setInterval(onUpdate, 40); //25FPS
			}
		}
	
		private function touchMoveHandler(event:TouchEvent)
		{
			// strange behaviour: is only called when move has finished
		}
		
		protected function onUpdate():void {
			Global.viewer.updateAllMagnifiers();
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

		private function flickGestureHandler(event:GestureEvent):void
		{
			dx = event.velocityX;
			dy = event.velocityY;
			addEventListener(Event.ENTER_FRAME, flickEnterFrameHandler);
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
	/*		if (! information)
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
			}*/
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

		// Flick Physics EnterFrame Handler \\
		private function flickEnterFrameHandler(event:Event):void
		{
			if (x < -stageWidth/2)
			{
				dx =  -  dx;
				x = -stageWidth/2;
			}
			if (x > stageWidth - stageWidth/2)
			{
				dx =  -  dx;
				x = stageWidth - stageWidth;
				//trace(media.width / 2);
			}
			if (Math.abs(dx) <= 1)
			{
				dx = 0;
				removeEventListener(Event.ENTER_FRAME,flickEnterFrameHandler);
			}
			x +=  dx;
			dx *=  friction;

			if (y < -stageHeight/2)
			{
				dy =  -  dy;
				y = -stageHeight;
			}
			if (y > stageHeight - stageHeight/2)
			{
				dy =  -  dy;
				y = stageHeight - stageHeight/2;

			}
			if (Math.abs(dy) <= 1)
			{
				dy = 0;
				removeEventListener(Event.ENTER_FRAME,flickEnterFrameHandler);
			}
			y +=  dy;
			dy *=  friction;
		}
	}
}