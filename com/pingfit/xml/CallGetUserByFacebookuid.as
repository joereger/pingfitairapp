package com.pingfit.xml {
	
	import com.pingfit.xml.XmlCaller;
	import flash.events.*;
	import com.pingfit.events.*;
	
	public class CallGetUserByFacebookuid extends XmlCallBase {
		


		public function CallGetUserByFacebookuid(facebookuid:String) { 
			var methodParams:Array = new Array();
			methodParams.push(new MethodParam("method", "getUserByFacebookuid"));
			methodParams.push(new MethodParam("facebookuid", facebookuid));
			xmlCaller = new XmlCaller(methodParams);
			xmlCaller.addEventListener(XmlCaller.XML_LOADED, doneLoading);
			xmlCaller.addEventListener(XmlCaller.XML_ERROR, errorLoading);
		}
	
		
		
	}
	
}