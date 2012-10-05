package com.pingfit.xml {
	
	public class MethodParam {
		
		private var paramname:String;
		private var paramvalue:String;

		public function MethodParam(paramname:String, paramvalue:String) { 
			this.paramname = paramname;
			this.paramvalue = paramvalue;
		}
		
		public function getName():String{
			return paramname;
		}
		public function setName(paramname:String):void{
			this.paramname = paramname;
		}
		
		public function getValue():String{
			return paramvalue;
		}
		public function setValue(paramvalue:String):void{
			this.paramvalue = paramvalue;
		}

	}
	
}