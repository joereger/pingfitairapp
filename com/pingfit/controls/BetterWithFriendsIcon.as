package com.pingfit.controls
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.desktop.NativeApplication;
	import flash.display.BitmapData;
	import flash.display.Bitmap;


	public class BetterWithFriendsIcon extends Sprite{
		
		var bmp:Bitmap;
		private var bmpData:BitmapData;

		public function BetterWithFriendsIcon():void{
			bmpData = new BetterWithFriendsIconpng(128,128);
			bmp=new Bitmap();
			bmp.bitmapData=bmpData;
			addChild(bmp);
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(event:MouseEvent):void{
			//stage.nativeWindow.close();
			//NativeApplication.nativeApplication.exit();
		}
	}
}