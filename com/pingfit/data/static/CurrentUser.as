package com.pingfit.data.static {
	
	import flash.events.*;
	import com.pingfit.data.objects.*;
	import com.pingfit.xml.CallGetLoggedInUser;
	import com.pingfit.events.ApiCallSuccess;
	import com.pingfit.events.ApiCallFail;
	
	public class CurrentUser extends EventDispatcher {
		
		private static var user:User;
		
		public function CurrentUser() { }
		
		public static function load(xmlData:XML):void{
			//trace("CurrentUser.load() xmlData="+xmlData);
			if (xmlData!=null){
				//trace("static.CurrentUser.load() xmlData!=null");
				var user:User = new User();
				user.load(xmlData);
				setUser(user);
				trace("CurrentUser.load() user.getNickname()="+user.getNickname()+" user.getIsusereulauptodate()="+user.getIsusereulauptodate()+" xmlData.isusereulauptodate="+xmlData.isusereulauptodate+" Boolean(xmlData.isusereulauptodate)="+Boolean(xmlData.isusereulauptodate));
				if (xmlData.room[0]!=null){
					var room:Room = new Room();
					room.load(xmlData.room[0]);
					CurrentRoom.setCurrentRoom(room);
				}
			}
		}
		
		public static function getUser():User{
			return user;
		} 
		public static function setUser(user:User):void{
			CurrentUser.user=user;
		}
		
		
		
		//Data refreshing
		public static function refreshViaAPI():void{
			trace("refreshViaAPI()");
			var apiCaller:CallGetLoggedInUser = new CallGetLoggedInUser();
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onApiCallSuccess);
			apiCaller.addEventListener(ApiCallFail.TYPE, onApiCallFail);
		}
		private static function onApiCallSuccess(e:ApiCallSuccess):void{
			trace("onApiCallSuccess()");
			load(e.xmlData.loggedinuser[0].user[0]);
		}
		private static function onApiCallFail(e:ApiCallFail):void{
			trace("onApiCallFail() - e.error="+e.error);
		}
		
	
	}
	
}