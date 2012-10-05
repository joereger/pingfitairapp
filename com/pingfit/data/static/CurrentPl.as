package com.pingfit.data.static {
	
	import com.pingfit.data.objects.Pl;
	import com.pingfit.data.objects.Pl;
	import flash.events.*;
	import com.pingfit.data.objects.*;
	import com.pingfit.xml.CallGetPl;
	import com.pingfit.events.ApiCallSuccess;
	import com.pingfit.events.ApiCallFail;
	import com.pingfit.prefs.CPreferencesManager;
	import com.pingfit.events.PEvent;
	import com.pingfit.events.Broadcaster;
	import lt.uza.utils.Global;
	
	public class CurrentPl extends EventDispatcher {
		
		private static var pl:Pl = new Pl();

		public function CurrentPl() { }
		
		public static function load(xmlData:XML):void{
			pl = null;
			if (xmlData!=null){
				var pl:Pl = new Pl();
				pl.load(xmlData);
				CurrentPl.setPl(pl);
			}
		}
		
		public static function getPl():Pl { return pl;} 
		public static function setPl(pl:Pl):void {
			trace("CurrentPl: setPl() called");
			CurrentPl.pl = pl;
			//Record to local DB
			trace("CurrentPl: will store pl.getPlid()="+pl.getPlid()+" to CPreferencesManager");
			CPreferencesManager.setInt("pingFit.plid", pl.getPlid());
			CPreferencesManager.setPreference("pingFit.airlogo", pl.getAirlogo());
			CPreferencesManager.setPreference("pingFit.airbgcolor", pl.getAirbgcolor());
			CPreferencesManager.setPreference("pingFit.plname", pl.getName());
			//Dispatch setPlCalledEvent
			Broadcaster.dispatchEvent(new PEvent(PEvent.CURRENTPLSET));
		}
		
		
		//Data refreshing
		public static function refreshViaAPI():void{
			trace("refreshViaAPI()");
			Global.getInstance().debug = Global.getInstance().debug + "(CurrentPl.refreshViaAPI())";
			var apiCaller:CallGetPl = new CallGetPl(CurrentPl.getPl().getPlid());
			apiCaller.addEventListener(ApiCallSuccess.TYPE, onApiCallSuccess);
			apiCaller.addEventListener(ApiCallFail.TYPE, onApiCallFail);
		}
		private static function onApiCallSuccess(e:ApiCallSuccess):void{
			trace("onApiCallSuccess()");
			Global.getInstance().debug = Global.getInstance().debug + "(CurrentPl.onApiCallSuccess())";
			load(e.xmlData.pl[0]);
		}
		private static function onApiCallFail(e:ApiCallFail):void{
			trace("onApiCallFail() - e.error=" + e.error);
			Global.getInstance().debug = Global.getInstance().debug + "(CurrentPl.onApiCallFail("+e.error+"))";
		}
		
	}
	
}