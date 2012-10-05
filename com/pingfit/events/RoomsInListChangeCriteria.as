package com.pingfit.events {
	
	import flash.events.Event;

	
	public class RoomsInListChangeCriteria extends Event {
		
		public static var TYPE:String = "RoomsInListChangeCriteriaEvent";
		public var selectedIndex:int;  
		
		public function RoomsInListChangeCriteria(selectedIndex:int) { 
			this.selectedIndex = selectedIndex;
			super(TYPE, true, true);
		}
		
		public override function clone():Event{
			return new RoomsInListChangeCriteria(selectedIndex);
		}

	}
	
}