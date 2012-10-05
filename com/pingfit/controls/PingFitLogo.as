package com.pingfit.controls
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.desktop.NativeApplication;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import com.pingfit.data.static.CurrentPl;
	import lt.uza.utils.Global;
	import com.pingfit.events.PEvent;
	import com.pingfit.events.Broadcaster;
	import flash.events.*
	import flash.display.*;
	import flash.net.URLRequest;

	public class PingFitLogo extends MovieClip {
		
		var bmp:Bitmap;
		private var bmpData:BitmapData;
		private var exImgLoader:Loader;

		public function PingFitLogo():void {
			Global.getInstance().debug = Global.getInstance().debug + "(PingFitLogo.as instanciated)";
			trace("loading up PingFitLogo via package class, no Library... wootMe!");
			Broadcaster.addEventListener(PEvent.CURRENTPLSET, updateLogo);
			//Use built-in for now... maybe later have an empty one until pl is loaded??
			//useBuiltIn();
		}
		
		public function removeLogo():void {
			try {
				removeChild(bmp);
			} catch (error:Error) { trace("PingFitLogo: Error catch: " + error); }
		}
		
		public function updateLogo(e:Event):void {
			trace("PingFitLogo: updateLogo called");
			removeLogo();
			//Called whenever the pl is reloaded
			trace("PingFitLogo: CurrentPl.getPl().getAirlogo()="+CurrentPl.getPl().getAirlogo());
			if (CurrentPl.getPl().getPlid()>0 && CurrentPl.getPl().getAirlogo().length>0) {
				useByUrl(CurrentPl.getPl().getAirlogo());
			} else {
				useBuiltIn();
			}
		}
		
		private function useBuiltIn():void {
			trace("PingFitLogo: useBuiltIn() called");
			bmpData = new logov3png(190,66);
			bmp=new Bitmap();
			bmp.bitmapData=bmpData;
			addChild(bmp);
			buttonMode = false;
		}
		
		private function useByUrl(url:String):void {
			trace("PingFitLogo: useByUrl() called");
			loadImg();
		}
		
		private function loadImg():void {
			trace("PingFitLogo: loadImg() called");
			try{
				var imageUrl:String = CurrentPl.getPl().getAirlogo();
				var urlRequest:URLRequest = new URLRequest(imageUrl);
				exImgLoader = new Loader();
				exImgLoader.contentLoaderInfo.addEventListener(Event.INIT, imageInitted);
				exImgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageIoError);
				exImgLoader.load(urlRequest);
			} catch (error:Error) { trace("PingFitLogo: Error catch: " + error); }
		}
		
		private function imageInitted(e:Event):void{
			var img = exImgLoader.content;
			if (img is AVM1Movie){
				trace("PingFitLogo: is AVM1Movie");
				img = exImgLoader;
			} else {
				trace("PingFitLogo: not AVM1Movie");
			}
			bmp = new Bitmap();
			var dispObj:DisplayObject = resizeAndKeepAspect(img, 190, 66);
			
			var bd:BitmapData = new BitmapData(dispObj.width, dispObj.height, true, 0x00000000);
			bd.draw(dispObj);

			bmp.bitmapData = bd;
			addChild(bmp);
			buttonMode = false;
		}
		
		private function imageIoError(e:Event):void{
			trace("PingFitLogo: imageIoError happened:"+e);
		}
		
		private function resizeAndKeepAspect(img,boundW,boundH):DisplayObject {
			var imgW:Number = img.width;
			var imgH:Number = img.height;
			var ratio:Number;
			if (imgW >= imgH) {
				// image is wide or square
				ratio = imgH/imgW;
				imgW = boundW;
				imgH = imgW*ratio;
				if (imgH > boundH) {
					// image's height is still too large...resize on height
					imgH = boundH;
					imgW = imgH/ratio;
				}
			} else if (imgH > imgW) {
				// image is tall
				ratio = imgW/imgH;
				imgH = boundH;
				imgW = imgH*ratio;
				if (imgW > boundW) {
					// image's width is still too large...resize on width
					imgW = boundW;
					imgH = imgW/ratio;
				}
			}
			img.width = imgW;
			img.height = imgH;
			trace("PingFitLogo: resizeAndKeepAspect() img.width="+img.width+" img.height="+img.height);
			return img;
		}
		
	}
}