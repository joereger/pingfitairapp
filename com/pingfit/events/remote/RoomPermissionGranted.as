package com.pingfit.events.remote {
	
	import com.pingfit.alerts.*;
	import com.pingfit.data.static.Rooms;
	
	public class RoomPermissionGranted extends RemoteEventBase {
		
		public function RoomPermissionGranted() {
			super();
			setType("ROOMPERMISSIONGRANTED");
		}
		
		public function setArgsLocal(roomid:int, roomname:String):void {
			setArg1(String(roomid));
			setArg2(roomname);
		}	
		
		public override function invokeLocalEvent():void {
			//Dispatch somethin' or do somethin'
			Rooms.refreshViaAPI();
			AlertCoordinator.newAlert("You now have permission to enter the room '"+getRoomname()+"'.", "", null);
		}
		
		public function getRoomid():int { return int(getArg1()); }
		public function getRoomname():String { return getArg2(); }

	}
	
}