package id.component
{
	import id.component.DrawACircle;
	import flash.text.*;
	import flash.events.TextEvent;
	import flash.events.Event;
	import flash.display.Sprite;

	public class LaderIcoon extends Sprite
	{
		private var myTextBox1:TextField = new TextField  ;
		 

		public function LaderIcoon()
		{
		
		}


		public function progresser(bezig:Boolean, xt:int, yt:int)
		{
			if (bezig == true)
			{
				trace('loading');
				myTextBox1.text = "Loading";
				myTextBox1.width = 200;
				myTextBox1.height = 50;
				myTextBox1.multiline = false;
				myTextBox1.wordWrap = false;
				myTextBox1.background = false;
				myTextBox1.border = false;

				addChild(myTextBox1);
				var circle:DrawACircle = new DrawACircle(xt, yt);
				addChild(circle);
			}
			
		}

	}

}