package com.pingfit.events {
	
	import flash.events.Event;
	import com.pingfit.data.objects.Room;
	
	public class LeaveRoom extends Event {
		
		public static const TYPE:String = "LeaveRoom";
		public var room:Room;  
		
		public function LeaveRoom(room:Room) { 
			this.room = room;
			super(TYPE, true, true);
		}
		
		public override function clone():Event{
			return new LeaveRoom(room);
		}

	}
	
}