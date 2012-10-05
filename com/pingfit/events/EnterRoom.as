package com.pingfit.events {
	
	import flash.events.Event;
	import com.pingfit.data.objects.Room;
	
	public class EnterRoom extends Event {
		
		public static const TYPE:String = "EnterRoom";
		public var room:Room;  
		
		public function EnterRoom(room:Room) { 
			this.room = room;
			super(TYPE, true, true);
		}
		
		public override function clone():Event{
			return new EnterRoom(room);
		}

	}
	
}