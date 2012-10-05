package com.pingfit.xml {
	
	import com.pingfit.xml.XmlCaller;
	import flash.events.*;
	import com.pingfit.events.*;
	
	public class CallGetExerciseLists extends XmlCallBase {
		


		public function CallGetExerciseLists() { 
			var methodParams:Array = new Array();
			var param0:MethodParam = new MethodParam("method", "getExerciseLists");
			methodParams.push(param0);
			xmlCaller = new XmlCaller(methodParams);
			xmlCaller.addEventListener(XmlCaller.XML_LOADED, doneLoading);
			xmlCaller.addEventListener(XmlCaller.XML_ERROR, errorLoading);
		}
	
	
		
	}
	
}