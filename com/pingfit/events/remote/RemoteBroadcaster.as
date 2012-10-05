package com.pingfit.events.remote {
	
	import com.pingfit.data.static.NetConn;
	import flash.net.Responder;
	

	public class RemoteBroadcaster {
		
		public function RemoteBroadcaster() { }
		
		public static function dispatchEventToRoom(roomidtodispatchto:int, remoteEvent:RemoteEvent, nr:Responder = null) {
			NetConn.dispatchEventToRoom(roomidtodispatchto, remoteEvent.getType(), remoteEvent.getArg1(), remoteEvent.getArg2(), remoteEvent.getArg3(), remoteEvent.getArg4(), remoteEvent.getArg5(), nr);
		}
		
		public static function dispatchEventToCommaSepListOfUsers(useridscommasep:String, remoteEvent:RemoteEvent, nr:Responder = null) {
			NetConn.dispatchEventToCommaSepListOfUsers(useridscommasep, remoteEvent.getType(), remoteEvent.getArg1(), remoteEvent.getArg2(), remoteEvent.getArg3(), remoteEvent.getArg4(), remoteEvent.getArg5(), nr);
		}
		
		public static function dispatchEventToUser(useridtodispatchto:int, remoteEvent:RemoteEvent, nr:Responder = null) {
			NetConn.dispatchEventToUser(useridtodispatchto, remoteEvent.getType(), remoteEvent.getArg1(), remoteEvent.getArg2(), remoteEvent.getArg3(), remoteEvent.getArg4(), remoteEvent.getArg5(), nr);
		}
		
	}
	
}