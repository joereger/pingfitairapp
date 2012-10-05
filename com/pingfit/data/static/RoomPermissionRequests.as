package com.pingfit.data.static {
	
	import flash.events.*;
	import com.pingfit.data.objects.*;
	import com.pingfit.xml.CallGetRoomPermissionRequests;
	import com.pingfit.events.ApiCallSuccess;
	import com.pingfit.events.ApiCallFail;
	
	public class RoomPermissionRequests extends EventDispatcher {
		
		private static var roomPermissionRequests:Array;
		
		public function RoomPermissionRequests() { }
		
		public static function load(xmlData:XML):void{
			var roomPermissionRequests:Array = new Array();
			if (xmlData!=null){
				var requestsinxml:XMLList  = xmlData.roompermissionrequest;
				for each (var rprXml:XML in requestsinxml) {
					var rprObj:RoomPermissionRequest = new RoomPermissionRequest();
					rprObj.load(rprXml);
					roomPermissionRequests.push(rprObj);
				}
			}
			RoomPermissionRequests.setRoomPermissionRequests(roomPermissionRequests);
		}
		
		public static function getRoomPermissionRequests():Array{
			return roomPermissionRequests;
		} 
		public static function setRoomPermissionRequests(roomPermissionRequests:Array):void{
			RoomPermissionRequests.roomPermissionRequests=roomPermissionRequests;
		}
		public static function getRoomPermissionRequestByUserid(userid:int):RoomPermissionRequest{
			for each (var roomPermissionRequest:RoomPermissionRequest in roomPermissionRequests) {
				if (roomPermissionRequest.getUseridofrequestor()==userid){
					return roomPermissionRequest;
				}
			}
			return null;
		}
		public static function getRoomPermissionRequestByRoomid(roomid:int):Array{
			var roomPermissionRequests:Array = new Array();
			for each (var roomPermissionRequest:RoomPermissionRequest in roomPermissionRequests) {
				if (roomPermissionRequest.getRoomid()==roomid){
					roomPermissionRequests.push(roomPermissionRequest);
				}
			}
			return roomPermissionRequests;
		}
		
		
		
		//Data refreshing
		public static function refreshViaAPI():void{
			trace("refreshViaAPI()");
			var apiCaller:CallGetRoomPermissionRequests = new CallGetRoomPermissionRequests();
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onApiCallSuccess);
			apiCaller.addEventListener(ApiCallFail.TYPE, onApiCallFail);
		}
		private static function onApiCallSuccess(e:ApiCallSuccess):void{
			trace("onApiCallSuccess()");
			load(e.xmlData.roompermissionrequests[0]);
		}
		private static function onApiCallFail(e:ApiCallFail):void{
			trace("onApiCallFail() - e.error="+e.error);
		}
		
	
	}
	
}