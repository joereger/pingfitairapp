﻿package com.pingfit.xml {
	
	import com.pingfit.xml.XmlCaller;
	import flash.events.*;
	import com.pingfit.events.*;
	
	public class CallGetRoomsIModerate extends XmlCallBase {
		


		public function CallGetRoomsIModerate() { 
			var methodParams:Array = new Array();
			methodParams.push(new MethodParam("method", "getRoomsIModerate"));
			xmlCaller = new XmlCaller(methodParams);
			xmlCaller.addEventListener(XmlCaller.XML_LOADED, doneLoading);
			xmlCaller.addEventListener(XmlCaller.XML_ERROR, errorLoading);
		}
	
		
		
	}
	
}