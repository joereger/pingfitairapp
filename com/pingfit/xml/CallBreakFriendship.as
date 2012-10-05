package com.pingfit.xml {
	
	import com.pingfit.xml.XmlCaller;
	import flash.events.*;
	import com.pingfit.events.*;
	
	public class CallBreakFriendship extends XmlCallBase {
		


		public function CallBreakFriendship(useridoffriend:int) { 
			var methodParams:Array = new Array();
			methodParams.push(new MethodParam("method", "breakFriendship"));
			methodParams.push(new MethodParam("useridoffriend", String(useridoffriend)));
			xmlCaller = new XmlCaller(methodParams);
			xmlCaller.addEventListener(XmlCaller.XML_LOADED, doneLoading);
			xmlCaller.addEventListener(XmlCaller.XML_ERROR, errorLoading);
		}
	
		
		
	}
	
}