package com.pingfit.data.static {
	
	import flash.net.*;
	import flash.events.NetStatusEvent;
	import com.pingfit.events.*;
	import com.pingfit.xml.ApiParams;
	import com.pingfit.events.remote.*;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.AsyncErrorEvent;

	
	public class NetConn {
		
		NetConnection.defaultObjectEncoding = ObjectEncoding.AMF0;
		private static var nc:NetConnection = null;
		private static var url:String = "default";
		private static var red5HeartbeatTimer:Timer;
		private static var heartbeatEveryXSeconds:int = 120;
		
		
		public function NetConn() { }
		
		public static function setUrl(url:String):void {
			//Determine whether or not we're changing rooms/urls
			var isNewUrl:Boolean = false;
			if (NetConn.url!=url){ isNewUrl = true; trace("NetConn.setUrl() NetConn.url="+NetConn.url+" url="+url+" isNewUrl=true"); }
			//Set the current url
			NetConn.url = url;
			//If we're going to a new room, make sure old conn is dead
			if (isNewUrl){  killConn();  }
		}
		
		public static function getConn():NetConnection {
			trace("NetConn.getConn() url="+url);
			return getConnAndSetUrl(url);
		}
		
		public static function getConnAndSetUrl(url:String):NetConnection{
			trace("NetConn.getConnAndSetUrl() url="+url);
			setUrl(url);
			setupConn();
			//Return the conn
			return nc;
		}
		
		private static function setupConn():void {
			//Note that .connected may report false when connected via http... what's that mean?
			if (nc != null) {
				var debug:String = "";
				if (!nc.connected) {
					debug = "!nc.connected";
					killConn();
				} else {
					debug = "nc.connected";
				}
				trace("NetConn.setupConn() nc!=null "+debug);
			}
			if (nc==null){
				trace("NetConn.setupConn() nc==null url="+url);
				nc = new NetConnection();
				nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, sync_error);
				nc.client = new NetConn();
				nc.objectEncoding = ObjectEncoding.AMF0;
				if (CurrentUser.getUser()!=null){
					var friendsCommaSep:String = Friends.getFriendsAsCommaSepString();
					var facebookfriendsCommaSep:String = FriendsFacebook.getFriendsAsCommaSepString();
					var roomid:String = "";
					var roomname:String = "";
					if (CurrentUser.getUser().getRoom()!=null){
						roomid = String(CurrentUser.getUser().getRoom().getRoomid());
						roomname = CurrentUser.getUser().getRoom().getName();
						//trace("NetConn.setupConn() found roomid="+roomid+" roomname="+roomname);
					}
					nc.connect(ApiParams.getBaseurlred5()+"pingFitRed5/"+url+"/", CurrentUser.getUser().getUserid(), CurrentUser.getUser().getNickname(), friendsCommaSep, "Online", String(roomid), roomname, facebookfriendsCommaSep, CurrentUser.getUser().getFacebookuid());
				}
			}
			//BgTimer controls things every second
			if (red5HeartbeatTimer==null){
				red5HeartbeatTimer = new Timer(heartbeatEveryXSeconds*1000);
				red5HeartbeatTimer.addEventListener(TimerEvent.TIMER, red5HeartbeatTimerTick);
				red5HeartbeatTimer.start();
			}
		}
		
		public static function killConn():void {
			trace("NetConn.killConn() url="+url);
			if (nc!=null){nc.close(); nc=null;}
		}
		
		
		private static function red5HeartbeatTimerTick(e:TimerEvent):void{
			trace("NetConn.red5HeartbeatTimerTick()");
			NetConn.heartbeat("just checking", null);
		}
		
	
		
		private static function netStatusHandler(event:NetStatusEvent):void{
			trace("NetConn.netStatusHandler() -> event.info.code="+event.info.code);
			if(event.info.code == "NetConnection.Connect.Success"){
				//trace("netStatusHandler() -> NetConnection.Connect.Success");
			}
			if(event.info.code == "NetConnection.Connect.Closed"){
				killConn();
			}
		}
		
		private static function sync_error(event:AsyncErrorEvent):void{
			trace("NetConn.sync_error() -> "+event);
		}
		
		
		
		
		//Locally-called methods--------------------------------
		//------------------------------------------------------
		public static function sayToRoom(msg:String, type:String, nr:Responder = null):void {
			trace("NetConn.sayToRoom("+msg+")");
			setupConn();
			if (msg!=null && msg.length>0){
				//var nr:Responder = new Responder(onCallDone, null);
				nc.call("room.say", nr, msg, CurrentUser.getUser().getNickname(), type);
			}
		}
		
		public static function heartbeat(msg:String, nr:Responder = null):void{
			trace("NetConn.heartbeat() msg="+msg);
			setupConn();
			nc.call("presence.heartbeat", nr, msg);
		}
		
		public static function setRoom(roomid:int, roomname:String, nr:Responder = null):void{
			trace("NetConn.setRoom() roomid="+roomid+" roomname="+roomname);
			setupConn();
			nc.call("presence.setRoom", nr, String(roomid), roomname);
		}
		
		public static function setFriends(friendsCommaSep:String, nr:Responder = null):void{
			setupConn();
			nc.call("presence.setFriends", nr, friendsCommaSep);
		}
		
		public static function setFriendsFacebook(friendsFacebookCommaSep:String, nr:Responder = null):void{
			setupConn();
			nc.call("presence.setFriendsFacebook", nr, friendsFacebookCommaSep);
		}
		
		public static function sendMeStatusOfAllFriends(nr:Responder = null):void {
			trace("NetConn.sendMeStatusOfAllFriends() called");
			setupConn();
			nc.call("presence.sendMeStatusOfAllFriends", nr);
		}
		
		public static function dispatchEventToRoom(roomidtodispatchto:int, eventtype:String, arg1:String="", arg2:String="", arg3:String="", arg4:String="", arg5:String="", nr:Responder = null):void{
			setupConn();
			nc.call("presence.dispatchEventToRoom", nr, String(roomidtodispatchto), eventtype, arg1, arg2, arg3, arg4, arg5);
		}
		
		public static function dispatchEventToCommaSepListOfUsers(useridscommasep:String, eventtype:String, arg1:String="", arg2:String="", arg3:String="", arg4:String="", arg5:String="", nr:Responder = null):void{
			setupConn();
			nc.call("presence.dispatchEventToCommaSepListOfUsers", nr, useridscommasep, eventtype, arg1, arg2, arg3, arg4, arg5);
		}
		
		public static function dispatchEventToUser(useridtodispatchto:int, eventtype:String, arg1:String="", arg2:String="", arg3:String="", arg4:String="", arg5:String="", nr:Responder = null):void{
			setupConn();
			nc.call("presence.dispatchEventToUser", nr, String(useridtodispatchto), eventtype, arg1, arg2, arg3, arg4, arg5);
		}
		
		
		
		
		
		//Remotely-called methods--------------------------------
		//-------------------------------------------------------
		
		public function onMetaData ( message:Object ):void{
            trace( "NetConn.onMetaData: ");
            for ( var a:* in message ) trace( a + " : " + message[a] );
        }
		
		public function messageToRoom( message:Object ):void{
            trace("NetConn.messageInbound()");
			for ( var a:* in message ){
				Broadcaster.dispatchEvent(new MessageToRoom(message[a].msg, message[a].nickname, message[a].userid, message[a].messagetype, message[a].roomid));
			}  
        }
		
		public function personEntersRoom( message:Object ):void{
            trace("NetConn.personEnteredRoom()");
			for ( var a:* in message ){
				Broadcaster.dispatchEvent(new PersonEntersRoom(message[a].nickname, message[a].userid, message[a].facebookuid));
			}  
        }
		
		public function personLeavesRoom( message:Object ):void{
            trace("NetConn.personLeftRoom()");
			for ( var a:* in message ){
				Broadcaster.dispatchEvent(new PersonLeavesRoom(message[a].nickname, message[a].userid, message[a].facebookuid));
			}  
        }
		
		public function presenceChange( message:Object ):void{
            trace("NetConn.presenceChange()");
			var ischange:Boolean = false;
			for ( var a:* in message ){
				Broadcaster.dispatchEvent(new PresenceChange(message[a].nickname, message[a].userid, message[a].roomid, message[a].roomname, message[a].userstatus, message[a].facebookuid));
				ischange = true;
			}  
        }
		
		public function doneSendingAllStatuses( message:Object ):void{
            trace("NetConn.doneSendingAllStatuses()");
			Broadcaster.dispatchEvent(new PEvent(PEvent.DONEGETTINGALLFRIENDSSTATUSFROMRED5));
        }
		
		public function incomingRemoteEvent( message:Object ):void{
            trace("NetConn.incomingDispatchEvent()");
			for ( var a:* in message ) {
				trace("NetConn.incomingDispatchEvent() a="+a);
				trace("NetConn.incomingDispatchEvent() message[a].eventtype=" + message[a].eventtype);
				if (message[a].eventtype!=null) {
					var remoteEvent:RemoteEvent = RemoteEventFactory.getByType(message[a].eventtype);
					remoteEvent.setArgsRemote(message[a].arg1, message[a].arg2, message[a].arg3, message[a].arg4, message[a].arg5);
					remoteEvent.invokeLocalEvent();
				}
			}  
        }
		
		
		
		


	}
	
}