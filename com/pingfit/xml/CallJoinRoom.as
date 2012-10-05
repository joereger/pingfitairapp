package com.pingfit.xml {
	
	import com.pingfit.xml.XmlCaller;
	import flash.events.*;
	import com.pingfit.events.*;
	
	public class CallJoinRoom extends XmlCallBase {



		public function CallJoinRoom(roomid:int) { 
			var methodParams:Array = new Array();
			var param0:MethodParam = new MethodParam("method", "joinRoom");
			methodParams.push(param0);
			var param1:MethodParam = new MethodParam("roomid", String(roomid));
			methodParams.push(param1);
			xmlCaller = new XmlCaller(methodParams);
			xmlCaller.addEventListener(XmlCaller.XML_LOADED, doneLoading);
			xmlCaller.addEventListener(XmlCaller.XML_ERROR, errorLoading);
		}
	
	
		
	}
	
}