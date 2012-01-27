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
			
			
			/*
			
			+
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD_LOCAL,
				MapTypeStyleElementType.GEOMETRY,
				[MapTypeStyleRule.hue(0xffe293),
					MapTypeStyleRule.lightness(-50), 
					MapTypeStyleRule.gamma(3),
					MapTypeStyleRule.saturation(-30), 
					MapTypeStyleRule.visibility("simplified"), 
					MapTypeStyleRule.visibility("on")]),
			
			
			
			+
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD_HIGHWAY,
				MapTypeStyleElementType.GEOMETRY,
				[MapTypeStyleRule.hue(0xffe293),
					MapTypeStyleRule.visibility("simplified"), 
					MapTypeStyleRule.visibility("on")]),
			
			-
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD_HIGHWAY,
				MapTypeStyleElementType.LABELS,
				[MapTypeStyleRule.visibility("off")]),
			
			+
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD_ARTERIAL,
				MapTypeStyleElementType.GEOMETRY,
				[MapTypeStyleRule.hue(0xffe293),
					MapTypeStyleRule.visibility("simplified"), 
					MapTypeStyleRule.visibility("on")]),
			
			-
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD_ARTERIAL,
				MapTypeStyleElementType.LABELS,
				[MapTypeStyleRule.visibility("off")]),
			
			-
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD_LOCAL,
				MapTypeStyleElementType.GEOMETRY,
				[MapTypeStyleRule.hue(0xffe293),
					MapTypeStyleRule.lightness(-50), 
					MapTypeStyleRule.gamma(3),
					MapTypeStyleRule.saturation(-30), 
					MapTypeStyleRule.visibility("simplified"), 
					MapTypeStyleRule.visibility("on")]),
			-
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD_LOCAL,
				MapTypeStyleElementType.LABELS,
				[MapTypeStyleRule.visibility("off")]),
			
			+
			new MapTypeStyle(MapTypeStyleFeatureType.LANDSCAPE,
				MapTypeStyleElementType.GEOMETRY,
				[MapTypeStyleRule.hue(0xffe293),
					MapTypeStyleRule.visibility("simplified"), 
					MapTypeStyleRule.visibility("on")]),
			-
			new MapTypeStyle(MapTypeStyleFeatureType.LANDSCAPE,
				MapTypeStyleElementType.LABELS,
				[MapTypeStyleRule.visibility("off")]),
			
			-
			new MapTypeStyle(MapTypeStyleFeatureType.LANDSCAPE_MAN_MADE,
				MapTypeStyleElementType.GEOMETRY,
				[MapTypeStyleRule.hue(0xffe293),
					MapTypeStyleRule.visibility("off"), 
					MapTypeStyleRule.visibility("simplified")]),
			
			-
			new MapTypeStyle(MapTypeStyleFeatureType.LANDSCAPE_NATURAL,
				MapTypeStyleElementType.GEOMETRY,
				[MapTypeStyleRule.hue(0xffe293),
					MapTypeStyleRule.visibility("on"),
					MapTypeStyleRule.visibility("simplified")]),
			
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD_LOCAL,
				MapTypeStyleElementType.GEOMETRY,
				[MapTypeStyleRule.hue(0xffe293),
					MapTypeStyleRule.visibility("off")]),
			
			new MapTypeStyle(MapTypeStyleFeatureType.ROAD_LOCAL,
				MapTypeStyleElementType.LABELS,
				[MapTypeStyleRule.visibility("off")]),
			
			+
			new MapTypeStyle(MapTypeStyleFeatureType.ADMINISTRATIVE,
				MapTypeStyleElementType.GEOMETRY,
				[MapTypeStyleRule.visibility("off")]),
			
			-
			new MapTypeStyle(MapTypeStyleFeatureType.ADMINISTRATIVE,
				MapTypeStyleElementType.LABELS,
				[MapTypeStyleRule.visibility("off")]),
			+
			new MapTypeStyle(MapTypeStyleFeatureType.POI,
				MapTypeStyleElementType.GEOMETRY,
				[MapTypeStyleRule.visibility("off")]),
			
			-
			new MapTypeStyle(MapTypeStyleFeatureType.POI,
				MapTypeStyleElementType.LABELS,
				[MapTypeStyleRule.visibility("off")]),
			
			+
			new MapTypeStyle(MapTypeStyleFeatureType.WATER,
				MapTypeStyleElementType.GEOMETRY,
				[MapTypeStyleRule.visibility("off"),
					MapTypeStyleRule.hue(0xffe293),
					MapTypeStyleRule.visibility("simplified")]),
			
			-
			new MapTypeStyle(MapTypeStyleFeatureType.WATER,
				MapTypeStyleElementType.LABELS,
				[MapTypeStyleRule.visibility("off")]),
			
			
			+
			new MapTypeStyle(MapTypeStyleFeatureType.ALL,
				MapTypeStyleElementType.GEOMETRY,
				[MapTypeStyleRule.visibility("on"), 
					MapTypeStyleRule.hue(0xffe293), 
					MapTypeStyleRule.saturation(80), 
					MapTypeStyleRule.lightness(25),
					MapTypeStyleRule.gamma(0),
					MapTypeStyleRule.visibility("simplified")]) ,
			
			+
			new MapTypeStyle(MapTypeStyleFeatureType.TRANSIT,
				MapTypeStyleElementType.GEOMETRY,
				[MapTypeStyleRule.visibility("on"), 
					MapTypeStyleRule.hue(0x000000), 
					MapTypeStyleRule.lightness(1), 
					MapTypeStyleRule.saturation(-1), 
					MapTypeStyleRule.gamma(0.1)]) ,
			-
			new MapTypeStyle(MapTypeStyleFeatureType.TRANSIT,
				MapTypeStyleElementType.LABELS,
				[MapTypeStyleRule.visibility("off")]) ,
					
					
			];

			*/
			
			
			for ( var i:int=0; i<styles.length; i++ ) {
				styles[i] = "&style=" + styles[i];
			}
			
			return styles.join("");
		}
	}
}