package com.pingfit.data.objects {
	
	public class RoomPermissionRequest {
		
		private var useridofrequestor:int;
		private var nicknameofrequestor:String;
		private var roomid:int;
		private var roomname:String;
		
		public function RoomPermissionRequest() { }
		
		public function load(xmlData:XML):void{
			if (xmlData!=null){
				useridofrequestor = int(xmlData.useridofrequestor);
				nicknameofrequestor = xmlData.nicknameofrequestor;
				roomid = int(xmlData.roomid);
				roomname = xmlData.roomname;
			}
		}
		
		
		
		
		
		public function getUseridofrequestor():int{return useridofrequestor;}
		public function setUseridofrequestor(useridofrequestor:int):void{this.useridofrequestor=useridofrequestor;}	
		
		public function getNicknameofrequestor():String{return nicknameofrequestor;}
		public function setNicknameofrequestor(nicknameofrequestor:String):void{this.nicknameofrequestor=nicknameofrequestor;}
		
		public function getRoomid():int{return roomid;}
		public function setRoomid(roomid:int):void{this.roomid=roomid;}
		
		public function getRoomname():String{return roomname;}
		public function setRoomname(roomname:String):void{this.roomname=roomname;}
		
		
	
	}
	
}