package
{
	import com.google.maps.Map3D;
	import com.google.maps.StyledMapType;
	import com.google.maps.StyledMapTypeOptions;
	import com.google.maps.styles.MapTypeStyle;
	import com.google.maps.styles.MapTypeStyleElementType;
	import com.google.maps.styles.MapTypeStyleFeatureType;
	import com.google.maps.styles.MapTypeStyleRule;

	public class MapData
	{
		public var name:String;
		public var contentFile:String;
		
		public static var gMap:Map3D;
		
		public function MapData(name:String, contentFile:String)
		{
			this.name = name;
			this.contentFile = contentFile;
		}
		
		public static function getZOutMapType():StyledMapType {
			var style:Array = [
				new MapTypeStyle(
						MapTypeStyleFeatureType.ROAD_HIGHWAY,
						MapTypeStyleElementType.GEOMETRY,
						[	MapTypeStyleRule.hue(0xffe293),
							MapTypeStyleRule.visibility("simplified"), 
							MapTypeStyleRule.visibility("on")]
				),
			
				new MapTypeStyle(
					MapTypeStyleFeatureType.ROAD_HIGHWAY,
					MapTypeStyleElementType.LABELS,
					[MapTypeStyleRule.visibility("off")]
				),
			
				new MapTypeStyle(
					MapTypeStyleFeatureType.ROAD_ARTERIAL,
					MapTypeStyleElementType.GEOMETRY,
					[	MapTypeStyleRule.hue(0xffe293),
						MapTypeStyleRule.visibility("simplified"), 
						MapTypeStyleRule.visibility("on")]
				),
			
				new MapTypeStyle(
					MapTypeStyleFeatureType.ROAD_ARTERIAL,
					MapTypeStyleElementType.LABELS,
					[MapTypeStyleRule.visibility("off")]
				),
			
				new MapTypeStyle(
					MapTypeStyleFeatureType.ROAD_LOCAL,
					MapTypeStyleElementType.GEOMETRY,
					[	MapTypeStyleRule.hue(0xffe293),
						MapTypeStyleRule.lightness(-50), 
						MapTypeStyleRule.gamma(3),
						MapTypeStyleRule.saturation(-30), 
						MapTypeStyleRule.visibility("simplified"), 
						MapTypeStyleRule.visibility("on")]
				),
				
				new MapTypeStyle(
					MapTypeStyleFeatureType.ROAD_LOCAL,
					MapTypeStyleElementType.LABELS,
					[MapTypeStyleRule.visibility("off")]
				),
				
				new MapTypeStyle(
					MapTypeStyleFeatureType.LANDSCAPE,
					MapTypeStyleElementType.GEOMETRY,
					[	MapTypeStyleRule.hue(0xffe293),
						MapTypeStyleRule.visibility("simplified"), 
						MapTypeStyleRule.visibility("on")]
				),
			
				new MapTypeStyle(
					MapTypeStyleFeatureType.LANDSCAPE,
					MapTypeStyleElementType.LABELS,
					[MapTypeStyleRule.visibility("off")]
				),
			
				new MapTypeStyle(
					MapTypeStyleFeatureType.LANDSCAPE_MAN_MADE,
					MapTypeStyleElementType.GEOMETRY,
					[	MapTypeStyleRule.hue(0xffe293),
						MapTypeStyleRule.visibility("off"), 
						MapTypeStyleRule.visibility("simplified")]
				),
					
				new MapTypeStyle(
					MapTypeStyleFeatureType.LANDSCAPE_NATURAL,
					MapTypeStyleElementType.GEOMETRY,
					[	MapTypeStyleRule.hue(0xffe293),
						MapTypeStyleRule.visibility("on"),
						MapTypeStyleRule.visibility("simplified")]
				),
					
				new MapTypeStyle(
					MapTypeStyleFeatureType.ROAD_LOCAL,
					MapTypeStyleElementType.GEOMETRY,
					[	MapTypeStyleRule.hue(0xffe293),
						MapTypeStyleRule.visibility("off")]
				),
							
				new MapTypeStyle(
					MapTypeStyleFeatureType.ROAD_LOCAL,
					MapTypeStyleElementType.LABELS,
					[MapTypeStyleRule.visibility("off")]
				),
				
				new MapTypeStyle(
					MapTypeStyleFeatureType.ADMINISTRATIVE,
					MapTypeStyleElementType.GEOMETRY,
					[MapTypeStyleRule.visibility("off")]
				),
			
				new MapTypeStyle(
					MapTypeStyleFeatureType.ADMINISTRATIVE,
					MapTypeStyleElementType.LABELS,
					[MapTypeStyleRule.visibility("off")]
				),
			
				new MapTypeStyle(
					MapTypeStyleFeatureType.POI,
					MapTypeStyleElementType.GEOMETRY,
					[MapTypeStyleRule.visibility("off")]
				),
							
				new MapTypeStyle(
					MapTypeStyleFeatureType.POI,
					MapTypeStyleElementType.LABELS,
					[MapTypeStyleRule.visibility("off")]
				),
				
				new MapTypeStyle(
					MapTypeStyleFeatureType.WATER,
					MapTypeStyleElementType.GEOMETRY,
					[	MapTypeStyleRule.visibility("off"),
						MapTypeStyleRule.hue(0xffe293),
						MapTypeStyleRule.visibility("simplified")]
				),
				
				new MapTypeStyle(
					MapTypeStyleFeatureType.WATER,
					MapTypeStyleElementType.LABELS,
					[MapTypeStyleRule.visibility("off")]
				),
				
				new MapTypeStyle(
					MapTypeStyleFeatureType.ALL,
					MapTypeStyleElementType.GEOMETRY,
					[	MapTypeStyleRule.visibility("on"), 
						MapTypeStyleRule.hue(0xffe293), 
						MapTypeStyleRule.saturation(80), 
						MapTypeStyleRule.lightness(25),
						MapTypeStyleRule.gamma(0),
						MapTypeStyleRule.visibility("simplified")]
				),
		
				new MapTypeStyle(
					MapTypeStyleFeatureType.TRANSIT,
					MapTypeStyleElementType.GEOMETRY,
					[	MapTypeStyleRule.visibility("on"), 
						MapTypeStyleRule.hue(0x000000), 
						MapTypeStyleRule.lightness(1), 
						MapTypeStyleRule.saturation(-1), 
						MapTypeStyleRule.gamma(0.1)]
				),
				
				new MapTypeStyle(
					MapTypeStyleFeatureType.TRANSIT,
					MapTypeStyleElementType.LABELS,
					[MapTypeStyleRule.visibility("off")]
				)	
			];
					
					
			var options:StyledMapTypeOptions = new StyledMapTypeOptions({
				name: 'Z-out',
				minResolution: 2,
				maxResolution: 20, 
				alt: 'Z-out'
			});
			
			return new StyledMapType(style,options);
		}			
	}
}