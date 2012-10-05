package com.pingfit.events.remote {
	
	public interface RemoteEvent {
		function invokeLocalEvent():void;
		function setArgsRemote(arg1:String = "", arg2:String = "", arg3:String = "", arg4:String = "", arg5:String = ""):void;
		function getType():String;
		function setType(type:String):void;
		function getArg1():String;
		function setArg1(arg1:String):void;
		function getArg2():String;
		function setArg2(arg2:String):void;
		function getArg3():String;
		function setArg3(arg3:String):void;
		function getArg4():String;
		function setArg4(arg4:String):void;
		function getArg5():String;
		function setArg5(arg5:String):void;
	}
	
}