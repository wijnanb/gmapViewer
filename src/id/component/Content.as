package id.component
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.*;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.*;
	import flash.utils.Timer;
	
	import gl.events.GestureEvent;
	import gl.events.TouchEvent;
	
	import id.core.ApplicationGlobals;
	import id.core.TouchComponent;
	import id.core.TouchSprite;
	import id.element.ContentParser;
	import id.element.Graphic;
	import id.element.TextDisplay;
	import id.element.YouTubeParser;
	import id.module.FlickrViewer;
	import id.module.ImageViewer;
	import id.module.LiveVideoViewer;
	import id.module.TekstViewer;
	import id.module.YouTubeViewer;
	import id.template.Magnifier;
	import id.utils.CurvedText;


	public class Content extends TouchComponent
	{

		private var _textTitle:CurvedText;
		private var _textDesc:CurvedText;
		//modules
		private var youtubeList:Array = new Array;
		private var liveVideoList:Array = new Array;
		private var imageList:Array = new Array;
		private var tekstList:Array = new Array;
		private var flickrList:Array = new Array;
		private var youTubeViewer:YouTubeViewer;
		private var flickrViewer:FlickrViewer;
		///modules

		private var urlArray:Array = new Array;
		private var nummerKlik:Array = new Array;

		//layout
		private var alles:TouchSprite;
		private var alles2:TouchSprite;
		private var alles3:TouchSprite;
		private var alles4:TouchSprite;
		private var txt:TextDisplay;
		private var guiList:Array = new Array;
		private var gui:Shape = new Shape();
		private var gui1:Shape = new Shape();
		private var gui2:Shape = new Shape();
		private var guiTouch;
		private var guiKlik1:TouchSprite = new TouchSprite;
		private var guiKlik2:TouchSprite = new TouchSprite;
		private var guiKlik3:TouchSprite = new TouchSprite;
		private var iconGuiKlik1:TouchSprite =new TouchSprite();
		private var iconGuiKlik2:TouchSprite =new TouchSprite();
		private var iconGuiKlik3:TouchSprite =new TouchSprite();
		private var activeGui:Sprite = new Sprite();
		private var activeGuiBack:Sprite = new Sprite();
		private var uitgeschoven:Boolean = false;
		private var holder:TouchSprite =new TouchSprite();

		private var textRotate:Sprite =new Sprite();
		private var field1:TextField = new TextField;
		private var field2:TextField = new TextField;
		private var field3:TextField = new TextField;
		private var field4:TextField = new TextField;
		private var tekstCircleTitle:String;
		private var tekstCircleDesc:String;
		private var format:TextFormat = new TextFormat;
		private var format2:TextFormat = new TextFormat;
		private var format4:TextFormat = new TextFormat;
		private var schuifHolder1:TouchSprite;
		private var schuifHolder2:TouchSprite;
		private var schuifHolder3:TouchSprite;

		private var line:TouchSprite = new TouchSprite;
		private var line1:TouchSprite = new TouchSprite;
		private var line2:TouchSprite = new TouchSprite;
		private var lineList:Array = new Array;
		private var lineFoto:Sprite = new Sprite();
		private var lineTekst:Sprite = new Sprite();
		private var lineVideo:Sprite = new Sprite();

		[Embed(source = "../../../assets/interface/Icoon_tekstblauw.png")]
		public var iconTekstClass:Class;
		private var iconTekst = new iconTekstClass();

		[Embed(source = "../../../assets/interface/Icoon_fotoblauw.png")]
		public var iconFotoClass:Class;
		private var iconFoto = new iconFotoClass();

		[Embed(source = "../../../assets/interface/Icoon_videoblauw.png")]
		public var iconVideoClass:Class;
		private var iconVideo = new iconVideoClass();

		private var contentId:int;
		private var mX;
		private var mY;
		protected var contentContainer;
		protected var magnifier:Magnifier;
		public var iconscale = 0;
		private var geenVideo = false;
		private var geenFoto = false;
		private var geenTekst = false;
		private var rotateTekstCircle:Sprite = new Sprite();
		private var magId;

		private var activeConcept:Boolean = false;
		private var activeConstruction:Boolean = true;
		private var activeResultaat:Boolean = false;
		private var prevTouch:String = "";
		private var speedCircle = 0.5;
		private var offset2 = 0;
		private var offset3 = 0;
		private var offset = 0;
		private var iconSize = 1;
		private var sound:Sound;
		private var sound2:Sound;
		private var sound3:Sound;
		private var pressedFoto:Boolean = false;
		private var pressedTekst:Boolean = false;
		private var pressedVideo:Boolean = false;

		protected var activeContentList:Array = new Array();
		
		protected const Y_OFFSET:Number = 200;
		
		public function Content(contentContainer:TouchSprite, magnifier:Magnifier)
		{
			super();
			blobContainerEnabled = true;
			this.contentContainer = contentContainer; // adds the content underneath the magnifier
			this.magnifier = magnifier;
			
			if ( !Player.isAir ) {
				sound = new Sound(new URLRequest("assets/interface/sound/knock.mp3"));
				sound2 = new Sound(new URLRequest("assets/interface/sound/slide-1.mp3"));
				sound3 = new Sound(new URLRequest("assets/interface/sound/typewriter-line-break-1.mp3"));
			}
			
			var ring1:Sprite = new Sprite();
			ring1.graphics.lineStyle(15,0x36A9E1, 1, true);
			ring1.graphics.drawCircle(0,0,94);
			
			addChild(ring1);
		}

		public function deleteIt():void{
			for(var i=0;i<youtubeList.length;i++){
				//trace("hallo ", i);
				youtubeList[contentId].verwijder();
				}
			}
		public function inFocus(contentId:int):void // function called when magnifier hovers over marker
		{
			this.contentId = contentId;//marker
			
			if ( !Player.isAir ) sound.play();
			schuifHolder1=new TouchSprite();
			schuifHolder2 =new TouchSprite();
			schuifHolder3=new TouchSprite();
			alles = new TouchSprite();
			alles2 = new TouchSprite();
			alles3 = new TouchSprite();
			alles4 = new TouchSprite();

			schuifHolder1.name = "resultaat";
			schuifHolder2.name = "constructie";
			schuifHolder3.name = "concept";

			addChild(alles);
			alles.addChild(alles2);
			alles.addChild(alles3);
			alles.addChild(alles4);
			alles.alpha = 0;

			alles2.addChild(schuifHolder1);
			alles3.addChild(schuifHolder2);
			alles4.addChild(schuifHolder3);

			schuifHolder1.x = 0;
			schuifHolder1.y = 0;
			schuifHolder1.scaleX = 0;
			schuifHolder1.scaleY = 0;

			schuifHolder2.x = 0;
			schuifHolder2.y = 0;
			schuifHolder2.scaleX = 0;
			schuifHolder2.scaleY = 0;

			schuifHolder3.x = 0;
			schuifHolder3.y = 0;
			schuifHolder3.scaleX = 0;
			schuifHolder3.scaleY = 0;

			TweenLite.to(schuifHolder1, 0.5, {x:117, y: 17 ,rotation: 10, scaleX:1 , scaleY :1, delay: 0.1, ease:Back.easeOut});
			TweenLite.to(schuifHolder2, 0.5, {x:119, y:-11 ,scaleX:1, scaleY :1, delay: 0.2, ease:Back.easeOut});
			TweenLite.to(schuifHolder3, 0.5, {x:113, y: -40, rotation: -10, scaleX:1 ,scaleY :1, delay: 0.3, ease:Back.easeOut});
			TweenLite.to(alles, 0.4, {alpha:1, ease:Back.easeOut});

			schuifHolder1.addEventListener(TouchEvent.TOUCH_UP,guiHandler);
			schuifHolder2.addEventListener(TouchEvent.TOUCH_UP,guiHandler);
			schuifHolder3.addEventListener(TouchEvent.TOUCH_UP,guiHandler);

			[Embed(source="../../../assets/fonts/Neutra2Text-Demi.otf", fontFamily="Neutra", fontWeight="bold", embedAsCFF="true")]
			var fontNeutra:String;

			format.align = "center";
			format.size = 18;
			format.font = "Neutra";
			format.bold = true;
			format.color = 0xFFFFFF;
			format.leftMargin = 5;
			format.rightMargin = 2;

			format4.align = "left";
			format4.size = 14;
			format4.font = "Neutra";
			format4.bold = true;
			format4.color = 0xFFFFFF;

			field1.embedFonts = true;
			field1.antiAliasType = AntiAliasType.ADVANCED;
			field1.defaultTextFormat = format;
			field1.x = 0;
			field1.y = 0;
			field1.rotation = 0;
			field1.autoSize = TextFieldAutoSize.LEFT;
			field1.text = "Resultaat";
			field1.background = true;
			field1.backgroundColor = 0x222223;

			field2.embedFonts = true;
			//field2.antiAliasType = AntiAliasType.ADVANCED;
			field2.defaultTextFormat = format;
			field2.x = 0;
			field2.y = 0;
			field2.rotation = 0;
			field2.autoSize = TextFieldAutoSize.LEFT;
			field2.text = "Constructie";
			field2.background = true;
			field2.backgroundColor = 0x222223;

			field3.embedFonts = true;
			field3.antiAliasType = AntiAliasType.ADVANCED;
			field3.defaultTextFormat = format;
			field3.x = 0;
			field3.y = 0;
			field3.rotation = 0;
			field3.autoSize = TextFieldAutoSize.LEFT;
			field3.text = "Concept";
			field3.background = true;
			field3.backgroundColor = 0x222223;

			schuifHolder1.addChild(field1);
			schuifHolder2.addChild(field2);
			schuifHolder3.addChild(field3);
			
			tekstCircleTitle = ContentParser.settings.Content.Source.(@id == contentId).title;
			tekstCircleDesc = ContentParser.settings.Content.Source.(@id == contentId).name;

			var tekstCircleAfterDesc = tekstCircleDesc.toUpperCase();
			var tekstCircleAfterTitle = tekstCircleTitle.toUpperCase();

			var gradenTitle = tekstCircleTitle.length * 5 - 30;
			var gradenDesc = tekstCircleDesc.length * 5;
			
			addChild(rotateTekstCircle);
			
			_textTitle = new CurvedText(tekstCircleAfterTitle,112,-30,gradenTitle,CurvedText.DIRECTION_UP,format4);
			_textTitle.showCurve = false;
			_textTitle.showLetterBorder = false;
			_textTitle.draw();
			_textTitle.x = -57;
			_textTitle.y = -121;
			rotateTekstCircle.addChild(_textTitle);
						
			_textDesc = new CurvedText(tekstCircleAfterDesc,95,0,gradenDesc,CurvedText.DIRECTION_UP,format4);
			_textDesc.showCurve = false;
			_textDesc.showLetterBorder = false;
			_textDesc.draw();
			_textDesc.x = 0;
			_textDesc.y = -103;
			rotateTekstCircle.addChild(_textDesc);
			
			rotateTekstCircle.rotation = 0;
			TweenLite.to(rotateTekstCircle, 2, {rotation:360, delay: 0.1, ease:Back.easeOut});
		}

		private function guiHandler(event:Event):void // fold out interface
		{
			geenVideo = false;
			geenFoto = false;
			geenTekst = false;

			guiTouch = event.target.name;
			if (prevTouch != guiTouch)
			{
				if ( !Player.isAir ) sound2.play();
				prevTouch = guiTouch;
				addChild(holder);
				holder.alpha = 0;
				holder.scaleX = 0;
				holder.scaleY = 0;
				uitgeschoven = true;

				if (guiTouch == "concept")
				{
					if (activeResultaat == true)
					{
						TweenMax.to(alles, speedCircle, {shortRotation:{rotation:10}});
						TweenMax.to(alles2, speedCircle, {shortRotation:{rotation:60}});
						TweenMax.to(alles3, speedCircle, {shortRotation:{rotation:60}});
						TweenLite.to(holder, speedCircle, {alpha:1 ,scaleX:1 , scaleY :1, ease:Back.easeOut});
					}
					if (activeConstruction == true)
					{
						TweenMax.to(alles, speedCircle, {shortRotation:{rotation:10}});
						TweenMax.to(alles2, speedCircle, {shortRotation:{rotation:60}});
						TweenMax.to(alles3, speedCircle, {shortRotation:{rotation:60}});
						TweenLite.to(holder, speedCircle, {alpha:1 ,scaleX:1 , scaleY :1, ease:Back.easeOut});
					}
					activeConcept = true;
					activeConstruction = false;
					activeResultaat = false;
						
					if (ContentParser.settings.Content.Source.(@id == contentId).concept.image.length() == 0)
					{
						geenFoto = true;
					}
					if (ContentParser.settings.Content.Source.(@id == contentId).concept.youtube.length() == 0)
					{
						geenVideo = true;
					}
					if (ContentParser.settings.Content.Source.(@id == contentId).concept.text.length() == 0)
					{
						geenTekst = true;
					}
				}
				if (guiTouch == "constructie")
				{
					if (activeConstruction == true)
					{
						TweenMax.to(alles2, speedCircle, {shortRotation:{rotation:60}});
						TweenLite.to(holder, speedCircle, {alpha:1 ,scaleX:1 , scaleY :1, ease:Back.easeOut});
					}

					if (activeResultaat == true)
					{
						TweenMax.to(alles, speedCircle, {shortRotation:{rotation:-3}});
						TweenMax.to(alles2, speedCircle, {shortRotation:{rotation:60}});
						TweenLite.to(holder, speedCircle, {alpha:1 ,scaleX:1 , scaleY :1, ease:Back.easeOut});
					}
					if (activeConcept == true)
					{
						TweenMax.to(alles, speedCircle, {shortRotation:{rotation:-3}});
						TweenMax.to(alles2, speedCircle, {shortRotation:{rotation:60}});
						TweenMax.to(alles3, speedCircle, {shortRotation:{rotation:0}});
						TweenLite.to(holder, speedCircle, {alpha:1 ,scaleX:1 , scaleY :1, ease:Back.easeOut});
					}
					activeConcept = false;
					activeConstruction = true;
					activeResultaat = false;

					if (ContentParser.settings.Content.Source.(@id == contentId).constructie.image.length() == 0)
					{
						geenFoto = true;
					}
					if (ContentParser.settings.Content.Source.(@id == contentId).constructie.youtube.length() == 0)
					{
						geenVideo = true;
					}
					if (ContentParser.settings.Content.Source.(@id == contentId).constructie.text.length() == 0)
					{
						geenTekst = true;
					}
				}
				if (guiTouch == "resultaat")
				{
					if (activeConstruction == true)
					{
						TweenMax.to(alles, speedCircle, {shortRotation:{rotation:-13}});
						TweenMax.to(alles2, speedCircle, {shortRotation:{rotation:0}});
						TweenMax.to(alles3, speedCircle, {shortRotation:{rotation:0}});
						TweenLite.to(holder, speedCircle, {alpha:1 ,scaleX:1 , scaleY :1, ease:Back.easeOut});
					}
					if (activeConcept == true)
					{
						TweenMax.to(alles, speedCircle, {shortRotation:{rotation:-13}});
						TweenMax.to(alles2, speedCircle, {shortRotation:{rotation:0}});
						TweenMax.to(alles3, speedCircle, {shortRotation:{rotation:0}});
						TweenLite.to(holder, speedCircle, {alpha:1 ,scaleX:1 , scaleY :1, ease:Back.easeOut});
					}
					activeConcept = false;
					activeConstruction = false;
					activeResultaat = true;

					if (ContentParser.settings.Content.Source.(@id == contentId).resultaat.image.length() == 0)
					{
						geenFoto = true;
					}
					if (ContentParser.settings.Content.Source.(@id == contentId).resultaat.youtube.length() == 0)
					{
						geenVideo = true;
					}
					if (ContentParser.settings.Content.Source.(@id == contentId).resultaat.text.length() == 0)
					{
						geenTekst = true;
					}
				}
				iconGuiLoad1();
				iconGuiLoad2();
				iconGuiLoad3();
			}
		}
	
		private function iconGuiLoad1():void // video icon
		{
			if (geenVideo == true) // if no video in xml alpha value 0.1
			{
				iconVideo.x = 135;
				iconVideo.y = 10;
				iconVideo.scaleX = iconscale;
				iconVideo.scaleY = iconscale;
				iconVideo.alpha = 0;
				holder.addChild(iconVideo);
				TweenLite.to(iconVideo, speedCircle, {alpha:0.2,scaleX:iconSize, rotation: 10,scaleY :iconSize,delay: 0.3, ease:Back.easeOut});
				geenVideo = false;
				iconGuiKlik1.removeEventListener(TouchEvent.TOUCH_UP,videoHandler);
			}
			else
			{
				iconVideo.x = 135;
				iconVideo.y = 10;
				iconVideo.scaleX = iconscale;
				iconVideo.scaleY = iconscale;
				holder.addChild(iconVideo);
				TweenLite.to(iconVideo, speedCircle, {alpha:1 ,scaleX:iconSize, rotation: 10, scaleY :iconSize,delay: 0.3, ease:Back.easeOut});

				iconGuiKlik1.graphics.beginFill(0x000000, 0.00001);
				iconGuiKlik1.graphics.drawRect(140,18,70,70);
				iconGuiKlik1.graphics.endFill();
				iconGuiKlik1.addEventListener(TouchEvent.TOUCH_UP,videoHandler);
				holder.addChild(iconGuiKlik1);
			}
		}

		private function iconGuiLoad2():void // photo icon
		{
			if (geenFoto == true) // if no photo in xml alpha value 0.1
			{
				holder.addChild(iconFoto);
				iconFoto.x = 125;
				iconFoto.y = 70;
				iconFoto.scaleX = iconscale;
				iconFoto.scaleY = iconscale;
				iconFoto.alpha = 0;
				TweenLite.to(iconFoto, speedCircle, {alpha:0.2 ,scaleX:iconSize, scaleY :iconSize, rotation: 10, delay: 0.4, ease:Back.easeOut});
				geenFoto = false;
				iconGuiKlik2.removeEventListener(gl.events.TouchEvent.TOUCH_UP,fotoHandler);
			}
			else
			{
				holder.addChild(iconFoto);
				iconFoto.x = 125;
				iconFoto.y = 70;
				iconFoto.scaleX = iconscale;
				iconFoto.scaleY = iconscale;
				TweenLite.to(iconFoto,speedCircle, {alpha:1,scaleX:iconSize, scaleY :iconSize, rotation: 10, delay: 0.4, ease:Back.easeOut});

				iconGuiKlik2.graphics.beginFill(0x000000, 0.00001);
				iconGuiKlik2.graphics.drawRect(128,75,70,70);
				iconGuiKlik2.graphics.endFill();
				iconGuiKlik2.addEventListener(gl.events.TouchEvent.TOUCH_UP,fotoHandler);
				holder.addChild(iconGuiKlik2);
			}
		}

		private function iconGuiLoad3():void // text icon 
		{
			if (geenTekst == true) // if no text in xml alpha value 0.1
			{
				iconTekst.x = 110;
				iconTekst.y = 100;
				holder.addChild(iconTekst);
				iconTekst.scaleX = iconscale;
				iconTekst.scaleY = iconscale;
				iconTekst.alpha = 0;
				TweenLite.to(iconTekst, speedCircle, {alpha:0.2,scaleX:iconSize, scaleY :iconSize , rotation: 50,delay:0.5, ease:Back.easeOut});
				iconGuiKlik3.removeEventListener(TouchEvent.TOUCH_UP,tekstHandler);
			}
			else
			{
				iconTekst.x = 110;
				iconTekst.y = 100;
				holder.addChild(iconTekst);
				iconTekst.scaleX = iconscale;
				iconTekst.scaleY = iconscale;
				TweenLite.to(iconTekst, speedCircle, {alpha:1,scaleX:iconSize, rotation: 50, scaleY :iconSize,delay:0.5, ease:Back.easeOut});

				iconGuiKlik3.graphics.beginFill(0x000000, 0.0001);
				iconGuiKlik3.graphics.drawRect(90,135,70,70);
				iconGuiKlik3.graphics.endFill();
				holder.addChild(iconGuiKlik3);
				iconGuiKlik3.addEventListener(TouchEvent.TOUCH_UP,tekstHandler);
			}
		}

		private function streamHandler(niveau):void // not used stream instance
		{
			var i = contentId;
			var livevideoViewer:LiveVideoViewer = new LiveVideoViewer;
			livevideoViewer.id = i;//id marker
			liveVideoList[i] = livevideoViewer;
			contentContainer.addChild(liveVideoList[i]);
			liveVideoList[i].x = parent.x;
			liveVideoList[i].y = parent.y;
		}

		private function flickrHandler(niveau):void // not used flickr instance
		{
			var i = contentId;
			flickrViewer = new FlickrViewer(i);
			flickrList[i] = flickrViewer;
			contentContainer.addChild(flickrList[i]);
			flickrList[i].x = parent.x;
			flickrList[i].y = parent.y;
		}

		private function fotoHandler(event:Event) // make a image instance
		{
			var timerPress:Timer = new Timer(1000,1);
			timerPress.addEventListener(TimerEvent.TIMER, timerPressFunction);
			timerPress.start();
			if(pressedFoto == false){
				
				var colorize:ColorTransform = new ColorTransform(1.0,1.0,1.0,0.4);
				iconFoto.transform.colorTransform = colorize;
				
				pressedFoto = true;
				var ip = contentId;
				var imageViewer:ImageViewer = new ImageViewer(ip,guiTouch,magnifier);
				imageList[ip] = imageViewer;
				imageViewer.id = ip;
				if (parent.x < 640)
				{
					offset3 = 350;
				}
				else
				{
					offset3 = -350;
				}
				imageList[ip].x = parent.x + offset3 * Math.random() - Math.random()*4;
				imageList[ip].y = parent.y * Math.random() + Y_OFFSET;
					
				addContentToLayer(imageList[ip]);
				
				var timer:Timer = new Timer(40,25); // 25FPS during 1 sec
				timer.addEventListener(TimerEvent.TIMER, updateLens);
				timer.start();
			}
		}

		private function tekstHandler(event:Event) // make a text instance
		{
			
			var timerPressTekst:Timer = new Timer(1000,1);
			timerPressTekst.addEventListener(TimerEvent.TIMER, timerPressTekstFunction);
			timerPressTekst.start();
			if(pressedTekst == false){
				
				var colorize:ColorTransform = new ColorTransform(1.0,1.0,1.0,0.4);
				iconTekst.transform.colorTransform = colorize;
				pressedTekst = true;

				var ip = contentId;
				var tekstViewer:TekstViewer = new TekstViewer(ip,guiTouch,magnifier);
				tekstList[ip] = tekstViewer;
				tekstViewer.id = ip;
				if (parent.x < 640)
				{
					offset2 = 350;
				}
				else
				{
					offset2 = -350;
				}
				tekstList[ip].x = parent.x + offset2;
				tekstList[ip].y = parent.y + Y_OFFSET;
				
				addContentToLayer(tekstList[ip]);
				
				var timer:Timer = new Timer(40,25);
				timer.addEventListener(TimerEvent.TIMER, updateLens);
				timer.start();
			}
		}
		
		
		protected function addContentToLayer(content:DisplayObject):void {
			trace("add: " + content );
			contentContainer.addChild(content);
			
			activeContentList.push(content);
		}
		
		public function clearAllContent():void {
			
			trace(this + " clearAllContent()");
			
			for ( var i:int=0; i<activeContentList.length; i++ ) {
				var content:TouchComponent = activeContentList[i] as TouchComponent;
				trace(this + " Dispose()" );
				content.Dispose();
			}
			
			activeContentList = new Array();
		}
		
		
		private function timerPressFunction(e:TimerEvent):void {
			iconFoto.transform.colorTransform = new ColorTransform();
			pressedFoto = false;
		}
		
		private function timerPressTekstFunction(e:TimerEvent):void {
			iconTekst.transform.colorTransform = new ColorTransform();
			pressedTekst = false;
		}
		
		private function timerPressVideoFunction(e:TimerEvent):void {
			iconVideo.transform.colorTransform = new ColorTransform();
			pressedVideo = false;
		}

		protected function updateLens(e:TimerEvent):void // update the lense when something moves
		{
			// no longer needed: content is over lens
			//magnifier.captureBitmap();
		}

		private function videoHandler(event:Event):void // make a video instance
		{
			var timerPressVideo:Timer = new Timer(3000,1);
			timerPressVideo.addEventListener(TimerEvent.TIMER, timerPressVideoFunction);
			timerPressVideo.start();
			if(pressedVideo == false){
				
				var colorize:ColorTransform = new ColorTransform(1.0,1.0,1.0,0.4);
				iconVideo.transform.colorTransform = colorize;
				
				pressedVideo = true;

				var i = contentId;
				youTubeViewer = new YouTubeViewer(i,guiTouch,magnifier);
				youtubeList[i] = youTubeViewer;
				
				addContentToLayer(youtubeList[i]);
				
				if (parent.x < 640)
				{
					offset = 550;
				}
				else
				{
					offset = -550;
				}
				youtubeList[i].x = parent.x + offset;
				youtubeList[i].y = parent.y + Y_OFFSET;
				var timer2:Timer = new Timer(40,25);
				timer2.addEventListener(TimerEvent.TIMER, updateLens);
				timer2.start();
			}
		}

		public function outFocus():void // Magnifier off marker
		{
			if (uitgeschoven == true)
			{
				removeChild(holder);
				uitgeschoven = false;
			}

			removeChild(alles);
			removeChild(rotateTekstCircle);
			rotateTekstCircle.removeChild(_textTitle);
			rotateTekstCircle.removeChild(_textDesc);
			removeEventListener(TouchEvent.TOUCH_UP,streamHandler);
			removeEventListener(TouchEvent.TOUCH_UP,flickrHandler);
			removeEventListener(TouchEvent.TOUCH_UP,videoHandler);
			activeConcept = false;
			activeConstruction = true;
			activeResultaat = false;

			geenVideo = false;
			geenFoto = false;
			geenTekst = false;
			prevTouch = "";
			
			if ( !Player.isAir ) sound3.play();
		}

	}
}