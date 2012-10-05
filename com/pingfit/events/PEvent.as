package com.pingfit.events {
	
	import flash.events.Event;
	
	public class PEvent extends Event {
		
		public static const LOGIN:String = "Login"; 
		public static const SIGNUP:String = "Signup"; 
		public static const EULAOK:String = "EulaOk"; 
		public static const NEWEXERCISEDATALOADED:String = "AgreeEula"; 
		public static const DISPLAYCURRENTEXERCISE:String = "DisplayCurrentExercise"; 
		public static const APPSTART:String = "AppStart"; 
		public static const BIGREFRESHDONE:String = "BigRefreshDone";
		public static const NOTIFICATIONSLOADED:String = "NotificationsLoaded"; 
		public static const EXERCISEALARM:String = "ExerciseAlarm"; 
		public static const SWITCHTOWORKOUTALONE:String = "SwitchToWorkoutAlone"; 
		public static const SWITCHTOWORKOUTGROUP:String = "SwitchToWorkoutGroup"; 
		public static const CHANGEEXERCISELIST:String = "ChangeExerciseList"; 
		public static const CHANGEEXERCISEEVERYXMINUTES:String = "ChangeExerciseEveryXMinutes"; 
		public static const TURNONNAVBAR:String = "TurnOnNavBar";
		public static const TURNOFFNAVBAR:String = "TurnOffNavBar";
		public static const TOGGLENAVBAR:String = "ToggleNavBar";
		public static const EXITAPP:String = "ExitApp";
		public static const DOCKAPP:String = "DockApp";
		public static const UNDOCKAPP:String = "UndockApp";
		public static const FRIENDSREFRESHED:String = "FriendsRefreshed";
		public static const FRIENDSSERVERREFRESHED:String = "FriendsServerRefreshed";
		public static const FRIENDSFACEBOOKREFRESHED:String = "FriendsFacebookRefreshed";
		public static const FACEBOOKCONNECTSUCCESS:String = "FacebookConnectSuccess";
		public static const FACEBOOKFRIENDSLOADED:String = "FacebookFriendsLoaded";
		public static const STARTINVITEFRIEND:String = "StartInviteFriend";
		public static const TIMERPANELALARMON:String = "TimerPanelAlarmOn";
		public static const TIMERPANELALARMOFF:String = "TimerPanelAlarmOff";
		public static const CURRENTPLSET:String = "CurrentPlSet";
		
		public static const DONEGETTINGALLFRIENDSSTATUSFROMRED5:String = "DoneGettingAllFriendsStatusFromRed5";
		
		public var typeZ:String;
		
		public function PEvent(type:String) { 
			this.typeZ = type;
			super(type, true, true);
		}
		
		public override function clone():Event{
			return new PEvent(typeZ);
		}

	}
	
}