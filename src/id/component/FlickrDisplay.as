package id.component
{
	import flash.events.Event;
	import flash.display.DisplayObject;
	import id.core.ApplicationGlobals;
	import id.core.TouchComponent;
	import id.component.ControlBtns;
	import id.element.VideoLoader;
	import id.element.BitmapLoader;
	import id.element.ThumbLoader;
	import id.element.Outline;
	import id.element.Graphic;
	import id.element.TextDisplay;
	import id.element.QRCodeDisplay;
	import id.element.FlickrParser;
	import id.element.FlickrDisplayParser;
	import gl.events.TouchEvent;
	import gl.events.GestureEvent;
	import com.greensock.TweenLite;
	
	/**
	 * <p>The FlickrDisplay component is the main component for the FlickrViewer module.  It contains all the neccessary display objects for the module.</p>
	 *
	 * <p>
	 * The FlickrViewer is a module designed to display media content using the Flickr API.  
	 * Selected Bitmap data and short video files are downloaded from a defined Flickr user account along with associated meta data.  
	 * User account settings, image and video preferences and basic formatting can be specified using the module XML file.  
	 * Multiple touch object images and videos can be displayed on stage and each touch object can be manipulated using the TAP, DRAG, SCALE and ROTATE multitouch gestures.  
	 * All multitouch gestures can be activated and deactivated using the module XML settings.</p>
	 *
	 * <strong>Imported Components :</strong>
	 * <pre>
	 * BitmapLoader
	 * VideoLoader
	 * BitmapLoader
	 * ThumbLoader
	 * Outline
	 * Graphic
	 * TextDisplay
	 * QRCodeDisplay
	 * FlickrParser
	 * TouchGesturePhysics
	 * </pre>
	 *
	 * <listing version="3.0">
	 * var flickrDisplay:FlickrDisplay = new FlickrDisplay();
	 *
	 * 		flickrDisplay.id = Number;
	 *
	 * addChild(flickrDisplay);</listing>
	 *
	 * @see id.module.FlickrViewer
	 * 
	 * @includeExample FlickrDisplay.as
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10.1
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	public class FlickrDisplay extends TouchComponent
	{
		private var media:*;
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
		
		private var _id:int;
		private var infoPadding:Number=10;
		private var intialize:Boolean;
		private var video:Boolean=true;
		private var globalScale:Number;
		private var scale:Number;
		private var imagesNormalize:Number;
		private var infoPaddingNumber:Number;
		private var maxScale:Number=2;
		private var minScale:Number=.5;
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
		private var usernameText:String;
		private var tagText:String;
		private var dragGesture:Boolean=true;
		private var rotateGesture:Boolean=true;
		private var scaleGesture:Boolean=true;
		private var doubleTapGesture:Boolean=true;
		private var flickGesture:Boolean=true;
		private var videoSource:String;
		private var information:Boolean;
		private var stageWidth:Number;
		private var stageHeight:Number;
		
		var klik = 2;
		
		/**
		 *
		 * The Constructor.
		 * <pre>
		 * <strong>var flickrDisplay:FlickrDisplay = new FlickrDisplay();
		 * addChild(flickrDisplay);</strong></pre>
		 *
		 */
		public function FlickrDisplay()
		{
			super();
			blobContainerEnabled=true;
			visible=false;
		}
		
		
		/**
		 *
		 * The Disposal method for the module. It will clean out and nullify all children.
		 * <pre>
		 * <strong>flickrDisplay.Dispose();</strong></pre>
		 *
		 */
		override public function Dispose():void
		{
			if (dragGesture)
			{
				removeEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
				removeEventListener(TouchEvent.TOUCH_UP, touchUpHandler);
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

			if (videoSource)
			{
				removeEventListener(ControlBtns.PLAY, play);
				removeEventListener(ControlBtns.PAUSE, pause);
				removeEventListener(ControlBtns.BACK, back);
				removeEventListener(ControlBtns.FORWARD, forward);
				removeEventListener(VideoLoader.TIME,timeHandler);
			}

			removeEventListener(ControlBtns.INFO_CALL, informationHandler);
			
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
		public function set klikt(value:int):void
		{
			klik = value;
			//trace('flok: ', klik);
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
			video=FlickrDisplayParser.settings.GlobalSettings.video=="true"?true:false;
			globalScale=FlickrDisplayParser.settings.GlobalSettings.globalScale;
			scale=FlickrDisplayParser.settings.GlobalSettings.scale;
			imagesNormalize=FlickrDisplayParser.settings.GlobalSettings.imagesNormalize;
			infoPaddingNumber=FlickrDisplayParser.settings.GlobalSettings.infoPadding;
			maxScale=FlickrDisplayParser.settings.GlobalSettings.maxScale;
			minScale=FlickrDisplayParser.settings.GlobalSettings.minScale;
			stageWidth=ApplicationGlobals.application.stage.stageWidth;
			stageHeight=ApplicationGlobals.application.stage.stageHeight;
			
			if(!video)
			{
				video=false;
			}
			
			if(!maxScale || !minScale)
			{
				maxScale=2;
				minScale=.5;
			}
			
			infoBtnStyle=FlickrDisplayParser.settings.ControlBtns;
			backgroundOutlineStyle=FlickrDisplayParser.settings.BackgroundOutline;
			backgroundGraphicStyle=FlickrDisplayParser.settings.BackgroundGraphic;
			titleStyle=FlickrDisplayParser.settings.InfoText.TitleText;
			descriptionStyle=FlickrDisplayParser.settings.InfoText.DescriptionText;
			authorStyle=FlickrDisplayParser.settings.InfoText.AuthorText;
			publishStyle=FlickrDisplayParser.settings.InfoText.PublishText;

			// Gestures
			if (FlickrDisplayParser.settings.Gestures!=undefined)
			{
				dragGesture=FlickrDisplayParser.settings.Gestures.drag=="true"?true:false;
				rotateGesture=FlickrDisplayParser.settings.Gestures.rotate=="true"?true:false;
				scaleGesture=FlickrDisplayParser.settings.Gestures.scale=="true"?true:false;
				doubleTapGesture=FlickrDisplayParser.settings.Gestures.doubleTap=="true"?true:false;
				flickGesture=FlickrDisplayParser.settings.Gestures.flick=="true"?true:false;
			}

			// Data		
			//trace("display " ,klik , id);
			
			
					
			
			mediaUrl=FlickrParser.dataSet[id].imgUrl;

			thumbUrl=FlickrParser.dataSet[id].imgUrl;
			qrCodeTag=FlickrParser.dataSet[id].qrCodeTag;
			titleText=FlickrParser.dataSet[id].title;
			descriptionText=FlickrParser.dataSet[id].description;
			usernameText=FlickrParser.dataSet[id].author;
			tagText=FlickrParser.dataSet[id].publish;

			if (video)
			{
				videoSource=FlickrParser.dataSet[_id].videoSource;
			}

			// Objects
			if (videoSource)
			{
				media = new VideoLoader();
			}
			else
			{
				media = new BitmapLoader();
			}

			controlBtns = new ControlBtns();
			outline = new Outline();
			backgroundGraphic = new Graphic();
			title = new TextDisplay();
			description = new TextDisplay();
			author = new TextDisplay();
			publish = new TextDisplay();
			thumbnail = new ThumbLoader();
			qrCode = new QRCodeDisplay();
			metadata = new TouchComponent();

			// Add Children
			if(qrCodeTag)
			{
				metadata.addChild(qrCode);
			}
			
			metadata.addChild(title);
			metadata.addChild(description);
			metadata.addChild(author);
			metadata.addChild(publish);
			metadata.addChild(thumbnail);
			addChild(controlBtns);
			addChild(backgroundGraphic);
			addChild(metadata);
			addChild(media);
			addChild(outline);

			// Add Event Listeners
			if (dragGesture)
			{
				addEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
				addEventListener(TouchEvent.TOUCH_UP, touchUpHandler);
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

			if (videoSource)
			{
				addEventListener(ControlBtns.PLAY, play);
				addEventListener(ControlBtns.PAUSE, pause);
				addEventListener(ControlBtns.BACK, back);
				addEventListener(ControlBtns.FORWARD, forward);
				addEventListener(VideoLoader.TIME,timeHandler);
			}

			addEventListener(ControlBtns.INFO_CALL, informationHandler);
		}

		override protected function commitUI():void
		{
			if (videoSource)
			{
				controlBtns.type="video";
				mediaUrl=videoSource;
			}

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
			description.styleList=descriptionStyle;
			author.styleList=authorStyle;
			publish.styleList=publishStyle;

			media.url=mediaUrl;
			thumbnail.url=thumbUrl;

			title.text=titleText;
			description.text=descriptionText;
			author.text=usernameText;
			publish.text=tagText;

			if (infoPaddingNumber)
			{
				infoPadding=infoPaddingNumber;
			}

			metadata.alpha=0;
		}

		override protected function layoutUI():void
		{
			if (videoSource)
			{
				controlBtns.width=media.width;
			}

			if (! intialize)
			{
				if (globalScale)
				{
					scaleX=globalScale;
					scaleY=globalScale;
				}

				intialize=true;
				visible=true;
			}

			backgroundGraphic.width=media.width;
			backgroundGraphic.height=media.height;
			backgroundGraphic.x=0-backgroundGraphic.width/2;
			backgroundGraphic.y=0-backgroundGraphic.height/2;
			
			media.x=backgroundGraphic.x;
			media.y=backgroundGraphic.y;

			outline.width=media.width;
			outline.height=media.height;

			thumbnail.x=infoPadding;
			thumbnail.y=media.height-thumbnail.height-infoPadding;
			
			qrCode.x=media.width-qrCode.width-infoPadding;
			qrCode.y=media.height-qrCode.height-infoPadding;

			title.textWidth=media.width-(infoPadding*2);
			title.x=infoPadding;
			title.y=infoPadding;

			description.textWidth=media.width-(infoPadding*2);
			description.x=infoPadding;
			description.y=title.y+title.height+infoPadding;

			author.textWidth=media.width-(thumbnail.x+thumbnail.width)-(infoPadding*2);
			author.x=thumbnail.x+thumbnail.width+infoPadding;
			author.y=thumbnail.y;

			publish.textWidth=media.width-(thumbnail.x+thumbnail.width)-(infoPadding*2);
			publish.x=thumbnail.x+thumbnail.width+infoPadding;
			publish.y=thumbnail.y+thumbnail.height-publish.height;

			metadata.x=0-metadata.width/2;
			metadata.y=0-metadata.height/2;
			controlBtns.visible=false;

			metadata.x=backgroundGraphic.x;
			metadata.y=backgroundGraphic.y;
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
			
/*			if( (x-(width/2)>stageWidth) || (x+(width/2)<0) || (y-(height/2)>stageHeight) || (y+(height/2)<0) )
			{
				Dispose();
			}*/
		}

		private function touchDownHandler(event:TouchEvent):void
		{
			startTouchDrag(-1);
			parent.parent.setChildIndex( parent, parent.parent.numChildren - 1);
			parent.setChildIndex(this as DisplayObject,parent.numChildren-1);
		}

		private function touchUpHandler(event:TouchEvent):void
		{
			stopTouchDrag(-1);
		}

		private function rotateGestureHandler(event:GestureEvent):void
		{
			rotation+=event.value;
		}

		private function doubleTapHandler(event:TouchEvent):void
		{
			TweenLite.to(this, .5, {scaleX:1, scaleY:1, onUpdate:updateUI});
		}
		private var friction:Number = 0.97;
		private var dx:Number = 0;
		private var dy:Number = 0;
		private function flickGestureHandler(e:GestureEvent):void
		{
			dx = e.velocityX
			dy = e.velocityY;
            addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		 private function onEnterFrameHandler(e:Event):void {
            if(x < -600) {
                dx =- dx;
                x = -600;
            }
            if(x > stageWidth - 600) {
                dx =- dx;
                x = stageWidth - 600;
				//trace(media.width/2);
            }
            if (Math.abs(dx) <= 1) {
                dx = 0;
                removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
            }
        x += dx;
        dx *= friction;
		
		 if(y < -400) {
                dy =- dy;
                y = -400;
            }
            if(y > stageHeight - 300) {
                dy =- dy;
                y = stageHeight - 300;
				
            }
           if (Math.abs(dy) <= 1) {
                dy = 0;
                removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
            }
       y += dy;
        dy *= friction;
        }

		private function scaleGestureHandler(event:GestureEvent):void
		{
			scaleX+=event.value;
			scaleY+=event.value;

			scaleY=scaleY>Number(maxScale)?Number(maxScale):scaleY<Number(minScale)?Number(minScale):scaleY;
			scaleX=scaleX>Number(maxScale)?Number(maxScale):scaleX<Number(minScale)?Number(minScale):scaleX;

			updateUI();
		}

		private function play(event:Event):void
		{
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
		
		private function timeHandler(event:Event):void
		{
			controlBtns.timeText=media.time;
		}

		private function informationHandler(event:Event):void
		{
			if (! information)
			{
				TweenLite.to(media, .5, { alpha:0});
				TweenLite.to(metadata, .5, { alpha:1});
				information=true;
			}
			else
			{
				TweenLite.to(media, .5, { alpha:1});
				TweenLite.to(metadata, .5, { alpha:0});
				information=false;
			}
		}
	}
}