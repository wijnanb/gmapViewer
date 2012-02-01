package
{
	public class MapData
	{
		public var name:String;
		public var contentFile:String;
		
		public static const COLORSCHEME_YELLOW:String = "yellow";
		public static const COLORSCHEME_GREEN:String = "green";
		
		public function MapData(name:String, contentFile:String)
		{
			this.name = name;
			this.contentFile = contentFile;
		}
		
		public static function getStyle(colorScheme:String=COLORSCHEME_YELLOW):String {
			
			var styles:Array = new Array();
			var themeColor:String;
						
			switch ( colorScheme ) {
				case COLORSCHEME_GREEN:
					themeColor = "0x00e293";
					break;
				case COLORSCHEME_YELLOW:
					themeColor = "0xffe293";
					break;
			}
			
			styles.push( "feature:all|element:geometry|hue:"+themeColor+"|saturation:80|lightness:25|gamma:0|visibility:simplified" );
			styles.push( "feature:all|element:labels|visibility:off" );
			styles.push( "feature:road.local|element:geometry|visibility:simplified|lightness:-50|gamma:3|saturation:-30" );
			styles.push( "feature:road.highway|element:geometry|hue:"+themeColor+"|visibility:simplified" );
			styles.push( "feature:road.arterial|element:geometry|hue:"+themeColor+"|visibility:simplified" );
			styles.push( "feature:landscape|element:geometry|hue:"+themeColor+"|visibility:simplified" );
			styles.push( "feature:landscape.man.made|element:geometry|hue:"+themeColor+"|visibility:off" );
			styles.push( "feature:landscape.natural|element:geometry|hue:"+themeColor+"|visibility:simplified" );
			styles.push( "feature:water|element:geometry|hue:"+themeColor+"|visibility:simplified" );
			styles.push( "feature:transit|element:geometry|hue:0x000000|lightness:1|saturation:-1|gamma:0.1|visibility:on" );
			styles.push( "feature:poi|element:geometry|visibility:off" );
			styles.push( "feature:administrative|element:geometry|visibility:off" );
			
			for ( var i:int=0; i<styles.length; i++ ) {
				styles[i] = "&style=" + styles[i];
			}
			
			return styles.join("");
		}
		
		public static function getMarkers(markers:Array):String {
			var output:Array = new Array();
			
			for ( var i:int=0; i<markers.length; i++ ) {
				var m:Marker = Marker( markers[i] );
				output.push( "&markers=size:tiny|color:green|" + m.lat + "," + m.lng );
			}
			
			return output.join("");
		}
	}
}