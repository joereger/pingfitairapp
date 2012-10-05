package com.pingfit.xml {
	
	import com.pingfit.xml.XmlCaller;
	import flash.events.*;
	import com.pingfit.events.*;
	
	public class CallIsModeratorOfRoom extends XmlCallBase {
		


		public function CallIsModeratorOfRoom(userid:int, roomid:int) { 
			var methodParams:Array = new Array();
			methodParams.push(new MethodParam("method", "isModeratorOfRoom"));
			methodParams.push(new MethodParam("userid", String(userid)));
			methodParams.push(new MethodParam("roomid", String(roomid)));
			xmlCaller = new XmlCaller(methodParams);
			xmlCaller.addEventListener(XmlCaller.XML_LOADED, doneLoading);
			xmlCaller.addEventListener(XmlCaller.XML_ERROR, errorLoading);
		}
	
		
		
	}
	
}