package com.pingfit.xml
{
	import com.pingfit.xml.*;
	import flash.events.*;
	import com.pingfit.prefs.CPreferencesManager;
	import com.pingfit.events.ApiCallSuccess;
	import com.pingfit.events.ApiCallFail;
	
	public class ApiParams extends EventDispatcher {
		
		public static const PASS = "testapiparams_pass";
		public static const FAIL = "testapiparams_fail";
		
		private static var credentialsok:Boolean = false;
		private static var email:String = CPreferencesManager.getString("pingfit.email");
		private static var _password:String = CPreferencesManager.getString("pingfit.password");
		private static var facebookapikey = CPreferencesManager.getString("pingfit.facebookapikey");
		private static var facebook_session_key = CPreferencesManager.getString("pingfit.facebook_session_key");
		private static var facebook_session_secret = CPreferencesManager.getString("pingfit.facebook_session_secret");
		private static var facebookuid = CPreferencesManager.getString("pingfit.facebookuid");
		private static var baseurl:String = CPreferencesManager.getString("pingfit.baseurl");
		private static var baseurlred5:String = CPreferencesManager.getString("pingfit.baseurlred5");

		public function ApiParams(){
			//trace("ApiParams instanciated");
		}
		
		public function testApiParams():void{
			if (email=="" || _password==""){
				testApiParamsFails();
				return;
			}
			var callTestApi:CallTestApi = new CallTestApi();
			callTestApi.addEventListener(ApiCallSuccess.TYPE, testApiParamsXMLCallIsDone);
			callTestApi.addEventListener(ApiCallFail.TYPE, testApiParamsXMLCallHasError);
		}
		private function testApiParamsXMLCallIsDone(e:ApiCallSuccess):void {
			trace(e.xmlData);
			//trace("---");
			//trace("callTestApi.getXmlData().result.attribute(\"success\")="+callTestApi.getXmlData().result.attribute("success"));
			if(e.xmlData.result.attribute("success") == "true"){
				testApiParamsPasses();
			} else {
				testApiParamsFails();
			}
		}
		private function testApiParamsXMLCallHasError(e:ApiCallFail):void{
			testApiParamsFails();
		}
		private function testApiParamsPasses():void{
			credentialsok = true;
			dispatchEvent(new Event(ApiParams.PASS));
		}
		private function testApiParamsFails():void{
			//trace("ApiParams dispatching ApiParams.FAIL");
			credentialsok = false;
			dispatchEvent(new Event(ApiParams.FAIL));
		}
		
		public static function resetParamsOnLogout():void{
			setEmail("");
			setPassword("");
			setFacebook_session_key("");
			setFacebook_session_secret("");
			setFacebookuid("");
			setFacebookapikey("");
			credentialsok = false;
		}
		
		
		public static function getEmail():String{
			return email;
		}
		public static  function setEmail(email:String):void{
			CPreferencesManager.setPreference("pingfit.email", email);
			ApiParams.email = email;
		}
	
		
		
		
		public static  function getPassword():String{
			return _password;
		}
		public static  function setPassword(_password:String):void{
			CPreferencesManager.setPreference("pingfit.password", _password);
			ApiParams._password = _password;
		}
		
		
		
		public static  function getBaseurl():String{
			if (baseurl==""){
				CPreferencesManager.setPreference("pingfit.baseurl", "http://www.pingfit.com/");
				return "http://www.pingfit.com/";
			}
			return baseurl;
		}
		public static  function setBaseurl(baseurl:String):void{
			CPreferencesManager.setPreference("pingfit.baseurl", baseurl);
			ApiParams.baseurl = baseurl;
		}
		
		
		public static  function getBaseurlred5():String{
			if (baseurlred5==""){
				CPreferencesManager.setPreference("pingfit.baseurlred5", "rtmp://red5.pingfit.com/");
				return "rtmp://red5.pingfit.com/";
			}
			return baseurlred5;
		}
		public static  function setBaseurlred5(baseurlred5:String):void{
			CPreferencesManager.setPreference("pingfit.baseurlred5", baseurlred5);
			ApiParams.baseurlred5 = baseurlred5;
		}
		
		public static function areCredentialsOk():Boolean{
			return credentialsok;
		}
		
		public static  function getFacebookapikey():String{
			if (facebookapikey==""){
				CPreferencesManager.setPreference("pingfit.facebookapikey", "");
				return "";
			}
			return facebookapikey;
		}
		public static  function setFacebookapikey(facebookapikey:String):void{
			CPreferencesManager.setPreference("pingfit.facebookapikey", facebookapikey);
			ApiParams.facebookapikey = facebookapikey;
		}
		
		
		public static  function getFacebookuid():String{
			if (facebookuid==""){
				CPreferencesManager.setPreference("pingfit.facebookuid", "");
				return "";
			}
			return facebookuid;
		}
		public static  function setFacebookuid(facebookuid:String):void{
			CPreferencesManager.setPreference("pingfit.facebookuid", facebookuid);
			ApiParams.facebookuid = facebookuid;
		}
		
		
		public static  function getFacebook_session_key():String{
			if (facebook_session_key==""){
				CPreferencesManager.setPreference("pingfit.facebook_session_key", "");
				return "";
			}
			return facebook_session_key;
		}
		public static  function setFacebook_session_key(facebook_session_key:String):void{
			CPreferencesManager.setPreference("pingfit.facebook_session_key", facebook_session_key);
			ApiParams.facebook_session_key = facebook_session_key;
		}
		
		public static  function getFacebook_session_secret():String{
			if (facebook_session_secret==""){
				CPreferencesManager.setPreference("pingfit.facebook_session_secret", "");
				return "";
			}
			return facebook_session_secret;
		}
		public static  function setFacebook_session_secret(facebook_session_secret:String):void{
			CPreferencesManager.setPreference("pingfit.facebook_session_secret", facebook_session_secret);
			ApiParams.facebook_session_secret = facebook_session_secret;
		}

		
		
	}
	
	
}