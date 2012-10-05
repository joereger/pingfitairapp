package com.pingfit.events {
	
	import flash.events.Event;
	
	public class RemoveMeFromScroller extends Event {
		
		public static var TYPE:String = "RemoveMeFromScrollerEvent";
		public var objectToRemove:Object;  
		
		public function RemoveMeFromScroller(objectToRemove:Object) { 
			this.objectToRemove = objectToRemove;
			super(TYPE, true, true);
		}
		
		public override function clone():Event{
			return new RemoveMeFromScroller(objectToRemove);
		}

	}
	
}