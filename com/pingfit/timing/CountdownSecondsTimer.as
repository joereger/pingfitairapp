package com.pingfit.timing {
	
	import flash.utils.Timer;
	import flash.events.*;
	import flash.utils.getTimer;
	import com.pingfit.events.Broadcaster;
	
	public class CountdownSecondsTimer extends EventDispatcher {
		
		
		private var startTimeMillis:Number;
		private var endTimeMillis:Number;
		private var everySecond:Timer;
		private var pauseStartMillis:Number;
		private var millisSpentInPause:Number;
		private var isPaused:Boolean;
		private var identifier:String;

		
		public function CountdownSecondsTimer(secondsRemaining:int, identifier:String = "unidentified") {
			this.identifier = identifier;
			everySecond = new Timer(1000);
			everySecond.addEventListener(TimerEvent.TIMER,onTimeTick);
			reset(secondsRemaining);
		}
		
		public function reset(secondsRemaining:int){
			millisSpentInPause = 0;
			pauseStartMillis = 0;
			isPaused = false;
			this.startTimeMillis = getTimer();
			this.endTimeMillis = startTimeMillis + (secondsRemaining*1000);
			everySecond.start();
			Broadcaster.dispatchEvent(new CountdownSecondsTimerEvent(CountdownSecondsTimerEvent.START));
		}
		
		public function getSecondsTotal():Number{
			//var out:Number = ((endTimeMillis - startTimeMillis - millisSpentInPause - getPendingPausedMillis())/1000);
			var out:Number = getMillisTotal()/1000;
			//trace("CountdownSecondsTimer -- getSecondsTotal()="+out);
			return out;
		}
		
		public function getMillisTotal():Number{
			//var out:Number = ((endTimeMillis - startTimeMillis - millisSpentInPause - getPendingPausedMillis())/1000);
			var out:Number = endTimeMillis - startTimeMillis;
			//trace("CountdownSecondsTimer -- getMillisTotal()="+out);
			return out;
		}
		
		public function getSecondsRemaining():Number{
			//var out:Number = endTimeMillis - getTimer() - millisSpentInPause - getPendingPausedMillis();
			var out:Number = getMillisRemaining()/1000;
			//trace("CountdownSecondsTimer -- getSecondsRemaining()="+out);
			return out;
		}
		
		public function getMillisRemaining():Number{
			//var out:Number = endTimeMillis - getTimer() - millisSpentInPause - getPendingPausedMillis();
			var out:Number = getMillisTotal() - getMillisElapsed();
			//trace("CountdownSecondsTimer -- getMillisRemaining()="+out);
			return out;
		}
		
		public function getSecondsElapsed():Number{
			return getMillisElapsed()/1000;
		}
		
		public function getMillisElapsed():Number{
			var out:Number = getTimer() - startTimeMillis - millisSpentInPause - getMillisPendingPaused();
			//trace("CountdownSecondsTimer -- getSecondsElapsed()="+out);
			return out;
		}
		
		public function getMillisPendingPaused():Number{
			//If paused then there are millis that aren't yet saved to millisSpentInPause so I need to account for them
			var pendingPausedMillis = 0;
			if (isPaused){
				pendingPausedMillis = getTimer() - pauseStartMillis;
			} 
			//trace("CountdownSecondsTimer -- getPendingPausedMillis()="+pendingPausedMillis);
			return pendingPausedMillis;
		}
		
		public function toggleTimer():void{
			trace("CountdownSecondsTimer -- toggleTimer()");
			if (getSecondsRemaining()>0){
				if (everySecond.running){
					pause();
				} else {
					start();
				}
			}
		}
		
		public function getIsRunning():Boolean{
			if (getSecondsRemaining()>0){
				if (everySecond.running){
					return true;
				} else {
					return false;
				}
			}
			return false;
		}
		
		
		
		public function pause():void{
			trace("CountdownSecondsTimer -- pause()");
			pauseStartMillis = getTimer();
			isPaused = true;
			everySecond.stop();
			Broadcaster.dispatchEvent(new CountdownSecondsTimerEvent(CountdownSecondsTimerEvent.PAUSE, identifier));
		}
		
		public function start():void{
			trace("CountdownSecondsTimer -- start()");
			if (pauseStartMillis>0){
				millisSpentInPause = millisSpentInPause + (getTimer() - pauseStartMillis);
				pauseStartMillis = 0;
			}
			isPaused = false;
			everySecond.start();
			Broadcaster.dispatchEvent(new CountdownSecondsTimerEvent(CountdownSecondsTimerEvent.START, identifier));
		}
		
		private function onTimeTick(event:TimerEvent):void{
			if (getSecondsRemaining()<=0){
				onTimeComplete(null);
			}
		}

		private function onTimeComplete(event:TimerEvent):void{
			everySecond.stop();
			trace("CountdownSecondsTimer.onTimeComplete() dispatching CountdownSecondsTimerEvent.ALARM with identifier="+identifier);
			Broadcaster.dispatchEvent(new CountdownSecondsTimerEvent(CountdownSecondsTimerEvent.ALARM, identifier));
		}	
		
		public function getIsPaused():Boolean{
			return isPaused;
		}
		
	}
	
}