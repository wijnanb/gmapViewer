package environments
{
	[SWF(width='1920', height='1080', backgroundColor='#000000')]
	public class HDTable extends Main
	{
		public function HDTable()
		{
			Global.environment = Global.ENV_HDTABLE;
			
			super();
		}
	}
}