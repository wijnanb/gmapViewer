package id.element
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamInfo;
	import flash.net.NetStreamPlayOptions;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
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
		
		public var offlineMode:Boolean = true;
		protected var offlineVideo:Video;
		protected var offlineNetstream:NetStream;
		protected var offlineNetConnection:NetConnection;
		protected var offlineVideoURL:String;
		protected var offlineVideoPlayTimeout:int;
		protected var offlineProgressTimer:Timer;
		protected var offlineVideoDuration:Number;
		
		[Embed(source="../../../assets/interface/youtube_play.png")]
		protected var playButtonGraphic:Class;
		protected var playButton:Bitmap;
		
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
			offlineMode = Player.runOffline;
			
			if ( offlineMode ) {
				offlineVideoURL = Player.offlineHost + "videos/"+_url+".mp4";
				setupOfflineVideoConnection();
			} else {
				uTubeLoader = new Loader();
				uTubeLoader.contentLoaderInfo.addEventListener(Event.INIT,uTubeLoaderInit);
				uTubeLoader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
				
				youTubeTimer=new Timer(100);
				youTubeTimer.addEventListener(TimerEvent.TIMER, updateUTubeTime, false, 0, true);
			}
		}
		
		protected function setupOfflineVideoConnection():void {
			offlineNetConnection = new NetConnection();
			offlineNetConnection.addEventListener(NetStatusEvent.NET_STATUS, offlineNetStatusHandler);
			offlineNetConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function securityErrorHandler(event:SecurityErrorEvent):void {trace("securityErrorHandler: " + event);});
			offlineNetConnection.connect(null);
		}
		
		private function offlineNetStatusHandler(event:NetStatusEvent):void {
			switch (event.info.code) {
				case "NetConnection.Connect.Success":
					offlineVideoStart();
					break;
				case "NetStream.Play.StreamNotFound":
					trace("Offline video stream not found: ");
					break;
			}
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}
		
		private function offlineVideoStart():void {
			offlineNetstream = new NetStream(offlineNetConnection);
			offlineNetstream.addEventListener(NetStatusEvent.NET_STATUS, offlineNetStatusHandler);
			var streamClient:Object = new Object();
			streamClient.onMetaData = onMetaData;
			streamClient.onCuePoint = onCuePoint;
			streamClient.onPlayStatus = onPlayStatus;
			offlineNetstream.client = streamClient;
			
			width = 640;
			height = 360;
			
			graphics.beginFill(0x000000);
			graphics.drawRect(0,0,width,height);

			clearTimeout(offlineVideoPlayTimeout);
			offlineVideoPlayTimeout = setTimeout(function():void{
				offlineVideo = new Video(width, height);
				offlineVideo.attachNetStream(offlineNetstream);
				
				offlineNetstream.play(offlineVideoURL);
				offlineNetstream.pause();
				
				offlineProgressTimer = new Timer(500);
				offlineProgressTimer.addEventListener(TimerEvent.TIMER, onOfflineVideoPlayheadUpdate);
				offlineProgressTimer.start();
				
				addChild(offlineVideo);
				
				playButton = new playButtonGraphic();
				playButton.smoothing = true;
				playButton.x = (width - playButton.width)/2;
				playButton.y = (height - playButton.height)/2;
				addChild(playButton);
			}, 2000 );
			
			super.layoutUI();
		}
		
		protected function onMetaData(info:Object):void {
			//trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
			offlineVideoDuration = info.duration;
		}
		protected function onCuePoint(info:Object):void {
			//trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
		}
		protected function onPlayStatus(info:Object):void {
			//trace("play status: " + info.status);
		}
		
		protected function onOfflineVideoPlayheadUpdate(e:TimerEvent):void {
			if (offlineVideoDuration) {
				var time:Number = offlineNetstream.time;
				var progress:Number = time / offlineVideoDuration;
				
				var left:String=Math.floor(time/60).toString();
				var right:String = (Math.floor(time) - Number(left) * 60).toString();
				_timeFormated = String(left.length > 1 ? left : "0" + left ) + ":" + (right.length > 1 ? right : "0" + right);
				dispatchEvent(new Event(YouTubePlayer.TIME, true, true));
			}
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
			player.cueVideoById(_url);
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
			if (offlineMode) {
				offlineNetstream.resume();
				playButton.visible = false;
			} else {
				player.playVideo();
				youTubeTimer.start();
			}
		}

		public function pause():void
		{
			if (offlineMode) {
				offlineNetstream.pause();
			} else {
				if(player.getPlayerState()!=-1)
				{
					player.pauseVideo();
					youTubeTimer.stop();
				}
			}
		}
		public function destroy():void
		{
			if (offlineMode) {
				offlineNetstream.removeEventListener(NetStatusEvent.NET_STATUS, offlineNetStatusHandler);
				offlineNetstream.close();
				
				offlineNetConnection.removeEventListener(NetStatusEvent.NET_STATUS, offlineNetStatusHandler);
				offlineNetConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, function securityErrorHandler(event:SecurityErrorEvent):void {trace("securityErrorHandler: " + event);});
				offlineNetConnection.close();
				
				if (offlineProgressTimer) {
					offlineProgressTimer.stop();
					offlineProgressTimer.removeEventListener(TimerEvent.TIMER, onOfflineVideoPlayheadUpdate);
				}
				clearTimeout(offlineVideoPlayTimeout);
			} else {
				player.stopVideo();
				player.destroy();	
			}
		}

		public function back():void
		{
			if (offlineMode) {
				
			} else {
				player.seekTo(0, false);
				
				if(player.getPlayerState()==2)
				{
					 updateUTubeTime(null);
				}
			}
		}

		public function forward():void
		{
			if (offlineMode) {
				
			} else {
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