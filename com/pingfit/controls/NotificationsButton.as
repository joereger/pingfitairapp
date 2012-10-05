package com.pingfit.controls
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.desktop.NativeApplication;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.pingfit.data.static.Notifications;
	import gs.TweenLite;
	import gs.easing.*;
	import gs.TweenGroup;


	public class NotificationsButton extends Sprite{
		
		var bmp:Bitmap;
		private var bmpData:BitmapData;
		private var flashTimer:Timer;

		public function NotificationsButton():void{
			bmpData = new buttonNotification32png(32,32);
			bmp=new Bitmap();
			bmp.bitmapData=bmpData;
			addChild(bmp);
			buttonMode = true;
			flashTimer = new Timer(1000);
			flashTimer.addEventListener(TimerEvent.TIMER, flashTimerTick);
			flashTimer.start();
		}
		
		private function flashTimerTick(e:TimerEvent):void {
			if (Notifications.getNumberOfNotifications() > 0) {
				var modulo:Number = flashTimer.currentCount % 2;
				if (modulo == 1){
					bmp.alpha = .25;
					//TweenLite.to(bmp, 1, {alpha:.25})
				} else {
					bmp.alpha = 1;
					//TweenLite.to(bmp, 1, {alpha:1})
				}
			} else {
				bmp.alpha = .25;
			}
		}
	}
}