package com.pingfit.data.static {
	
	import flash.events.*;
	import com.pingfit.data.objects.*;
	import com.pingfit.xml.CallGetFriendRequests;
	import com.pingfit.events.ApiCallSuccess;
	import com.pingfit.events.ApiCallFail;
	
	public class FriendRequests extends EventDispatcher {
		
		private static var users:Array;
		
		public function FriendRequests() { }
		
		public static function load(xmlData:XML):void{
			var users:Array = new Array();
			if (xmlData!=null){
				var friendrequestsinxml:XMLList  = xmlData.user;
				for each (var usXml:XML in friendrequestsinxml) {
					var usObj:User = new User();
					usObj.load(usXml);
					users.push(usObj);
				}
			}
			FriendRequests.setUsers(users);
		}
		
		public static function getUsers():Array{
			return users;
		} 
		public static function setUsers(users:Array):void{
			FriendRequests.users=users;
		}
		public static function getFriendRequestByUserid(userid:int):User{
			for each (var user:User in users) {
				if (user.getUserid()==userid){
					return user;
				}
			}
			return null;
		}
		
		
		
		//Data refreshing
		public static function refreshViaAPI():void{
			trace("refreshViaAPI()");
			var apiCaller:CallGetFriendRequests = new CallGetFriendRequests();
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onApiCallSuccess);
			apiCaller.addEventListener(ApiCallFail.TYPE, onApiCallFail);
		}
		private static function onApiCallSuccess(e:ApiCallSuccess):void{
			trace("onApiCallSuccess()");
			load(e.xmlData.friendrequests[0]);
		}
		private static function onApiCallFail(e:ApiCallFail):void{
			trace("onApiCallFail() - e.error="+e.error);
		}
		
	
	}
	
}