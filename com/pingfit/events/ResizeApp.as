package com.pingfit.events {
	
	import flash.events.Event;
	
	public class ResizeApp extends Event {
		
		public static var TYPE:String = "ResizeApp";
		public var maxWidth:Number; 
		public var maxHeight:Number;
		
		public function ResizeApp(maxWidth:Number, maxHeight:Number) { 
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			super(TYPE, true, true);
		}
		
		public override function clone():Event{
			return new ResizeApp(maxWidth, maxHeight);
		}

	}
	
}