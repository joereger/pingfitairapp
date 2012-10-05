package com.pingfit.controls
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.desktop.NativeApplication;
	import flash.display.BitmapData;
	import flash.display.Bitmap;

	public class FacebookConnectButton extends Sprite{
		
		var bmp:Bitmap;
		private var bmpData:BitmapData;

		public function FacebookConnectButton():void{
			bmpData = new FacebookConnectIcon(194,25);
			bmp=new Bitmap();
			bmp.bitmapData=bmpData;
			addChild(bmp);
			buttonMode = true;
		}
		
	}
}