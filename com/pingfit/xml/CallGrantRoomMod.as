package com.pingfit.xml {
	
	import com.pingfit.xml.XmlCaller;
	import flash.events.*;
	import com.pingfit.events.*;
	
	public class CallGrantRoomMod extends XmlCallBase {
		


		public function CallGrantRoomMod(useridtogivepermissionto:int, roomid:int) { 
			var methodParams:Array = new Array();
			methodParams.push(new MethodParam("method", "grantRoomMod"));
			methodParams.push(new MethodParam("useridtogivepermissionto", String(useridtogivepermissionto)));
			methodParams.push(new MethodParam("roomid", String(roomid)));
			xmlCaller = new XmlCaller(methodParams);
			xmlCaller.addEventListener(XmlCaller.XML_LOADED, doneLoading);
			xmlCaller.addEventListener(XmlCaller.XML_ERROR, errorLoading);
		}
	
		
		
	}
	
}