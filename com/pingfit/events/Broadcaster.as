package com.pingfit.events {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Broadcaster
	{

		private static var eventDispatcher:EventDispatcher;

		public static function broadcast( event:Event ):void{
			dispatchEvent( event );
		}

		public static function addEventListener( type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=true ):void{
			if ( !eventDispatcher ){ eventDispatcher = new EventDispatcher();}
			eventDispatcher.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}

		public static function removeEventListener( type:String, listener:Function, useCapture:Boolean=false ):void{
			if ( eventDispatcher ){ eventDispatcher.removeEventListener( type, listener, useCapture );}
  	    }

		public static function dispatchEvent( p_event:Event ):void {
			if ( eventDispatcher ){ eventDispatcher.dispatchEvent( p_event );}
		}

	}
}
