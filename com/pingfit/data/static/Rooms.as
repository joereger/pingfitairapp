package com.pingfit.data.static {
	
	import flash.events.*;
	import com.pingfit.data.objects.*;
	import com.pingfit.xml.CallGetRooms;
	import com.pingfit.events.ApiCallSuccess;
	import com.pingfit.events.ApiCallFail;
	
	public class Rooms extends EventDispatcher {
		
		private static var rooms:Array;
		
		public function Rooms() { }
		
		public static function load(xmlData:XML):void{
			var rooms:Array = new Array();
			if (xmlData!=null){
				var roomsinxml:XMLList  = xmlData.room;
				for each (var rmXml:XML in roomsinxml) {
					var rmObj:Room = new Room();
					rmObj.load(rmXml);
					rooms.push(rmObj);
				}
			}
			Rooms.setRooms(rooms);
		}
		
		public static function getRooms():Array{
			return rooms;
		} 
		public static function setRooms(rooms:Array):void{
			Rooms.rooms=rooms;
		}
		public static function getRoomByRoomidStr(roomid:String):Room {
			try{
				var roomidInt:int = int(roomid);
				return Rooms.getRoomByRoomid(roomidInt);
			} catch (error:Error) { trace("Rooms.as: " + error);  }
			return null;
		}
		public static function getRoomByRoomid(roomid:int):Room{
			for each (var room:Room in rooms) {
				if (room.getRoomid()==roomid){
					return room;
				}
			}
			return null;
		}
		
		
		
		//Data refreshing
		public static function refreshViaAPI():void{
			trace("refreshViaAPI()");
			var apiCaller:CallGetRooms = new CallGetRooms();
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onApiCallSuccess);
			apiCaller.addEventListener(ApiCallFail.TYPE, onApiCallFail);
		}
		private static function onApiCallSuccess(e:ApiCallSuccess):void{
			trace("onApiCallSuccess()");
			load(e.xmlData.rooms[0]);
		}
		private static function onApiCallFail(e:ApiCallFail):void{
			trace("onApiCallFail() - e.error="+e.error);
		}
		
	
	}
	
}