package com.pingfit.events.remote {
	
	import com.pingfit.alerts.*;
	import com.pingfit.data.static.Notifications;
	
	public class NewRoomPermissionRequest extends RemoteEventBase {
		
		public function NewRoomPermissionRequest() {
			super();
			setType("NEWROOMPERMISSIONREQUEST");
		}
		
		public function setArgsLocal(roomid:int, useridrequesting:int, nicknamerequesting:String):void {
			setArg1(String(roomid));
			setArg2(String(useridrequesting));
			setArg3(nicknamerequesting);
		}	
		
		public override function invokeLocalEvent():void {
			//Dispatch somethin' or do somethin'
			Notifications.refreshViaAPI();
			AlertCoordinator.newAlert("'"+getNicknamerequesting()+"' wants to enter a room you created or moderated.", "", null);
		}
		
		public function getRoomid():int { return int(getArg1()); }
		public function getUseridrequesting():int { return int(getArg2()); }
		public function getNicknamerequesting():String { return getArg2(); }

	}
	
}