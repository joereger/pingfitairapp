package com.pingfit.events {
	
	import flash.events.Event;
	import com.pingfit.data.objects.Room;
	
	public class DisplayRoomInPanel extends Event {
		
		public static const TYPE:String = "DisplayRoomInPanelEvent";
		public var room:Room;  
		
		public function DisplayRoomInPanel(room:Room) { 
			this.room = room;
			super(TYPE, true, true);
		}
		
		public override function clone():Event{
			return new DisplayRoomInPanel(room);
		}

	}
	
}