package com.pingfit.events.remote {
	
	import com.pingfit.alerts.*;
	import com.pingfit.data.static.Friends;
	
	public class FriendAccepted extends RemoteEventBase {
		
		public function FriendAccepted() {
			super();
			setType("FRIENDACCEPTED");
		}
		
		public function setArgsLocal(useridaccepting:int, nicknameaccepting:String):void {
			setArg1(String(useridaccepting));
			setArg2(nicknameaccepting);
		}	
		
		public override function invokeLocalEvent():void {
			//Dispatch somethin' or do somethin'
			Friends.refreshViaAPI();
			AlertCoordinator.newAlert("You're now friends with '" + getNicknameaccepting() + "'.", "", null);
		}
		
		public function getUseridaccepting():int { return int(getArg1()); }
		public function getNicknameaccepting():String { return getArg2(); }

	}
	
}