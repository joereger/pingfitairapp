package com.pingfit.data.static {
	
	import com.pingfit.events.PEvent;
	import flash.events.*;
	import com.pingfit.data.objects.*;
	import com.pingfit.xml.CallGetFriends;
	import com.pingfit.events.ApiCallSuccess;
	import com.pingfit.events.ApiCallFail;
	import com.pingfit.events.Broadcaster;
	import com.pingfit.events.PEvent;
	
	public class Friends extends EventDispatcher {
		
		private static var users:Array;
		
		public function Friends() { }
		
		public static function load(xmlData:XML):void {
			trace("Friends.load()");
			var users:Array = new Array();
			if (xmlData!=null){
				var friendsinxml:XMLList  = xmlData.user;
				for each (var usXml:XML in friendsinxml) {
					var usObj:User = new User();
					usObj.load(usXml);
					users.push(usObj);
				}
			}
			Friends.setUsers(users);
			NetConn.sendMeStatusOfAllFriends(null);
			Broadcaster.dispatchEvent(new PEvent(PEvent.FRIENDSSERVERREFRESHED));
		}
		
		public static function getUsers():Array{
			return users;
		} 
		public static function setUsers(users:Array):void{
			Friends.users=users;
		}
		
		public static function getFriendByUserid(userid:int):User{
			for each (var user:User in users) {
				if (user.getUserid()==userid){
					return user;
				}
			}
			return null;
		}
		public static function isFriend(userid:int):Boolean{
			for each (var user:User in users) {
				if (user.getUserid()==userid){
					return true;
				}
			}
			return false;
		}
		public static function getFriendsAsCommaSepString():String{
			var out:String = "";
			var count:int = 0;
			for each (var user:User in users) {
				count = count + 1;
				if (count>1){
					out = out + ",";
				}
				out = out + user.getUserid();
			}
			//trace("Friends.getFriendsAsCommaSepString() -> "+out);
			return out;
		}
		
		
		
		//Data refreshing
		public static function refreshViaAPI():void{
			trace("refreshViaAPI()");
			var apiCaller:CallGetFriends = new CallGetFriends();
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onApiCallSuccess);
			apiCaller.addEventListener(ApiCallFail.TYPE, onApiCallFail);
		}
		private static function onApiCallSuccess(e:ApiCallSuccess):void{
			trace("onApiCallSuccess()");
			load(e.xmlData.friends[0]);
		}
		private static function onApiCallFail(e:ApiCallFail):void{
			trace("onApiCallFail() - e.error="+e.error);
		}
		
	
	}
	
}