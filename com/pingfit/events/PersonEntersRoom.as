package com.pingfit.events {
	
	import flash.events.Event;
	
	public class PersonEntersRoom extends Event {
		
		public static var TYPE:String = "PersonEntersRoomEvent";
		public var nickname:String;
		public var userid:String;
		public var facebookuid:String;

		
		public function PersonEntersRoom(nickname:String, userid:String, facebookuid:String) { 
			this.nickname = nickname;
			this.userid = userid;
			this.facebookuid = facebookuid;
			super(TYPE, true, true);
		}
		
		public override function clone():Event{
			return new PersonEntersRoom(nickname, userid, facebookuid);
		}

	}
	
}