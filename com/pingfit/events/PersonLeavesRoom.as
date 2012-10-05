package com.pingfit.events {
	
	import flash.events.Event;
	
	public class PersonLeavesRoom extends Event {
		
		public static var TYPE:String = "PersonLeavesRoomEvent";
		public var nickname:String;
		public var userid:String;
		public var facebookuid:String;
		
		public function PersonLeavesRoom(nickname:String, userid:String, facebookuid:String) { 
			this.nickname = nickname;
			this.userid = userid;
			this.facebookuid = facebookuid;
			super(TYPE, true, true);
		}
		
		public override function clone():Event{
			return new PersonLeavesRoom(nickname, userid, facebookuid);
		}

	}
	
}