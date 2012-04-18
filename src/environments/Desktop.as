package environments
{
	[SWF(width='1280', height='800', backgroundColor='#000000')]
	public class Desktop extends Main
	{
		public function Desktop()
		{
			Global.environment = Global.ENV_DESKTOP;
			
			super();
		}
	}
}