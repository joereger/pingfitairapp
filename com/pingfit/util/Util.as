package com.pingfit.util {
	
	
	public class Util {
		
		public function Util() {	}
		
		
		
		public static function booleanFromString(booStr:String):Boolean {
			if (booStr==null || booStr=="") {
				return false;
			}
			if (booStr=="true" || booStr=="1") {
				return true;
			}
			return false;
		}
		
	}
	
}