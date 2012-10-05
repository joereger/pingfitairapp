package com.pingfit.format {
	
	import flash.filters.DropShadowFilter;
	
	public class Shadow {
		
		public function Shadow() { }
		
		public static function getDropShadowFilterArray(color:uint=0x000000, blur:Number=8, distance:Number=6, alpha:Number=.5):Array{
			var filtersArray:Array = new Array(getDropShadow(color, blur, distance, alpha));
			return filtersArray;
		}
		
		public static function getDropShadow(color:uint=0x000000, blur:Number=8, distance:Number=6, alpha:Number=.5):DropShadowFilter{
			var my_shadow:DropShadowFilter = new DropShadowFilter();  
			my_shadow.color = color;  
			my_shadow.blurY = blur;  
			my_shadow.blurX = blur;  
			my_shadow.angle = 45;  
			my_shadow.alpha = alpha;  
			my_shadow.distance = distance;   
			return my_shadow;
		}
	
		
	}
	
}