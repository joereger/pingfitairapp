package com.pingfit.xml {
	
	import com.pingfit.xml.XmlCaller;
	import flash.events.*;
	import com.pingfit.events.*;
	
	public class CallGetRoomsMyFriendsAreIn extends XmlCallBase {
		


		public function CallGetRoomsMyFriendsAreIn() { 
			var methodParams:Array = new Array();
			methodParams.push(new MethodParam("method", "getRoomsMyFriendsAreIn"));
			xmlCaller = new XmlCaller(methodParams);
			xmlCaller.addEventListener(XmlCaller.XML_LOADED, doneLoading);
			xmlCaller.addEventListener(XmlCaller.XML_ERROR, errorLoading);
		}
	
		
		
	}
	
}