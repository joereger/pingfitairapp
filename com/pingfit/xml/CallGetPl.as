package com.pingfit.xml {
	
	import com.pingfit.xml.XmlCaller;
	import flash.events.*;
	import com.pingfit.events.*;
	
	public class CallGetPl extends XmlCallBase {
		


		public function CallGetPl(plid:int) { 
			var methodParams:Array = new Array();
			var param0:MethodParam = new MethodParam("method", "getPl");
			methodParams.push(param0);
			var param1:MethodParam = new MethodParam("plid", String(plid));
			methodParams.push(param1);
			xmlCaller = new XmlCaller(methodParams);
			xmlCaller.addEventListener(XmlCaller.XML_LOADED, doneLoading);
			xmlCaller.addEventListener(XmlCaller.XML_ERROR, errorLoading);
		}

		
	}
	
}