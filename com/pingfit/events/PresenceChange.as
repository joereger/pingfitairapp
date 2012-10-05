package com.pingfit.events {
	
	import flash.events.Event;
	
	public class PresenceChange extends Event {
		
		public static var TYPE:String = "PresenceChangeEvent";
		public var nickname:String;
		public var userid:String;
		public var roomid:String;
		public var roomname:String;
		public var userstatus:String;
		public var facebookuid:String;
		
		public function PresenceChange(nickname:String, userid:String, roomid:String, roomname:String, userstatus:String, facebookuid:String) { 
			this.nickname = nickname;
			this.userid = userid;
			this.roomid = roomid;
			this.roomname = roomname;
			this.userstatus = userstatus;
			this.facebookuid = facebookuid;
			super(TYPE, true, true);
		}
		
		public override function clone():Event{
			return new PresenceChange(nickname, userid, roomid, roomname, userstatus, facebookuid);
		}

	}
	
}