package
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import gl.events.TouchEvent;
	
	import id.core.TouchSprite;
	
	public class PITLogo extends TouchSprite
	{
		[Embed(source = "../assets/interface/pit_logo.png")]
		protected var IconLogo:Class;
		protected var iconLogo:DisplayObject = new IconLogo();
		
		[Embed(source = "../assets/interface/pit_info.svg")]
		protected var LogoInfo:Class;
		protected var logoInfo:DisplayObject = new LogoInfo();
		
		protected var logoHitArea:TouchSprite = new TouchSprite();
		protected var logoInfoHitArea:TouchSprite = new TouchSprite();
		
		protected var collapsed:Boolean = false;
		
		public function PITLogo()
		{
			super();
			
			logoInfo.visible = false;
			logoInfoHitArea.visible = false;
			
			iconLogo.x = 0;
			addChild(iconLogo);
			
			logoInfo.x = -248;
			logoInfo.y = -4;
			
			addChild(logoInfo);
			
			logoHitArea.graphics.beginFill(0x000000, 0.00001);
			logoHitArea.graphics.drawRect(-25,-80,150,180);
			logoHitArea.graphics.endFill();
			
			logoInfoHitArea.graphics.beginFill(0x000000, 0.00001);
			logoInfoHitArea.graphics.drawRect(-250,0,340,340);
			logoInfoHitArea.graphics.endFill();
			
			addChild(logoHitArea);
			addChild(logoInfoHitArea);
			
			iconLogo.addEventListener(TouchEvent.TOUCH_DOWN, onTouched);
			logoHitArea.addEventListener(TouchEvent.TOUCH_DOWN, onTouched);
		}
		
		protected function onTouched(e:TouchEvent):void {
			toggle();
		}
		
		protected function toggle():void {
			collapsed = ! collapsed;
			
			if (collapsed) {
				logoHitArea.removeEventListener(TouchEvent.TOUCH_DOWN, onTouched);
				logoInfoHitArea.addEventListener(TouchEvent.TOUCH_DOWN, onTouched);
				
				iconLogo.visible = false;
				logoInfo.visible = true;
				
				logoHitArea.visible = false;
				logoInfoHitArea.visible = true;
			} else {
				logoHitArea.addEventListener(TouchEvent.TOUCH_DOWN, onTouched);
				logoInfoHitArea.removeEventListener(TouchEvent.TOUCH_DOWN, onTouched);
				
				iconLogo.visible = true;
				logoInfo.visible = false;
				
				logoHitArea.visible = true;
				logoInfoHitArea.visible = false;
			}
		}
	}
}