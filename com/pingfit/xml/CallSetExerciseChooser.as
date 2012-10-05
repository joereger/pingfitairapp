package com.pingfit.xml {
	
	import com.pingfit.xml.XmlCaller;
	import flash.events.*;
	import com.pingfit.events.*;
	
	public class CallSetExerciseChooser extends XmlCallBase {
		

		public function CallSetExerciseChooser(exercisechooserid:int) { 
			var methodParams:Array = new Array();
			var param0:MethodParam = new MethodParam("method", "setExerciseChooser");
			methodParams.push(param0);
			var param1:MethodParam = new MethodParam("exercisechooserid", String(exercisechooserid));
			methodParams.push(param1);
			xmlCaller = new XmlCaller(methodParams);
			xmlCaller.addEventListener(XmlCaller.XML_LOADED, doneLoading);
			xmlCaller.addEventListener(XmlCaller.XML_ERROR, errorLoading);
		}
	
		
		
	}
	
}