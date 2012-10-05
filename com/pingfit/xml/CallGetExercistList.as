package com.pingfit.xml {
	
	import com.pingfit.xml.XmlCaller;
	import flash.events.*;
	import com.pingfit.events.*;
	
	public class CallGetExerciseList extends XmlCallBase {
		


		public function CallGetExerciseList(exerciselistid:int) { 
			var methodParams:Array = new Array();
			var param0:MethodParam = new MethodParam("method", "getExerciseList");
			methodParams.push(param0);
			var param1:MethodParam = new MethodParam("exerciselistid", exerciselistid);
			methodParams.push(param1);
			xmlCaller = new XmlCaller(methodParams);
			xmlCaller.addEventListener(XmlCaller.XML_LOADED, doneLoading);
			xmlCaller.addEventListener(XmlCaller.XML_ERROR, errorLoading);
		}
	
		
		
	}
	
}