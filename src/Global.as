package
{
	import id.template.MagnifierViewer;

	public class Global
	{
		public static var viewer:MagnifierViewer;
		public static var MULTIMAPMODE:Boolean = false;
		public static var MAGNIFIER_ON_TOP:Boolean = false;
		
		public static var environment:String = ENV_DESKTOP;
		
		public static const ENV_DESKTOP:String = "desktop";
		public static const ENV_ANDROID:String = "android";
		public static const ENV_TABLE:String = "table";
	}
}