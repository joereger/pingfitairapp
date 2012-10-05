package com.pingfit.data.static {
	
	import flash.events.*;
	import com.pingfit.data.objects.*;
	import com.pingfit.xml.CallGetRooms;
	import com.pingfit.events.ApiCallSuccess;
	import com.pingfit.events.ApiCallFail;
	import com.pingfit.events.Broadcaster;
	import com.pingfit.events.PEvent;
	
	public class AlarmStatus extends EventDispatcher {
		
		private static var isAlarmRinging:Boolean = false;
		
		public function AlarmStatus() { }
		
		public static function getIsAlarmRinging():Boolean {
			return isAlarmRinging;
			Broadcaster.dispatchEvent(new PEvent(PEvent.TIMERPANELALARMON));
		}
		
		public static function setIsAlarmRinging(isAlarmRinging:Boolean):void {
			AlarmStatus.isAlarmRinging = isAlarmRinging;
			Broadcaster.dispatchEvent(new PEvent(PEvent.TIMERPANELALARMOFF));
		}
		
	
	}
	
}