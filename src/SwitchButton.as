package
{
	import flash.text.TextField;
	
	import gl.events.TouchEvent;
	
	import id.core.TouchSprite;
	
	public class SwitchButton extends TouchSprite
	{
		public var caption:String;
		protected var textfield:TextField;
		public var size:Number = 100;
		
		public function SwitchButton(caption:String)
		{
			super();
			
			this.caption = caption;
			
			graphics.beginFill(0x36A9E1);
			graphics.drawRect(0, 0, size, size);
			graphics.endFill();
			
			textfield = new TextField();
			textfield.text = caption;
			addChild(textfield);
		}
	}
}