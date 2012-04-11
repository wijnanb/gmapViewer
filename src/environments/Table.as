package environments
{
	[SWF(width='1920', height='1080', backgroundColor='#000000')]
	public class Table extends Main
	{
		public function Table()
		{
			Global.environment = Global.ENV_TABLE;
			
			super();
		}
	}
}