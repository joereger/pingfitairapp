﻿package com.pingfit.chat
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.desktop.NativeApplication;
	import flash.display.BitmapData;
	import flash.display.Bitmap;


	public class IconUserEnterRoom extends MovieClip {
		
		var bmp:Bitmap;
		private var bmpData:BitmapData;

		public function IconUserEnterRoom():void{
			bmpData = new adduser_16png(16,16);
			bmp=new Bitmap();
			bmp.bitmapData=bmpData;
			addChild(bmp);
			buttonMode = false;
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(event:MouseEvent):void{
			//stage.nativeWindow.close();
			//NativeApplication.nativeApplication.exit();
		}
	}
}