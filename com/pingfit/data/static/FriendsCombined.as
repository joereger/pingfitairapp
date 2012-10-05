package com.pingfit.data.static {
	
	import com.pingfit.data.objects.User;
	import flash.events.*;
	import com.pingfit.data.objects.*;
	import com.pingfit.xml.CallGetFriends;
	import com.pingfit.events.*;
	
	public class FriendsCombined extends EventDispatcher {
		
		private static var users:Array;
		
		public function FriendsCombined() { }
		
		public static function init():void {
			trace("FriendsCombined.init()");
			Broadcaster.addEventListener(PEvent.FRIENDSSERVERREFRESHED, onFriendsRefreshed);
			Broadcaster.addEventListener(PEvent.FRIENDSFACEBOOKREFRESHED, onFriendsRefreshed);
			Broadcaster.addEventListener(PresenceChange.TYPE, onPresenceChange);
		}
		
		private static function onFriendsRefreshed(e:PEvent):void{
			trace("FriendsCombined.onFriendsRefreshed()");
			//Go get friends from Friends
			users = Friends.getUsers();
			//If it's still null, init array
			if (users == null) { users = new Array(); }
			//Now pull in from FriendsFacebook
			for each ( var fbUser:User in FriendsFacebook.getFacebookFriendsAsUsers() ){
				if (!isInUsersArrayAlready(fbUser.getUserid(), fbUser.getFacebookuid())) {
					//User not in array... add it.
					users.push(fbUser);
				} else {
					//User is already in array... anything else to do?
				}
			}
			Broadcaster.dispatchEvent(new PEvent(PEvent.FRIENDSREFRESHED));
		}
		
		private static function onPresenceChange(e:PresenceChange):void{
			trace("FriendsCombined.onPresenceChange() e.userid=" + e.userid + " e.nickname=" + e.nickname + " e.roomname=" + e.roomname +" e.userstatus=" + e.userstatus);
			if (FriendsCombined.users!=null) {
				//for each ( var user:User in FriendsCombined.users ) {
				for (var i:int = 0; i < FriendsCombined.users.length; i++) {
					var user:User = FriendsCombined.users[i];
					if ((String(user.getUserid())==e.userid && String(e.userid)!='0') || (e.facebookuid==user.getFacebookuid())) {
						if (e.userstatus == "Online") {
							user.setIsonline(true);
						} else {
							user.setIsonline(false);
						}
						user.setRoom(Rooms.getRoomByRoomidStr(e.roomid));
						//Replace with the updated user
						FriendsCombined.users[i] = user;
					}
				}
			}
		}
		
		private static function isInUsersArrayAlready(userid:int, facebookuid:String):Boolean {
			//trace("FriendsCombined.isInUsersArrayAlready() userid="+userid+" facebookuid="+facebookuid);
			if (FriendsCombined.users!=null) {
				for each ( var user:User in FriendsCombined.users ){
					if ((user.getUserid()==userid && user.getUserid()>0) || (user.getFacebookuid()==facebookuid)) {
						//trace("FriendsCombined.isInUsersArrayAlready() returning true, already in array");
						return true;
					}
				}
			}
			//trace("FriendsCombined.isInUsersArrayAlready() returning false");
			return false;
		}
		
		public static function getUsers():Array{
			return users;
		} 
		
		public static function getUser(userid:int, facebookuid:String):User {
			//trace("FriendsCombined.isInUsersArrayAlready() userid="+userid+" facebookuid="+facebookuid);
			if (FriendsCombined.users!=null) {
				for each ( var user:User in FriendsCombined.users ){
					if ((user.getUserid()==userid && user.getUserid()>0) || (user.getFacebookuid()==facebookuid)) {
						//trace("FriendsCombined.isInUsersArrayAlready() returning true, already in array");
						return user;
					}
				}
			}
			//trace("FriendsCombined.isInUsersArrayAlready() returning false");
			return null;
		}
		
		
		
	
	}
	
}