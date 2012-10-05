package com.pingfit.icon {
	
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import com.pingfit.icon.PieChartProgress;
	import flash.utils.Timer;
	import com.pingfit.data.static.NextWorkoutTimer;
	import flash.events.TimerEvent;
	import flash.desktop.NativeApplication;
	import flash.desktop.NotificationType;
	import flash.desktop.SystemTrayIcon;
	import com.pingfit.events.PEvent;
	import com.pingfit.events.Broadcaster;
	import com.pingfit.data.static.AlarmStatus;
	
	public class TrayIcon extends Sprite {
		
		private var pieChartProgress:PieChartProgress;
		private var radius:Number = 75;
		private var totalProgress:Number = 100;
		private var currentProgress:Number = 0;
		private var rim:Sprite = new Sprite();
		private var buttonYellow:ButtonYellow;
		private var bgTimer:Timer;
		
		public function TrayIcon(currentProgress:Number, totalProgress:Number, radius:Number) { 
			this.radius = radius;
			this.currentProgress = currentProgress;
			this.totalProgress = totalProgress;
		
			
			with (rim.graphics){
				beginFill(0x000000);
				drawCircle(radius,radius,radius);
				endFill();
			}
			addChild(rim);
			
			pieChartProgress = new PieChartProgress(currentProgress, totalProgress, radius-(radius*.2));
			pieChartProgress.x = radius;
			pieChartProgress.y = radius;
			addChild(pieChartProgress);

			
			buttonYellow = new ButtonYellow();
			//buttonYellow.width = (radius*2)-(radius*.2);
			//buttonYellow.height = (radius*2)-(radius*.2);
			buttonYellow.x = radius;
			buttonYellow.y = radius;
			buttonYellow.alpha = 1;
			buttonYellow.mask = pieChartProgress;
			addChild(buttonYellow);
			
			//BgTimer controls things every second
			bgTimer = new Timer(1000);
			bgTimer.addEventListener(TimerEvent.TIMER, bgTimerTick);
			bgTimer.start();
			
		}
		
		private function bgTimerTick(e:TimerEvent):void{
			//Redraw the timer icon
			//trace("TrayIcon.bgTimerTick()");
			if(NextWorkoutTimer.getTimer()!=null){
				if (!AlarmStatus.getIsAlarmRinging()) {
					//trace("TrayIcon.bgTimerTick() !AlarmStatus.getIsAlarmRinging()");
					if (NextWorkoutTimer.getTimer().getSecondsRemaining() > 0) {
						//trace("TrayIcon.bgTimerTick() NextWorkoutTimer.getTimer().getSecondsRemaining() > 0");
						var currentProgress:Number = NextWorkoutTimer.getTimer().getSecondsTotal() - NextWorkoutTimer.getTimer().getSecondsRemaining();
						var totalProgress:Number = NextWorkoutTimer.getTimer().getSecondsTotal();
						setTotalProgress(currentProgress, totalProgress);
					} else {
						//trace("TrayIcon.bgTimerTick() setting to 100,100");
						setTotalProgress(100, 100);
					}
				} else {
					//Flash the tray icon
					//trace("TrayIcon.bgTimerTick() flashing the tray icon");
					var modulo:Number = NextWorkoutTimer.getTimer().getSecondsRemaining() % 2;
					//trace("modulo="+modulo);
					if (modulo <= 1){
						setTotalProgress(100, 100);
					} else {
						setTotalProgress(0, 100);
					}
				}
			} else {
				setTotalProgress(0, 100);
			}
			//Update the systray icon
			NativeApplication.nativeApplication.icon.bitmaps = [getBitmapData()];
		}
		
		
		
		public function setCurrentProgress(currentProgress:Number):void{
			this.currentProgress = currentProgress;
			redrawPie();
		}
		
		public function setTotalProgress(currentProgress:Number, totalProgress:Number):void{
			this.currentProgress = currentProgress;
			this.totalProgress= totalProgress;
			redrawPie();
		}
		
		private function redrawPie():void{
			pieChartProgress.setEverything(currentProgress, totalProgress, radius-(radius*.2));
			if (1==2 && currentProgress>=totalProgress){
				pieChartProgress.alpha = 0;
				rim.alpha = 0;
			} else {
				pieChartProgress.alpha = 1;
				rim.alpha = 1;
			}
		}
		
		public function getBitmapData():BitmapData{
			//trace("PieChartIcon.getBitmapData() called");
			var img:BitmapData = new BitmapData(this.width, this.height, true , 0x00000000);
			img.draw(this);
			return img;
		}
	
		
	}
	
}