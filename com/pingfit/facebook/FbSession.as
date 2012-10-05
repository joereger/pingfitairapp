package com.pingfit.facebook 
{
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
	import com.facebook.data.friends.*;
	import com.facebook.data.*;
	import com.facebook.events.*;
	import com.pingfit.events.PEvent;
	import com.pingfit.events.Broadcaster;
	import com.pingfit.data.static.FriendsFacebook;
	import com.pingfit.data.static.NetConn;
	
	/**
	 * ...
	 * @author Joe Reger, Jr.
	 */
	public class FbSession {
		
		private static var session:DesktopSessionHelper;
		private static var fbook:Facebook;
		private static var user:FacebookUser;
		private static var isConnected:Boolean = false;
		private static var apikey:String = "afa704b92c9a3bde57fd6535c114782a"

		
		public function FbSession() {
			
		}
		
		public static function init():void {
			fbook=new Facebook();
			session=new DesktopSessionHelper(apikey);
			session.addEventListener(FacebookEvent.CONNECT,onConnect);
		}
		
		public static function getIsConnected():Boolean { return FbSession.isConnected;}
		
		
		private static function onConnect(e:FacebookEvent):void{
			if(e.success){
				trace("FbSession.as - Hello... logged in to Facebook");
				fbook.startSession(new DesktopSession(session.apiKey, session.sessionData.secret, session.sessionData.session_key));
				var call:FacebookCall=fbook.post(new GetInfo([session.sessionData.uid],[GetInfoFieldValues.ALL_VALUES]));
				call.addEventListener(FacebookEvent.COMPLETE, onGetInfo);
				isConnected = true;
				ApiParams.setFacebook_session_key(session.sessionData.session_key);
				ApiParams.setFacebook_session_secret(session.sessionData.secret);
				ApiParams.setFacebookuid(session.sessionData.uid);
				ApiParams.setFacebookapikey(session.apiKey);
				trace("ApiParams.getFacebook_session_secret()=" + ApiParams.getFacebook_session_key());
				trace("ApiParams.getFacebook_session_secret()=" + ApiParams.getFacebook_session_secret());
				trace("ApiParams.getFacebookuid()=" + ApiParams.getFacebookuid());
				trace("ApiParams.getFacebookapikey()=" + ApiParams.getFacebookapikey());
			} else{
				trace("Error logging in to Facebook");
			}
		}
		
		public static function logout():void{	
			session.logout();
			trace("You are not logged in to Facebook");
			isConnected=false;
		}	
		
		public static function getSession():DesktopSessionHelper {
			return session;
		}
		
		public static function getFacebookUser():FacebookUser {
			return user;
		}
		
		
		private static function onGetInfo(e:FacebookEvent):void {
			user=(e.data as GetInfoData).userCollection.getItemAt(0) as FacebookUser;
			trace("Hello Facebook user: " + user.name);
			
			refreshFriends();
		}	
		
		
		public static function refreshFriends():void {
			var call:GetFriends = new GetFriends();
			call.addEventListener(FacebookEvent.COMPLETE, onGotFriends);
			fbook.post(call);
		}
		private static function onGotFriends(e:FacebookEvent):void {
			trace("FbSession.onGotFriends()");
			var facebookData:FacebookData = FacebookData(e.data);
			var getFriendsData:GetFriendsData = GetFriendsData(facebookData);
			//Iterate users, put uids into array
			var arrayOfFacebookUsers:Array = getFriendsData.friends.toArray();
			var uids:Array = new Array();
			for each ( var facebookUser:FacebookUser in arrayOfFacebookUsers ){
				//trace("uid=" + facebookUser.uid);
				uids.push(facebookUser.uid);
			}
			//Now list the fields I want
			var fields:Array = new Array();
			fields.push("uid");
			fields.push("name");
			fields.push("pic_square");
			fields.push("pic_big");
			fields.push("pic");
			//Now call the GetInfo
			var call:GetInfo = new GetInfo(uids, fields);
			call.addEventListener(FacebookEvent.COMPLETE, onGotInfo);
			fbook.post(call);
		}
		private static function onGotInfo(e:FacebookEvent):void {
			trace("FbSession.onGotInfo()");
			var facebookData:FacebookData = FacebookData(e.data);
			var getInfoData:GetInfoData = GetInfoData(facebookData);
			FriendsFacebook.setFriends(getInfoData.userCollection);
			NetConn.setFriendsFacebook(FriendsFacebook.getFriendsAsCommaSepString());
			Broadcaster.dispatchEvent(new PEvent(PEvent.FACEBOOKCONNECTSUCCESS)); //This used to be in onGetInfo()... less risky there because less calls must be made
			Broadcaster.dispatchEvent(new PEvent(PEvent.FACEBOOKFRIENDSLOADED)); 
		}
		
		
		
		
		
		
		
		
		
		
		
		
	}
	
}