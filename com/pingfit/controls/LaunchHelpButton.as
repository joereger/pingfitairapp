package com.pingfit.controls
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.desktop.NativeApplication;
	import flash.display.BitmapData;
	import flash.display.Bitmap;

	public class LaunchHelpButton extends Sprite{
		
		var bmp:Bitmap;
		private var bmpData:BitmapData;

		public function LaunchHelpButton():void{
			bmpData = new LaunchHelppng(187,50);
			bmp=new Bitmap();
			bmp.bitmapData=bmpData;
			addChild(bmp);
			buttonMode = true;
		}
		
	}
}