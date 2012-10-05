package com.pingfit.data.static {
	
	import com.pingfit.xml.CallGetNotifications;
	import flash.events.*;
	import com.pingfit.data.objects.*;
	import com.pingfit.xml.*;
	import com.pingfit.events.ApiCallSuccess;
	import com.pingfit.events.ApiCallFail;
	import com.pingfit.events.*;

	
	public class Notifications extends EventDispatcher {
		
	
		
		public function Notifications() { }
		
		public static function load(xmlData:XML):void{
			if (xmlData!=null){
				FriendRequests.load(xmlData.friendrequests[0]);
				RoomPermissionRequests.load(xmlData.roompermissionrequests[0]);
			}
		}
		
		
		public static function getNumberOfNotifications():int {
			var out:int = 0;
			if (FriendRequests.getUsers()!=null) {
				out = out + FriendRequests.getUsers().length;
			}
			if (RoomPermissionRequests.getRoomPermissionRequests()!=null) {
				out = out + RoomPermissionRequests.getRoomPermissionRequests().length;
			}
			return out;
		}
		
		
		//Data refreshing
		public static function refreshViaAPI():void{
			trace("refreshViaAPI()");
			var apiCaller:CallGetNotifications = new CallGetNotifications();
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onApiCallSuccess);
			apiCaller.addEventListener(ApiCallFail.TYPE, onApiCallFail);
		}
		private static function onApiCallSuccess(e:ApiCallSuccess):void{
			trace("onApiCallSuccess()");
			load(e.xmlData.notifications[0]);
			Broadcaster.dispatchEvent(new PEvent(PEvent.NOTIFICATIONSLOADED));
		}
		private static function onApiCallFail(e:ApiCallFail):void{
			trace("onApiCallFail() - e.error="+e.error);
		}
		
	
	}
	
}