package com.pingfit.events.remote 
{
	
	public class RemoteEventBase implements RemoteEvent {
		
		private var type:String = "";
		private var arg1:String = "";
		private var arg2:String = "";
		private var arg3:String = "";
		private var arg4:String = "";
		private var arg5:String = "";

		
		public function RemoteEventBase() { }
		
		
		public function setArgsRemote(arg1:String="", arg2:String="", arg3:String="", arg4:String="", arg5:String=""):void {
			setArg1(arg1);
			setArg2(arg2);
			setArg3(arg3);
			setArg4(arg4);
			setArg5(arg5);
		}
		
		public function invokeLocalEvent():void { }
		
		public function getType():String { return type; }
		public function setType(type:String):void { this.type = type; }
		public function getArg1():String { return arg1; }
		public function setArg1(arg1:String):void { this.arg1 = arg1; }
		public function getArg2():String { return arg2; }
		public function setArg2(arg2:String):void { this.arg2 = arg2; }
		public function getArg3():String { return arg3; }
		public function setArg3(arg3:String):void { this.arg3 = arg3; }
		public function getArg4():String { return arg4; }
		public function setArg4(arg4:String):void { this.arg4 = arg4; }
		public function getArg5():String { return arg5; }
		public function setArg5(arg5:String):void { this.arg5 = arg5; }
		
	}
	
}