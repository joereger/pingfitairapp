package com.pingfit.data.static {
	
	import flash.events.*;
	import com.pingfit.data.objects.*;
	import com.pingfit.xml.CallGetCurrentEula;
	import com.pingfit.events.ApiCallSuccess;
	import com.pingfit.events.ApiCallFail;
	
	public class Eula extends EventDispatcher {
		
		private static var eula:String;
		private static var eulaid:int;
		
		public function Eula() { }
		
		public static function load(xmlData:XML):void{
			eula = "";
			eulaid = 0;
			if (xmlData!=null){
				eula = xmlData.eula;
				eulaid = int(xmlData.eulaid);
			}
		}
		
		public static function getEula():String{return eula;} 
		public static function setEula(eula:String):void{Eula.eula=eula;}
		
		public static function getEulaid():int{return eulaid;} 
		public static function setEulaid(eulaid:int):void{Eula.eulaid=eulaid;}
		
		
		//Data refreshing
		public static function refreshViaAPI():void{
			trace("refreshViaAPI()");
			var apiCaller:CallGetCurrentEula = new CallGetCurrentEula(CurrentPl.getPl().getPlid());
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onApiCallSuccess);
			apiCaller.addEventListener(ApiCallFail.TYPE, onApiCallFail);
		}
		private static function onApiCallSuccess(e:ApiCallSuccess):void{
			trace("onApiCallSuccess()");
			load(e.xmlData.eula[0]);
		}
		private static function onApiCallFail(e:ApiCallFail):void{
			trace("onApiCallFail() - e.error="+e.error);
		}
		
	}
	
}