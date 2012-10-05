package com.pingfit.controls
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.desktop.NativeApplication;
	import flash.display.BitmapData;
	import flash.display.Bitmap;

	public class MinimizeButton extends Sprite{
		
		var bmp:Bitmap;
		private var bmpData:BitmapData;

		public function MinimizeButton():void{
			bmpData = new buttonMinimize32png(32,32);
			bmp=new Bitmap();
			bmp.bitmapData=bmpData;
			addChild(bmp);
			buttonMode = true;
		}
		
	}
}