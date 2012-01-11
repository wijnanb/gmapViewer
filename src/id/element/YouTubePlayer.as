package id.element
{
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.NetStatusEvent;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.system.Security;
	import id.core.TouchComponent;
	
	/**
	 * This is the YouTubePlayer class for the YouTubeViewer.
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	public class YouTubePlayer extends TouchComponent
	{
		public static var TIME:String = "Time";
		private var nc:NetConnection;
		public var youTubeTimer:Timer;
		public var ns:NetStream;
		private var video:Video;
		private var _width:Number;
		private var _height:Number;
		private var _url:String;
		private var _scale:Number=1;
		private var _pixels:Number=0;
		private var videoObject:Object;
		private var _timeFormated:String="00:00";
		public var timeUpdate:Boolean;
		private var count:int;

		private var player:Object;
		private var uTubeLoader:Loader;

		private var _initialize:Boolean;

		private var YOUTUBE_API_VERSION:String="2";
		private var YOUTUBE_API_FORMAT:String="5";

		public function YouTubePlayer()
		{
			super();
		}

		override public function Dispose():void
		{
			if (parent)
			{
				this.destroy();
				parent.removeChild(this);
			}
		}

		public function get url():String
		{
			return _url;
		}
		public function set url(value:String):void
		{
			_url=value;
			createUI();
			//commitUI();
		}

		public function get scale():Number
		{
			return _scale;
		}
		public function set scale(value:Number):void
		{
			_scale=value;
		}

		public function get pixels():Number
		{
			return _pixels;
		}
		public function set pixels(value:Number):void
		{
			_pixels=value;
		}

		public function get time():String
		{
			return _timeFormated;
		}
		override protected function createUI():void
		{
			//Security.allowInsecureDomain("*");
			//Security.allowDomain("*");

			uTubeLoader=new Loader();
			uTubeLoader.contentLoaderInfo.addEventListener(Event.INIT,uTubeLoaderInit);
			uTubeLoader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));

			youTubeTimer=new Timer(100);
			youTubeTimer.addEventListener(TimerEvent.TIMER, updateUTubeTime, false, 0, true);
		}

		override protected function commitUI():void
		{
		}
		override protected function layoutUI():void
		{

		}
		override protected function updateUI():void
		{
		}

		private function uTubeLoaderInit(event:Event):void
		{
			addChild(uTubeLoader);
			uTubeLoader.content.addEventListener("onReady",onPlayerReady);
			uTubeLoader.content.addEventListener("onError",onPlayerError);
			uTubeLoader.content.addEventListener("onStateChange",onPlayerStateChange);
			uTubeLoader.content.addEventListener("onPlaybackQualityChange",onVideoPlaybackQualityChange);
		}


		private function onPlayerReady(event:Event):void
		{
			player=uTubeLoader.content;
			//player.cueVideoByUrl('http://www.youtube.com/watch?v=' + _url + '&cc_load_policy=1');
			player.cueVideoById(_url);
			//player.cc_load_policy = true;
			trace('url: '+ _url);
		}

		private function onPlayerError(event:Event):void
		{
		}

		private function onPlayerStateChange(event:Event):void
		{
			if (Object(event).data==0)
			{
				player.seekTo(0, false);
			}

			if (Object(event).data==5)
			{
				width=player.width;
				height=player.height;
				
				super.layoutUI();
			}
		}

		private function onVideoPlaybackQualityChange(event:Event):void
		{
		}

		public function play():void
		{
			player.playVideo();
			//trace(player.getCurrentTime());
			youTubeTimer.start();
		}

		public function pause():void
		{
			if(player.getPlayerState()!=-1)
			{
				player.pauseVideo();
				youTubeTimer.stop();
			}
		}
		public function destroy():void
		{
			
				player.stopVideo();
				player.destroy();

			
		}

		public function back():void
		{
			player.seekTo(0, false);
			
			if(player.getPlayerState()==2)
			{
				 updateUTubeTime(null);
			}
		}

		public function forward():void
		{
			player.seekTo(player.getCurrentTime()+1, true);
			if(player.getPlayerState()==2)
			{
				 updateUTubeTime(null);
			}
			
			if(player.getDuration()==player.getCurrentTime())
			{
				player.seekTo(0, false);
			}
		}

		private function updateUTubeTime(e:Event):void
		{
			var value:Number=Math.round(player.getCurrentTime());
			var left:String=Math.floor(value/60).toString();
			var right:String = (Math.floor(value) - Number(left) * 60).toString();
			_timeFormated = String(left.length > 1 ? left : "0" + left ) + ":" + (right.length > 1 ? right : "0" + right);
			dispatchEvent(new Event(YouTubePlayer.TIME, true, true));
		}
	}
}