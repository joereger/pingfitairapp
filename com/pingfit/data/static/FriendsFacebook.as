package com.pingfit.data.static 
{
	
	import com.pingfit.data.objects.User;
	import com.pingfit.events.*;
	import flash.events.*;
	import com.pingfit.data.objects.*;
	import com.pingfit.xml.CallGetFriends;
	import com.pingfit.events.ApiCallSuccess;
	import com.pingfit.events.ApiCallFail;
	import com.pingfit.events.Broadcaster;
	import com.pingfit.events.PEvent;
	import com.pingfit.xml.ApiParams;
	import com.facebook.data.users.GetInfoData;
	import com.facebook.session.DesktopSession;
	import com.facebook.utils.DesktopSessionHelper;
	import com.facebook.events.FacebookEvent;
	import com.facebook.Facebook;
	import com.facebook.net.FacebookCall;
	import com.facebook.commands.users.GetInfo;
	import com.facebook.commands.friends.*;
	import com.facebook.data.users.*;

	
	public class FriendsFacebook  {
		
		private static var friends:FacebookUserCollection;
		private static var usersAsArray:Array;
		private static var friendsAsCommaSepString:String;

		public function FriendsFacebook() { }
		
		public static function setFriends(friends:FacebookUserCollection):void {
			FriendsFacebook.friends = friends;
			trace("FriendsFacebook setFriends() called");
			//var arrayOfFacebookUsers:Array = friends.toArray();
			//for each ( var facebookUser:FacebookUser in arrayOfFacebookUsers ){
			//	trace("name="+facebookUser.name+" uid="+facebookUser.uid);
			//}
			//Convert to an easier-to-use array
			usersAsArray = new Array();
			friendsAsCommaSepString = "";
			if (friends!=null){
				var arrayOfFacebookUsers:Array = friends.toArray();
				var count:int = 0;
				for each ( var facebookUser:FacebookUser in arrayOfFacebookUsers ){
					//trace("name=" + facebookUser.name + " uid=" + facebookUser.uid);
					var user:User = new User();
					user.setUserid(0);
					user.setNickname(facebookUser.name);
					user.setFacebookuid(facebookUser.uid);
					user.setProfileimageurl(facebookUser.pic);
					usersAsArray.push(user);
					//Build Comma Sep String
					count = count + 1;
					if (count>1){
						friendsAsCommaSepString = friendsAsCommaSepString + ",";
					}
					friendsAsCommaSepString = friendsAsCommaSepString + facebookUser.uid;
				}
			}
			Broadcaster.dispatchEvent(new PEvent(PEvent.FRIENDSFACEBOOKREFRESHED));
		}
		public static function getFriends():FacebookUserCollection {
			return friends;
		}
		public static function getFacebookFriendsAsUsers():Array {
			return usersAsArray;
		}
		
		public static function getFriendsAsCommaSepString():String{
			return friendsAsCommaSepString;
		}
		
		public static function getFacebookUserFromUserObject(user:User):FacebookUser {
			if (user==null || user.getFacebookuid()==null || user.getFacebookuid()=="") {
				return null;
			}
			if (friends!=null){
				var arrayOfFacebookUsers:Array = friends.toArray();
				var count:int = 0;
				for each ( var facebookUser:FacebookUser in arrayOfFacebookUsers ){
					if (facebookUser.uid==user.getFacebookuid()) {
						return facebookUser;
					}
				}
			}
			return null;
		}
		
	}
	
}