package com.pingfit.xml {
	
	import com.pingfit.xml.XmlCaller;
	import flash.events.*;
	import com.pingfit.events.*;
	
	public class CallAgreeToEula extends XmlCallBase {
		

		public function CallAgreeToEula(eulaid:int) { 
			var methodParams:Array = new Array();
			var param0:MethodParam = new MethodParam("method", "agreeToEula");
			methodParams.push(param0);
			var param1:MethodParam = new MethodParam("eulaid", String(eulaid));
			methodParams.push(param1);
			xmlCaller = new XmlCaller(methodParams);
			xmlCaller.addEventListener(XmlCaller.XML_LOADED, doneLoading);
			xmlCaller.addEventListener(XmlCaller.XML_ERROR, errorLoading);
		}
	
		
	}
	
}