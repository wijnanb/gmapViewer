package environments
{
	[SWF(width='1280', height='800', backgroundColor='#000000')]
	public class Table extends Main
	{
		public function Table()
		{
			Global.environment = Global.ENV_TABLE;
			
			super();
		}
	}
}