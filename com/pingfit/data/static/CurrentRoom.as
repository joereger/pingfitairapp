package com.pingfit.data.static {
	
	import flash.events.*;
	import com.pingfit.data.objects.*;
	import com.pingfit.data.static.CurrentRoom;
	import com.pingfit.events.ApiCallSuccess;
	import com.pingfit.events.ApiCallFail;
	import com.pingfit.xml.CallGetCurrentRoom;
	
	public class CurrentRoom extends EventDispatcher {
		
		private static var currentRoom:Room;
		
		public function CurrentRoom() { }
		
		public static function load(xmlData:XML):void{
			if (xmlData!=null){
				var room:com.pingfit.data.objects.Room = new com.pingfit.data.objects.Room();
				room.load(xmlData);
				CurrentRoom.setCurrentRoom(room);
			}
		}
		
		public static function getCurrentRoom():Room{
			return currentRoom;
		} 
		public static function setCurrentRoom(currentRoom:Room):void{
			CurrentRoom.currentRoom=currentRoom;
		}
		
		
	
		//Data refreshing
		public static function refreshViaAPI():void{
			trace("refreshViaAPI()");
			var apiCaller:CallGetCurrentRoom = new CallGetCurrentRoom();
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onApiCallSuccess);
			apiCaller.addEventListener(ApiCallFail.TYPE, onApiCallFail);
		}
		private static function onApiCallSuccess(e:ApiCallSuccess):void{
			trace("onApiCallSuccess()");
			load(e.xmlData.room[0]);
		}
		private static function onApiCallFail(e:ApiCallFail):void{
			trace("onApiCallFail() - e.error="+e.error);
		}
		
	
	}
	
}