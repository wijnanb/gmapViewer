package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class EFROLogo extends Sprite
	{
		[Embed(source = "../assets/interface/efro.png")]
		protected var IconLogo:Class;
		protected var iconLogo:DisplayObject;
		
		public function EFROLogo()
		{
			super();
			
			iconLogo = new IconLogo();
			addChild(iconLogo);
		}
	}
}