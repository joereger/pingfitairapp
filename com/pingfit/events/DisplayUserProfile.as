package com.pingfit.events {
	
	import flash.events.Event;
	import com.pingfit.data.objects.User;
	
	public class DisplayUserProfile extends Event {
		
		public static var TYPE:String = "DisplayUserProfileEvent";
		public var user:User;  
		
		public function DisplayUserProfile(user:User) { 
			this.user = user;
			super(TYPE, true, true);
		}
		
		public override function clone():Event{
			return new DisplayUserProfile(user);
		}

	}
	
}