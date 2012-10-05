package com.pingfit.xml {
	
	import com.pingfit.xml.XmlCaller;
	import flash.events.*;
	import com.pingfit.events.*;
	
	public class CallSignUp extends XmlCallBase {
		


		public function CallSignUp(email:String, _password:String, passwordverify:String, firstname:String, lastname:String, nickname:String, plid:int) { 
			var methodParams:Array = new Array();
			var param0:MethodParam = new MethodParam("method", "signUp");
			methodParams.push(param0);
			var param1:MethodParam = new MethodParam("signupemail", email);
			methodParams.push(param1);
			var param2:MethodParam = new MethodParam("signuppassword", _password);
			methodParams.push(param2);
			var param3:MethodParam = new MethodParam("signuppasswordverify", passwordverify);
			methodParams.push(param3);
			var param4:MethodParam = new MethodParam("firstname", firstname);
			methodParams.push(param4);
			var param5:MethodParam = new MethodParam("lastname", lastname);
			methodParams.push(param5);
			var param6:MethodParam = new MethodParam("nickname", nickname);
			methodParams.push(param6);
			var param7:MethodParam = new MethodParam("plid", String(plid));
			methodParams.push(param7);
			xmlCaller = new XmlCaller(methodParams);
			xmlCaller.addEventListener(XmlCaller.XML_LOADED, doneLoading);
			xmlCaller.addEventListener(XmlCaller.XML_ERROR, errorLoading);
		}
	
		
		
	}
	
}