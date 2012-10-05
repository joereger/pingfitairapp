package com.pingfit.controls
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.desktop.NativeApplication;
	import flash.display.BitmapData;
	import flash.display.Bitmap;

	public class User16Icon extends Sprite{
		
		var bmp:Bitmap;
		private var bmpData:BitmapData;

		public function User16Icon():void{
			bmpData = new user2png(16,16);
			bmp=new Bitmap();
			bmp.bitmapData=bmpData;
			addChild(bmp);
			buttonMode = true;
		}
		
	}
}