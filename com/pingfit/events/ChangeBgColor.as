package com.pingfit.events {
	
	import flash.events.Event;
	
	public class ChangeBgColor extends Event {
		
		public static var TYPE:String = "ChangeBgColor";
		public var color:int;  
		
		public function ChangeBgColor(color:int) { 
			this.color = color;
			super(TYPE, true, true);
		}
		
		public override function clone():Event{
			return new ChangeBgColor(color);
		}

	}
	
}