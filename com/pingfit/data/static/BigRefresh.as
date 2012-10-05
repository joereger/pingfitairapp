package com.pingfit.data.static {
	
	import flash.events.*;
	import com.pingfit.xml.CallBigRefresh;
	import com.pingfit.events.ApiCallSuccess;
	import com.pingfit.events.ApiCallFail;
	import com.pingfit.events.PEvent;
	import com.pingfit.events.Broadcaster;
	import flash.events.EventDispatcher;
 	import flash.events.Event;

	
	
	public class BigRefresh {
		
		
		
		public function BigRefresh() { }
		
		public static function load(xmlData:XML):void {
			//trace("BigRefresh.load() xmlData="+xmlData);
			if (xmlData != null) {
				CurrentPl.load(xmlData.currentpl[0].pl[0]);
				NextExercises.load(xmlData.nextexercises[0]);
				ExerciseLists.load(xmlData.exerciselists[0]);
				CurrentUser.load(xmlData.loggedinuser[0].user[0]);
				Rooms.load(xmlData.rooms[0]);
				Eula.load(xmlData.eula[0]);
				Friends.load(xmlData.friends[0]);
				Notifications.load(xmlData.notifications[0]);
			}
		}
		
		
		//Data refreshing
		public static function refreshViaAPI():void{
			trace("refreshViaAPI()");
			var apiCaller:CallBigRefresh = new CallBigRefresh();
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onApiCallSuccess);
			apiCaller.addEventListener(ApiCallFail.TYPE, onApiCallFail);
		}
		private static function onApiCallSuccess(e:ApiCallSuccess):void{
			trace("onApiCallSuccess()");
			load(e.xmlData.bigrefresh[0]);
			Broadcaster.dispatchEvent(new PEvent(PEvent.BIGREFRESHDONE));
		}
		private static function onApiCallFail(e:ApiCallFail):void{
			trace("onApiCallFail() - e.error="+e.error);
		}
		
		
		
		
	}
	
}