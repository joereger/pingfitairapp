package com.pingfit.events {
	
	import flash.events.Event;
	
	public class MessageToRoom extends Event {
		
		public static var TYPE:String = "MessageToRoomEvent";
		public var msg:String;
		public var nickname:String;
		public var userid:String;
		public var messagetype:String;
		public var roomid:String;
		
		public function MessageToRoom(msg:String, nickname:String, userid:String, messagetype:String, roomid:String) { 
			this.msg = msg;
			this.nickname = nickname;
			this.userid = userid;
			this.messagetype = messagetype;
			this.roomid = roomid;
			super(TYPE, true, true);
		}
		
		public override function clone():Event{
			return new MessageToRoom(msg, nickname, userid, messagetype, roomid);
		}

	}
	
}