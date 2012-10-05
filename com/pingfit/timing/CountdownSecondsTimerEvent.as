package com.pingfit.timing {
	
	import flash.events.Event;
	
	public class CountdownSecondsTimerEvent extends Event {
		
		public static const ALARM:String = "CountdownSecondsTimerEventAlarm"; 
		public static const PAUSE:String = "CountdownSecondsTimerEventPause"; 
		public static const START:String = "CountdownSecondsTimerEventStart"; 

		public var typeZ:String;
		public var identifier:String;
		
		public function CountdownSecondsTimerEvent(type:String, identifier:String = "unidentified") { 
			this.typeZ = type;
			this.identifier = identifier;
			super(typeZ, true, true);
		}
		
		public override function clone():Event{
			return new CountdownSecondsTimerEvent(typeZ, identifier);
		}

	}
	
}