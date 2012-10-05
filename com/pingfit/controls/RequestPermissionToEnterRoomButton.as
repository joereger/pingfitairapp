package com.pingfit.controls
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.desktop.NativeApplication;
	import flash.display.BitmapData;
	import flash.display.Bitmap;

	public class RequestPermissionToEnterRoomButton extends Sprite{
		
		var bmp:Bitmap;
		private var bmpData:BitmapData;

		public function RequestPermissionToEnterRoomButton():void{
			bmpData = new RequestPermissionToEnterRoompng(187,50);
			bmp=new Bitmap();
			bmp.bitmapData=bmpData;
			addChild(bmp);
			buttonMode = true;
		}
		
	}
}