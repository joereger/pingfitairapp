package com.pingfit.controls
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.desktop.NativeApplication;
	import flash.display.BitmapData;
	import flash.display.Bitmap;

	public class RoomIcon24 extends Sprite{
		
		var bmp:Bitmap;
		private var bmpData:BitmapData;

		public function RoomIcon24():void{
			bmpData = new door2png(24,24);
			bmp=new Bitmap();
			bmp.bitmapData=bmpData;
			addChild(bmp);
			buttonMode = true;
		}
		
	}
}