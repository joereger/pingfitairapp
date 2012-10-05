package com.pingfit.xml {
	
	import com.pingfit.xml.XmlCaller;
	import flash.events.*;
	import com.pingfit.events.*;
	
	public class CallAreFriends extends XmlCallBase {
		


		public function CallAreFriends(userid1:int, userid2:int) { 
			var methodParams:Array = new Array();
			methodParams.push(new MethodParam("method", "areFriends"));
			methodParams.push(new MethodParam("userid1", String(userid1)));
			methodParams.push(new MethodParam("userid2", String(userid2)));
			xmlCaller = new XmlCaller(methodParams);
			xmlCaller.addEventListener(XmlCaller.XML_LOADED, doneLoading);
			xmlCaller.addEventListener(XmlCaller.XML_ERROR, errorLoading);
		}
	
		
		
	}
	
}