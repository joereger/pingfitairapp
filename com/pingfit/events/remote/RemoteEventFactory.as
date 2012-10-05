package com.pingfit.events.remote {

	public class RemoteEventFactory {

		
		public function RemoteEventFactory() { }
		
		
		public static function getByType(type:String):RemoteEvent {
			
			var newFriendRequest:NewFriendRequest = new NewFriendRequest();
			if (newFriendRequest.getType() == type) { return newFriendRequest; }
			
			var friendAccepted:FriendAccepted = new FriendAccepted();
			if (friendAccepted.getType() == type) { return friendAccepted; }
			
			var newRoomPermissionRequest:NewRoomPermissionRequest = new NewRoomPermissionRequest();
			if (newRoomPermissionRequest.getType() == type) { return newRoomPermissionRequest; }
			
			var roomPermissionGranted:RoomPermissionGranted = new RoomPermissionGranted();
			if (roomPermissionGranted.getType() == type) { return roomPermissionGranted; }
			
			return null;
		}
		

		
	}
	
}