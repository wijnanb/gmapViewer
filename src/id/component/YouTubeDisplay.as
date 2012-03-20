package id.component
{
	import flash.events.Event;
	import flash.display.DisplayObject;
		import flash.text.*;
	import id.core.ApplicationGlobals;
	import id.core.TouchComponent;
	import id.component.ControlBtns;
	import id.element.ThumbLoader;
	import id.element.Outline;
	import id.element.Graphic;
	import id.element.TextDisplay;
	import id.element.YouTubeParser;
	import id.element.YouTubePlayer;
	import id.element.QRCodeDisplay;
	import gl.events.TouchEvent;
	import gl.events.GestureEvent;
	import com.greensock.TweenLite;
	import id.element.YouTubeDisplayParser;
	import id.core.TouchSprite;
	import id.component.CreateLine;
	import flash.display.Sprite;
	import flash.geom.*;
	//import flash.filters.DropShadowFilter;
		import flash.events.TimerEvent;
	import flash.utils.Timer;
	 	import id.element.ContentParser;


	import com.google.maps.LatLng;
	import flash.display.Shape;

	
	/**
	 * <p>The YouTubeDisplay component is the main component for the YouTubeViewer module.  It contains all the neccessary display objects for the module.</p>
	 *
	 * <p>
	 * The YouTubeViewer is a module that uses the YouTube API to display video content from YouTube in the form of an interactive video player window. 
	 * Video can be streamed from a specified YouTube account along with associated meta data.  
	 * Youtube account preferences along with the formatting and basic appearance of the video windows can be defined from the module XML file.
	 * Multiple touch object images can be displayed on stage and each touch object can be interacted with using the TAP, DRAG, SCALE and ROTATE multitouch gestures.  
	 * All multitouch gestures can be activated and deactivated using the module XML settings.</p>
	 *
	 * <strong>Imported Components :</strong>
	 * <pre>
	 * YouTubePlayer
	 * BitmapLoader
	 * ControlBtns
	 * Outline
	 * Graphic
	 * TextDisplay
	 * QRCodeDisplay
	 * YouTubeParser
	 * TouchGesturePhysics
	 * </pre>
	 *
	 * <listing version="3.0">
	 * var youtubeDisplay:YouTubeDisplay = new YouTubeDisplay();
	 *
	 * youtubeDisplay.id = Number;
	 *
	 * addChild(youtubeDisplay);</listing>
	 *
	 * @see id.module.YouTubeViewer
	 * 
	 * @includeExample YouTubeDisplay.as
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10.1
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	public class YouTubeDisplay extends TouchComponent
	{
		private var media:YouTubePlayer;
		private var metadata:TouchComponent;
		private var thumbnail:ThumbLoader;
		private var controlBtns:ControlBtns;
		private var outline:Outline;
		private var backgroundGraphic:Graphic;
		private var title:TextDisplay;
		private var description:TextDisplay;
		private var author:TextDisplay;
		private var publish:TextDisplay;
		private var qrCode:QRCodeDisplay;
		private var container:TouchSprite;

		private var _id:int;
		private var infoPadding:Number = 10;
		private var intialize:Boolean;
		private var globalScale:Number;
		private var scale:Number;
		private var imagesNormalize:Number;
		private var infoPaddingNumber:Number;
		private var maxScale:Number = 2;
		private var minScale:Number = .5;
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
		private var dragGesture:Boolean = true;
		private var rotateGesture:Boolean = true;
		private var scaleGesture:Boolean = true;
		private var doubleTapGesture:Boolean = true;
		private var flickGesture:Boolean = true;
		private var videoSource:String;
		private var duration:String;
		private var information:Boolean;
		private var firstStart:Boolean;
		private var stageWidth:Number;
		private var stageHeight:Number;
		public var wireX;
		public var wireY;
		public var points:Array = new Array  ;
		public var pointNum:int = 100;
		public var canvas:Sprite = new Sprite  ;
		var square:Sprite = new Sprite();
		var square2:Sprite = new Sprite();
		var square3:Sprite = new Sprite();
		var square4:Sprite = new Sprite();
		var square6:Sprite = new Sprite();
		var square5:TouchSprite = new TouchSprite();
		var triangle:Sprite = new Sprite();
		var tijd:TextField = new TextField  ;
		
		var videoTextName:TextField = new TextField  ;
		var videoTextDesc:TextField = new TextField  ;
		
		var format:TextFormat = new TextFormat  ;
		var mark:TouchSprite = new TouchSprite( );
		public var loadingTime:Timer;
					
					
		[Embed(source = "../../../assets/interface/Qr_veld.svg")]
		public var iconQRClass:Class;
		private var iconQR = new iconQRClass();
		
		[Embed(source = "../../../assets/interface/videovlak_ds.png")]
		public var shadowVideo:Class;
		private var Svideo = new shadowVideo();
		//new Lines*****
		
		public var weg:Boolean = true;
//		public var line:CreateLine;
		//*****

		public var myMap;
		public var myMarkerLatLng:LatLng;
		public var firstX:Number;
		public var firstY:Number;
		private var magnifier;
		private var niveau;
		private var nr;
		var stringTemp:String
		var lineDrawing:Shape = new Shape();
		var lineDrawing2:Shape = new Shape();
		/**
		 *
		 * The Constructor.
		 * <pre>
		 * <strong>var youtubeDisplay:YouTubeDisplay = new YouTubeDisplay();
		 * addChild(youtubeDisplay);</strong></pre>
		 *
		 */
		public function YouTubeDisplay(magnifi, nv, tr)
		{
			super();
			blobContainerEnabled = true;
			visible = false;
			/*line = new CreateLine;
			addChild(line);*/
			niveau = nv;
			nr = tr; //id?
			magnifier =magnifi;
			//addEventListener(Event.ENTER_FRAME, onLoop, false, 0, true);

		}
/*public function updateIt(){

	line.updateLine(x, y, myMap, myMarkerLatLng, firstX, firstY);
	
	}*/

		/**
		 *
		 * The Disposal method for the module. It will clean out and nullify all children.
		 * <pre>
		 * <strong>youtubeDisplay.Dispose();</strong></pre>
		 *
		 */
		override public function Dispose():void
		{
			media.destroy();
			if (dragGesture)
			{
				removeEventListener(TouchEvent.TOUCH_DOWN,touchDownHandler);
				removeEventListener(TouchEvent.TOUCH_UP,touchUpHandler);
				removeEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
			}

			if (doubleTapGesture)
			{
				removeEventListener(TouchEvent.TOUCH_DOUBLE_TAP,doubleTapHandler);
			}

			if (flickGesture)
			{
				removeEventListener(GestureEvent.GESTURE_FLICK,flickGestureHandler);
			}

			if (scaleGesture)
			{
				removeEventListener(GestureEvent.GESTURE_SCALE,scaleGestureHandler);
			}

			if (rotateGesture)
			{
				removeEventListener(GestureEvent.GESTURE_ROTATE,rotateGestureHandler);
			}
			removeEventListener(YouTubePlayer.TIME,timeHandler);
/*			removeEventListener(ControlBtns.PLAY,play);
			removeEventListener(ControlBtns.PAUSE,pause);
			removeEventListener(ControlBtns.BACK,back);
			removeEventListener(ControlBtns.FORWARD,forward);

			removeEventListener(ControlBtns.INFO_CALL,informationHandler);*/
			removeEventListener(TouchEvent.TOUCH_UP, doeWeg);
			removeEventListener(TouchEvent.TOUCH_UP, playVideo);
			
			//parent.removeChild(this);
			if (parent)
			{
				media.destroy();
				parent.removeChild(this);
				weg = false;
			// dispatchEvent(new Event("deleteVideo"));
				//dispatchEvent(new Event(Event.COMPLETE));
				
			}

			super.updateUI();


		}

		override public function get id():int
		{

			return _id;
		}

		override public function set id(value:int):void
		{
			_id = value;
			createUI();
			commitUI();
		}

		override protected function createUI():void
		{
			// Style
			globalScale = YouTubeDisplayParser.settings.GlobalSettings.globalScale;
			scale = YouTubeDisplayParser.settings.GlobalSettings.scale;
			imagesNormalize = YouTubeDisplayParser.settings.GlobalSettings.imagesNormalize;
			infoPaddingNumber = YouTubeDisplayParser.settings.GlobalSettings.infoPadding;
			maxScale = YouTubeDisplayParser.settings.GlobalSettings.maxScale;
			minScale = YouTubeDisplayParser.settings.GlobalSettings.minScale;
			stageWidth = ApplicationGlobals.application.stage.stageWidth;
			stageHeight = ApplicationGlobals.application.stage.stageHeight;
			//trace('width: ', stageWidth , 'height: ', stageHeight);

			if (! maxScale || ! minScale)
			{
				maxScale = 2;
				minScale = .5;
			}

			infoBtnStyle = YouTubeDisplayParser.settings.ControlBtns;
			backgroundOutlineStyle = YouTubeDisplayParser.settings.BackgroundOutline;
			backgroundGraphicStyle = YouTubeDisplayParser.settings.BackgroundGraphic;
			titleStyle = YouTubeDisplayParser.settings.InfoText.TitleText;
			descriptionStyle = YouTubeDisplayParser.settings.InfoText.DescriptionText;
			authorStyle = YouTubeDisplayParser.settings.InfoText.AuthorText;
			publishStyle = YouTubeDisplayParser.settings.InfoText.PublishText;

			// Gestures
			if (YouTubeDisplayParser.settings.Gestures != undefined)
			{
				dragGesture = YouTubeDisplayParser.settings.Gestures.drag == "true" ? true:false;
				rotateGesture = YouTubeDisplayParser.settings.Gestures.rotate == "true" ? true:false;
				scaleGesture = YouTubeDisplayParser.settings.Gestures.scale == "true" ? true:false;
				doubleTapGesture = YouTubeDisplayParser.settings.Gestures.doubleTap == "true" ? true:false;
				flickGesture = YouTubeDisplayParser.settings.Gestures.flick == "true" ? true:false;
			}

			// Data
			//trace (dataSet[id].length);
			videoSource = YouTubeParser.dataSet[id].videoSource;
			mediaUrl = videoSource;
			duration = YouTubeParser.dataSet[id].duration;
			//trace( YouTubeParser.dataSet[id].duration);
			thumbUrl = YouTubeParser.dataSet[id].thumbUrl;
			qrCodeTag = YouTubeParser.dataSet[id].qrCodeTag;
			titleText = YouTubeParser.dataSet[id].title;
			descriptionText = YouTubeParser.dataSet[id].description;
			authorText = YouTubeParser.dataSet[id].author;
			publishText = YouTubeParser.dataSet[id].publish;

			media = new YouTubePlayer  ;
			controlBtns = new ControlBtns  ;
			outline = new Outline  ;
			backgroundGraphic = new Graphic  ;
			title = new TextDisplay  ;
			description = new TextDisplay  ;
			author = new TextDisplay  ;
			publish = new TextDisplay  ;
			thumbnail = new ThumbLoader  ;
			qrCode = new QRCodeDisplay  ;
			metadata = new TouchComponent  ;


			// Add Children
			

			/*metadata.addChild(title);
			metadata.addChild(description);
			metadata.addChild(author);
			metadata.addChild(publish);
			metadata.addChild(thumbnail);*/
			
			addChild( mark );
			
			addChild(square2);
			addChild(Svideo);
			
			addChild(square3);
			addChild(square4);
			addChild(triangle);
			
			
			square.visible = false;
			Svideo.visible = false;
			square2.visible = false;
			square3.visible = false;
			square4.visible = false;
			square5.visible = false;
			triangle.visible = false;
			tijd.visible = false;
			outline.visible = false;
			qrCode.visible = false;
			lineDrawing.visible =false;
			videoTextDesc.visible = false;
			videoTextName.visible = false;
			lineDrawing2.visible = false;
			iconQR.visible = false;
			
			//addChild(controlBtns);
			addChild(backgroundGraphic);
			addChild(metadata);
			
			addChild(media);
			
			
			//addChild(outline);
			addChild(tijd);
			addChild(square5);
			addChild(square);
			addChild(square6);
			

			// Add Event Listeners
			if (dragGesture)
			{
				addEventListener(TouchEvent.TOUCH_DOWN,touchDownHandler);
				addEventListener(TouchEvent.TOUCH_UP,touchUpHandler);
				addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);

			}

			if (doubleTapGesture)
			{
				addEventListener(TouchEvent.TOUCH_DOUBLE_TAP,doubleTapHandler);
			}

			if (flickGesture)
			{
				addEventListener(GestureEvent.GESTURE_FLICK,flickGestureHandler);
			}

			if (scaleGesture)
			{
				addEventListener(GestureEvent.GESTURE_SCALE,scaleGestureHandler);
			}

			if (rotateGesture)
			{
				addEventListener(GestureEvent.GESTURE_ROTATE,rotateGestureHandler);
			}
			addEventListener(YouTubePlayer.TIME,timeHandler);
			/*addEventListener(ControlBtns.PLAY,play);
			addEventListener(ControlBtns.PAUSE,pause);
			addEventListener(ControlBtns.BACK,back);
			addEventListener(ControlBtns.FORWARD,forward);
			
			addEventListener(ControlBtns.INFO_CALL,informationHandler);*/
		}
		override protected function commitUI():void
		{
			if (scale)
			{
				media.scale = scale;
			}

			if (imagesNormalize)
			{
				media.pixels = imagesNormalize;
			}

			qrCode.string = qrCodeTag;

			//controlBtns.type = "video";
			//controlBtns.styleList = infoBtnStyle;
			outline.styleList = backgroundOutlineStyle;
			backgroundGraphic.styleList = backgroundGraphicStyle;
			title.styleList = titleStyle;
			description.styleList = descriptionStyle;
			author.styleList = authorStyle;
			publish.styleList = publishStyle;

			media.url = mediaUrl;
			thumbnail.url = thumbUrl;

			title.text = titleText;
			description.text = descriptionText;
			author.text = authorText;
			publish.text = publishText;

			if (infoPaddingNumber)
			{
				infoPadding = infoPaddingNumber;
			}

			metadata.alpha = 0;
		}
var speed = 0;
//var shade:DropShadowFilter = new DropShadowFilter();
var tijdMS;
		override protected function layoutUI():void
		{
			controlBtns.width = media.width;

			if (! intialize)
			{
				if (globalScale)
				{
					scaleX = globalScale;
					scaleY = globalScale;
				}

				intialize = true;
				visible = true;
			}

			backgroundGraphic.width = media.width;
			backgroundGraphic.height = media.height;
			backgroundGraphic.x = 0 - backgroundGraphic.width / 2;
			backgroundGraphic.y = 0 - backgroundGraphic.height / 2;

			media.x = backgroundGraphic.x;
			media.y = backgroundGraphic.y;

			outline.width = media.width;
			outline.height = media.height;

			thumbnail.x = infoPadding;
			thumbnail.y = media.height - thumbnail.height - infoPadding;

			qrCode.x = qrCode.width +13;
			qrCode.y = qrCode.height -20;
			qrCode.scaleX = 1.5;
			qrCode.scaleY = 1.5;
			
			title.textWidth = media.width - infoPadding * 2;
			title.x = infoPadding;
			title.y = infoPadding;

			description.textWidth = media.width - infoPadding * 2;
			description.x = infoPadding;
			description.y = title.y + title.height + infoPadding;

			author.textWidth = media.width - thumbnail.x + thumbnail.width - infoPadding * 2;
			author.x = thumbnail.x + thumbnail.width + infoPadding;
			author.y = thumbnail.y;

			publish.textWidth = media.width - thumbnail.x + thumbnail.width - infoPadding * 2;
			publish.x = thumbnail.x + thumbnail.width + infoPadding;
			publish.y = thumbnail.y + thumbnail.height - publish.height;

			metadata.x = 0 - metadata.width / 2;
			metadata.y = 0 - metadata.height / 2;
			controlBtns.visible = false;

			metadata.x = backgroundGraphic.x;
			metadata.y = backgroundGraphic.y;
			
/*			square.graphics.beginFill(0x000000);
			square.graphics.drawRect(320 ,-170,250, 50);
			square.graphics.endFill();*/
			
/*			
			square6.graphics.beginFill(0x000000);
			square6.graphics.drawRect(320 ,-110,150, 50);
			square6.graphics.endFill();*/
			
			
			var myFont:Font = new Neutra();
			format.align = "center";
			format.size = 36;
			format.font = myFont.fontName;
			format.bold = true;
			format.color = 0xFFFFFF;
			format.leftMargin = 20;
			format.rightMargin = 20;


			videoTextDesc.embedFonts = true;
			videoTextDesc.antiAliasType = AntiAliasType.ADVANCED;
			videoTextDesc.defaultTextFormat = format;
			videoTextDesc.x = 320;
			videoTextDesc.y = -170;
			videoTextDesc.autoSize = TextFieldAutoSize.LEFT;
			videoTextDesc.background = true;
			videoTextDesc.backgroundColor = 0x222223;
			stringTemp = ContentParser.settings.Content.Source.(@id==nr).name;
			videoTextDesc.text = stringTemp.toUpperCase();
			addChild(videoTextDesc);
			
			
			//lineDrawing.graphics.lineStyle(3, 0xFF0000, 1, true,"normal","none");
			lineDrawing.graphics.beginFill(0x222223);
			lineDrawing.graphics.moveTo(videoTextDesc.width+320,-170); ///This is where we start drawing
			lineDrawing.graphics.lineTo(videoTextDesc.width+335, -170);
			
			lineDrawing.graphics.lineTo(videoTextDesc.width+320, -170 + videoTextDesc.height);
			lineDrawing.graphics.lineTo(videoTextDesc.width+320, -170);
			
			addChild(lineDrawing);
			trace('id', _id);
		
			videoTextName.embedFonts = true;
			videoTextName.antiAliasType = AntiAliasType.ADVANCED;
			videoTextName.defaultTextFormat = format;
			videoTextName.x = 320;
			videoTextName.y = -110;
			videoTextName.autoSize = TextFieldAutoSize.LEFT;
			videoTextName.background = true;
			videoTextName.backgroundColor = 0x222223;
			//trace(niveau);
			stringTemp = niveau;
			videoTextName.text = stringTemp.toUpperCase();
			addChild(videoTextName);
			
			
			lineDrawing2.graphics.beginFill(0x222223);
			lineDrawing2.graphics.moveTo(videoTextName.width+318,-110); ///This is where we start drawing
			lineDrawing2.graphics.lineTo(videoTextName.width+335, -110);
			
			lineDrawing2.graphics.lineTo(videoTextName.width+345, -110 + videoTextName.height);
			lineDrawing2.graphics.lineTo(videoTextName.width+318, -110+ videoTextName.height);
			addChild(lineDrawing2);
			
			
			square2.graphics.beginFill(0xffffff);
			//square2.graphics.lineStyle(1, 0xFF0000);
			square2.graphics.drawRect(-media.width/2-13 ,-media.height/2 - 9,media.width +100, media.height +76);
			square2.graphics.endFill();
			
			Svideo.x =-media.width/2-28;
			Svideo.y = -media.height/2 - 24;
			Svideo.width = media.width +145;
			Svideo.height = media.height +126;
	
			
			//square3.graphics.lineStyle(1,0x000000, 1, true, "normal", "SQUARE", "mitter");
			square3.graphics.beginFill(0x36A9E1);
			square3.graphics.drawRect(-media.width/2 ,media.height -160, media.width , 20);
			square3.graphics.endFill();
			
			mark.graphics.lineStyle( 5 , 0x000000 );
			mark.graphics.moveTo( -10 , -10);
			mark.graphics.lineTo( 10 , 10 );
			mark.graphics.moveTo( -10, 10 );
			mark.graphics.lineTo( 10 , -10 );
			mark.x = 640/2+70;
			mark.y = -210;
	
			
			
			var touchWeg:TouchSprite = new TouchSprite( );
			touchWeg.graphics.beginFill(0xffffff,0.001);
			touchWeg.graphics.drawRect(640/2+60, -230, 50,50);
			touchWeg.graphics.endFill();
			addChild(touchWeg);
			
			touchWeg.addEventListener(TouchEvent.TOUCH_UP, doeWeg);
			square5.addEventListener(TouchEvent.TOUCH_UP, playVideo);
			

			square5.graphics.beginFill(0x000000 , 0.0001);
			square5.graphics.drawRect(-50 ,-60,120, 120);
			square5.graphics.endFill();
			iconQR.x = 286;
			iconQR.y = -86;
			addChild(iconQR);
			
			if (qrCodeTag)
			{
				iconQR.addChild(qrCode);
			}
			
			//filters = [new DropShadowFilter(4.0, 45, 0x000000, 1.0, 12, 12, 0.5, 2)];
/*			
		   triangle.graphics.lineStyle(10 , 0xFFFFFF);
		   triangle.graphics.beginFill(0xFFFFFF);
		   triangle.graphics.moveTo(-10, -40);
		   triangle.graphics.lineTo(-10, 40);
		   triangle.graphics.lineTo(40, 0);
		   triangle.graphics.lineTo(-10, -40);
		   triangle.graphics.endFill();
 */
			
			var myFont2:Font = new Neutra();

			format.align = "center";
			format.size = 14;
			format.font = myFont2.fontName;
			format.bold = true;
			format.color = 0x000000;
			format.leftMargin = 5;
			format.rightMargin = 5;


			tijd.embedFonts = true;
			tijd.antiAliasType = AntiAliasType.ADVANCED;
			tijd.defaultTextFormat = format;
			tijd.x = 335;
			tijd.y = media.height -162;
			tijd.autoSize = TextFieldAutoSize.LEFT;
			
			
			var minutes = Math.floor(int(duration)/60);
					
			var seconds:int = int(duration) -(minutes *60);
			//trace ('min: ', minutes, 'sec :', seconds);
			var mS:String = String(minutes);
			var sS:String = String(seconds);
			
			if (minutes < 10){
				//trace('hier');
				mS = "0" + mS;
				}
			if (seconds < 10){
				sS = "0" + sS;
				
				}
			tijdMS = mS + ":" + sS 
			tijd.text =  tijdMS;
			
			loadingTime = new Timer(200,1);
			loadingTime.addEventListener(TimerEvent.TIMER, visOn);
			loadingTime.start();
			
		}
		private function visOn(e:Event){
			
			square.visible = true;
			square2.visible = true;
			square3.visible = true;
			square4.visible = true;
			square5.visible = true;
			triangle.visible = true;
			tijd.visible = true;
			outline.visible = true;
			qrCode.visible = true;
			Svideo.visible = true;
			lineDrawing.visible =true;
			videoTextDesc.visible = true;
			videoTextName.visible = true;
			lineDrawing2.visible = true;
			iconQR.visible = true;
			}
		private function doeWeg(e:Event){
			Dispose();
		}
private function playVideo(e:Event){
	//TweenLite.to(this,.5,{scaleX:1,scaleY:1,onUpdate:updateUI});
	if (! firstStart)
			{
				media.play();
				firstStart = true;
			}
			else{
				media.pause();
				firstStart = false;
				}
	}
		override protected function updateUI():void
		{

			width = media.width * scaleX;
			height = media.height * scaleY;

			if (scaleX < 1)
			{
				controlBtns.visible = false;
			}
			else
			{
				controlBtns.visible = true;
				controlBtns.scale = scaleX;
				controlBtns.x = media.width / 2;
				controlBtns.y = media.height / 2;
			}
			//NOG NAAR KIJKEN!!!
			/*if( (x-(width/2)>stageWidth) || (x+(width/2)<0) || (y-(height/2)>stageHeight) || (y+(height/2)<0) )
			{
			//trace('dispose: ');
			Dispose();
			}*/
		}

		private function touchDownHandler(event:TouchEvent):void
		{
		
			//updateIt();
			startTouchDrag(-1);
			//trace('set: ',this.parent.parent.numChildren);
			parent.parent.setChildIndex(parent,parent.parent.numChildren - 1);
			parent.setChildIndex(this,parent.numChildren - 1);

		}
		private function touchMoveHandler(event:TouchEvent):void
		{
			//updateIt();
			/*for (var i = 0; i<magnifier.length;i++){
				magnifier[i].captureBitmap();
				}*/
			startTouchDrag(-1);
		}

		private function touchUpHandler(event:TouchEvent):void
		{
			//updateIt();
			stopTouchDrag(-1);
		}

		private function rotateGestureHandler(event:GestureEvent):void
		{
			rotation +=  event.value;
		}

		private function doubleTapHandler(event:TouchEvent):void
		{
			//TweenLite.to(this,.5,{scaleX:1,scaleY:1,onUpdate:updateUI});
			/*if (! firstStart)
			{
				media.play();
				firstStart = true;
			}*/
		}
		private var friction:Number = 0.97;
		private var dx:Number = 0;
		private var dy:Number = 0;

		private function flickGestureHandler(e:GestureEvent):void
		{
			dx = e.velocityX;
			dy = e.velocityY;
			addEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
		}

		private function onEnterFrameHandler(e:Event):void
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
				removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
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
				removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
			}
			y +=  dy;
			dy *=  friction;
			//updateIt();

		}

		private function scaleGestureHandler(event:GestureEvent):void
		{
			scaleX +=  event.value;
			scaleY +=  event.value;
			//trace('schaal: ', line.scaleX	, ' ' ,scaleX );
			scaleY = scaleY > Number(maxScale) ? Number(maxScale):scaleY < Number(minScale) ? Number(minScale):scaleY;
			scaleX = scaleX > Number(maxScale) ? Number(maxScale):scaleX < Number(minScale) ? Number(minScale):scaleX;

			updateUI();
		}

		private function play(event:Event):void
		{
			/*if (information)
			{
				informationHandler(null);
			}
*/
			media.play();

		}

		private function pause(event:Event):void
		{
			media.pause();
		}

		private function back(event:Event):void
		{
			media.back();
		}

		private function forward(event:Event):void
		{
			media.forward();
		}
var prevValue = 0;
var tempTime = 20;
		private function timeHandler(event:Event):void
		{
			
	
			//controlBtns.timeText = media.time;
			tijd.text = media.time;
			if (prevValue!=  media.time){
				prevValue = media.time;
				//trace(media.time);
				//square4.x += speed;
				//square4.width += speed;
				square4.graphics.clear();
				square4.graphics.beginFill(0x222223);
			square4.graphics.drawRect(-640/2 ,360 -160, tempTime,20);
			square4.graphics.endFill();
			tempTime +=speed
			speed = 640/int(duration);
				

			if (tempTime > media.width ||  media.time == tijdMS){
				
				square4.graphics.drawRect(-640/2 ,360 -160, 20,20);
				tempTime =0;
				}
				}
			
		
		}

		private function informationHandler(event:Event):void
		{
			if (! information)
			{
				TweenLite.to(media,.5,{alpha:0});
				TweenLite.to(metadata,.5,{alpha:1});
				information = true;
			}
			else
			{
				TweenLite.to(media,.5,{alpha:1});
				TweenLite.to(metadata,.5,{alpha:0});
				information = false;
			}
		}
	}
}