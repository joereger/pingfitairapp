package com.pingfit.events.remote {
	
	import com.pingfit.alerts.*;
	import com.pingfit.data.static.Notifications;
	
	public class NewFriendRequest extends RemoteEventBase {
		
		public function NewFriendRequest() {
			super();
			setType("NEWFRIENDREQUEST");
		}
		
		public function setArgsLocal(useridrequesting:int, nicknamerequesting:String):void {
			setArg1(String(useridrequesting));
			setArg2(nicknamerequesting);
		}	
		
		public override function invokeLocalEvent():void {
			//Dispatch somethin' or do somethin'
			Notifications.refreshViaAPI();
			AlertCoordinator.newAlert("'"+getNicknamerequesting()+"' wants to be your friend.", "", null);
		}
		
		public function getUseridrequesting():int { return int(getArg1()); }
		public function getNicknamerequesting():String { return getArg2(); }

	}
	
}