package com.pingfit.xml {
	
	import com.pingfit.xml.XmlCaller;
	import flash.events.*;
	import com.pingfit.events.*;
	
	public class CallGetUser extends XmlCallBase {
		


		public function CallGetUser(userid:int) { 
			var methodParams:Array = new Array();
			methodParams.push(new MethodParam("method", "getUser"));
			methodParams.push(new MethodParam("userid", String(userid)));
			xmlCaller = new XmlCaller(methodParams);
			xmlCaller.addEventListener(XmlCaller.XML_LOADED, doneLoading);
			xmlCaller.addEventListener(XmlCaller.XML_ERROR, errorLoading);
		}
	
		
		
	}
	
}