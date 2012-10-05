package com.pingfit.exercisepanel
{
	
	import flash.display.MovieClip;
	import fl.containers.ScrollPane;
	import flash.events.*;
	import flash.display.Stage;
	import flash.media.Video;
	import flash.text.*;
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import com.pingfit.xml.*;
	import noponies.events.NpTextScrollBarEvent;
	import noponies.ui.NpTextScroller;
	import gs.TweenLite;
	import gs.easing.*;
	import gs.TweenGroup;
	import com.pingfit.format.TextUtil;
	import com.pingfit.format.Shadow;
	import com.pingfit.controls.IDidItButton;
	import com.pingfit.controls.IllSkipItButton;
	import com.pingfit.data.objects.Exercise;
	import com.pingfit.data.static.*;
	import com.pingfit.events.ApiCallSuccess;
	import com.pingfit.events.ApiCallFail;
	import com.pingfit.events.DoExercise;
	import com.pingfit.events.SkipExercise;
	import com.pingfit.events.Broadcaster;
	import org.gif.decoder.*;
	import org.gif.encoder.*;
	import org.gif.errors.*;
	import org.gif.events.*;
	import org.gif.frames.*;
	import org.gif.player.*;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	

	public class ExercisePanel extends MovieClip {
		
		private var exercise:Exercise;
		private var instructionsScrollPane:ScrollPane;
		private var maxWidth:Number = 0;
		private var maxHeight:Number = 0;
		public var exercisename_txt:TextField;
		private var exerciseplaceinlist:String;
		private var instr_txt:TextField;
		private var recommendedReps:TextField;
		private var imagecredit:TextField;
		private var exImgLoader:Loader;
		private var img;
		private var butDidIt:SimpleButton;
		private var doneButton:IDidItButton;
		private var butSkipIt:IllSkipItButton;
		private var instr_bg:Shape;
		private var instrScroll:NpTextScroller;
		private var myGIFPlayer:GIFPlayer;
		private var myGIFMC:MovieClip;
		
		private var vid:Video;
		private var nc:NetConnection;
		private var ns:NetStream;
		
		public function ExercisePanel(maxWidth:Number, maxHeight:Number, exercise:Exercise){
			//trace("ExercisePanel instanciated");
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			this.exercise = exercise;
			if (exercise==null){
				this.exercise = NextExercises.getCurrentExercise();
			}
			if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
		}
		
		
		function initListener (e:Event):void {
			//trace("ExercisePanel.initListener() called");
			removeEventListener(Event.ADDED_TO_STAGE, initListener);
			
			var exerciseid:int = exercise.getExerciseid();
			exerciseplaceinlist = exercise.getExerciseplaceinlist();
			
			var imageUrl:String = exercise.getImage();
			trace("ExercisePanel - imageUrl="+imageUrl);
			if (imageUrl.indexOf(".gif") > -1) {
				trace("ExercisePanel - imageUrl.indexOf(.gif) > -1");
				//It's a gif
				myGIFPlayer = new GIFPlayer();
				myGIFMC = new MovieClip();
				myGIFMC.addChild(myGIFPlayer);
				addChild(myGIFMC);
				myGIFPlayer.load ( new URLRequest (imageUrl) );
				// listen for the IOErrorEvent.IO_ERROR event, dispatched when the GIF fails to load
				myGIFPlayer.addEventListener ( IOErrorEvent.IO_ERROR, onGifIOError );
				// listen for the GIFPlayerEvent.COMPLETE event, dispatched when GIF is loaded
				myGIFPlayer.addEventListener ( GIFPlayerEvent.COMPLETE, onCompleteGIFLoad );
				// listen for the FrameEvent.FRAME_RENDERED event, dispatched when a GIF frame is rendered on screen
				//myGIFPlayer.addEventListener ( FrameEvent.FRAME_RENDERED, onGifFrameRendered );
				// listen for the FileTypeEvent.INVALID event, dispatched when an invalid file is loaded
				myGIFPlayer.addEventListener ( FileTypeEvent.INVALID, onGifInvalidFileLoaded );
			} else if (imageUrl.indexOf(".flv") > -1) {
				trace("ExercisePanel.as - imageUrl.indexOf(.flv) > -1 so calling loadVid()");
				loadVid();	
			} else {
				trace("ExercisePanel.as - imageUrl.indexOf(.gif) <= -1 so calling loadImg()");
				loadImg();			
			}
		
			
			
			exercisename_txt = TextUtil.getTextField(TextUtil.getHelveticaRounded(35, 0xE6E6E6, true), maxWidth-310, exercise.getName());
			exercisename_txt.filters = Shadow.getDropShadowFilterArray(0x000000);
			exercisename_txt.x = 300;
			exercisename_txt.y = 0;
			addChild(exercisename_txt);
			
			if (exercise != null && exercise.getImagecredit() != null && exercise.getImagecredit() != "null") {
				imagecredit = TextUtil.getTextField(TextUtil.getHelveticaRounded(8, 0xE6E6E6, true), 290, "Image by: "+exercise.getImagecredit());
				imagecredit.filters = Shadow.getDropShadowFilterArray(0x000000);
				imagecredit.alpha = 0;
				addChild(imagecredit);
				if (exercise != null && exercise.getImagecrediturl() != null && exercise.getImagecrediturl() != "null") {
					imagecredit.addEventListener(MouseEvent.CLICK, onClickImageCredit);
				}
			}
			
			
			recommendedReps = TextUtil.getTextField(TextUtil.getHelveticaRounded(18, 0xE6E6E6, true), maxWidth-310, "Recommendation: "+exercise.getReps()+" reps");
			recommendedReps.filters = Shadow.getDropShadowFilterArray(0x000000);
			recommendedReps.x = 300;
			recommendedReps.y = exercisename_txt.y + exercisename_txt.textHeight + 3;
			addChild(recommendedReps);
			
			
			var instrX:Number = 300;
			var instrY:Number = recommendedReps.y + recommendedReps.textHeight + 5;
			var instrWidth:Number = 290;
			var instrHeight:Number = 130;
			if (instrY>85){
				var amtToCrunchInstr:Number = instrY - 75;
				instrHeight = instrHeight - amtToCrunchInstr;
			}
			var instrFormat:TextFormat = TextUtil.getArial(12, 0xE6E6E6, true);
			instrScroll = new NpTextScroller();
			instrScroll.dragHandleColour = 0xFFCCFF;
			instrScroll.sliderBarWidth = 10;
			instrScroll.sliderBarHeight = instrHeight;
			instrScroll.scrollWidth = instrWidth;
			instrScroll.scrollHeight = instrHeight;
			instrScroll.useEmbeddedFont = true;
			instrScroll.sliderXPos = instrWidth-10;
			instrScroll.sliderYPos = 0;
			instrScroll.textScrollBlur = false;
			instrScroll.mouseWheelScrolling = true;
			instrScroll.addScrollText(exercise.getDescription(), instrFormat);
			instrScroll.x = instrX;
			instrScroll.y = instrY;
			addChild(instrScroll);
			
			//Note that I added the following function to NpTextScroller()
			//public function getTextRectHeight(){
			//	return _textRectHeight;
			//}
			var instrScrollTextRectHeight:int = instrScroll.getTextRectHeight();
			//If this var breaks, check that the library still has the manually-added method
			var buttonY:Number =  instrY + instrScrollTextRectHeight + 5;
			if (instrScrollTextRectHeight>instrHeight){
				buttonY = instrY + instrHeight + 5;
			}

			
			doneButton = new IDidItButton();
			doneButton.buttonMode = true;
			doneButton.x = maxWidth - 270;
			doneButton.y = buttonY;
			addChild(doneButton);
			doneButton.addEventListener(MouseEvent.CLICK, iDidIt);
			
			butSkipIt = new IllSkipItButton();
			butSkipIt.buttonMode = true;
			addChild(butSkipIt);
			butSkipIt.x = maxWidth - 128;
			butSkipIt.y = buttonY;
			butSkipIt.addEventListener(MouseEvent.CLICK, skipIt);
			//trace("butSkipIt.x="+butSkipIt.x+" butSkipIt.y="+butSkipIt.y);
		
			
			resize(maxWidth, maxHeight);
		}
		
		private function loadVid():void {
			trace("ExercisePanel - loadVid() called");
			try{
				//Not a gif
				var vidUrl:String = exercise.getImage();
				//var urlRequest:URLRequest = new URLRequest(vidUrl);
				//exImgLoader = new Loader();
				//exImgLoader.contentLoaderInfo.addEventListener(Event.INIT, imageInitted);
				//exImgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageIoError);
				//exImgLoader.load(urlRequest);
				
				
				
				nc = new NetConnection();
				nc.connect(null);
				ns = new NetStream(nc);
				vid = new Video(300, 164);
				addChild(vid);
				vid.x = 0;
				vid.y = 0;
				vid.attachNetStream(ns);
				ns.play(vidUrl);
				ns.addEventListener(NetStatusEvent.NET_STATUS, netstat);
				var netClient:Object = new Object();
				netClient.onMetaData = function(meta:Object){
					trace(meta.duration);
					if(meta.height != null && meta.width != null){
						  trace("our video is "+meta.width+"x"+meta.height+" pixels");
						  vid.height = meta.height;
						  vid.width = meta.width;
					 }
				};
				ns.client = netClient;
				
			} catch (error:Error) { trace("Error catch: " + error); }
		}
		
		function netstat(stats:NetStatusEvent){
			trace(stats.info.code);
			if (stats.info.code == "NetStream.Play.Stop") {
				trace("restarting video... ns.seek(0)");
				ns.seek(0);
			}
		}

		
		private function loadImg():void {
			trace("ExercisePanel - loadImg() called");
			try{
				//Not a gif
				var imageUrl:String = exercise.getImage();
				var urlRequest:URLRequest = new URLRequest(imageUrl);
				exImgLoader = new Loader();
				exImgLoader.contentLoaderInfo.addEventListener(Event.INIT, imageInitted);
				exImgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageIoError);
				exImgLoader.load(urlRequest);
			} catch (error:Error) { trace("Error catch: " + error); }
		}
		
		private function onCompleteGIFLoad(pEvt:GIFPlayerEvent):void {
			trace("ExercisePanel - onCompleteGIFLoad() called");
			//img = myGIFPlayer;
			//img = resizeAndKeepAspect(img, 290, 230);
			//addChild(img);
			//img.play();
			//img.x = (290 - img.width)/2;
			//img.y = 0;
			//img.alpha = 0.0;
			//img.filters = Shadow.getDropShadowFilterArray(0x000000); 
			//TweenLite.to(img, 4, { alpha:1 } );
			var frameRect:Rectangle = pEvt.rect;
			//myGIFPlayer.x = ( stage.stageWidth - FrameRect.width ) /2;
			//myGIFPlayer.y = ( stage.stageHeight - FrameRect.height ) /2;
			
			
			
			trace("ExercisePanel - onCompleteGIFLoad() (PRE ) pEvt.rect=" + pEvt.rect);
			trace("ExercisePanel - onCompleteGIFLoad() (PRE ) myGIFPlayer.getRect(this)=" + myGIFPlayer.getRect(this));
			trace("ExercisePanel - onCompleteGIFLoad() (PRE ) myGIFPlayer.width=" + myGIFPlayer.width);
			trace("ExercisePanel - onCompleteGIFLoad() (PRE ) myGIFPlayer.height=" + myGIFPlayer.height);
			trace("ExercisePanel - onCompleteGIFLoad() (PRE ) myGIFMC.getRect(this)=" + myGIFMC.getRect(this));
			trace("ExercisePanel - onCompleteGIFLoad() (PRE ) myGIFMC.width=" + myGIFMC.width);
			trace("ExercisePanel - onCompleteGIFLoad() (PRE ) myGIFMC.height=" + myGIFMC.height);
			//myGIFMC.addChild(myGIFPlayer);
			//myGIFMC.x = 50;
			//myGIFMC.y = 50;
			//myGIFPlayer.x = 0;
			//myGIFPlayer.y = 0;
			//myGIFPlayer = resizeAndKeepAspectGif(myGIFPlayer, pEvt.rect.width, pEvt.rect.height, 290, 230);
			//myGIFMC.width = 50;
			//myGIFMC.height = 50;
			//myGIFMC.scaleX = .5;
			//myGIFMC.scaleY = .5;
			myGIFMC = resizeAndKeepAspectMC(myGIFMC, pEvt.rect.width, pEvt.rect.height, 290, 230);
			trace("ExercisePanel - onCompleteGIFLoad() (POST) pEvt.rect=" + pEvt.rect);
			trace("ExercisePanel - onCompleteGIFLoad() (POST) myGIFPlayer.getRect(this)=" + myGIFPlayer.getRect(this));
			trace("ExercisePanel - onCompleteGIFLoad() (POST) myGIFPlayer.width=" + myGIFPlayer.width);
			trace("ExercisePanel - onCompleteGIFLoad() (POST) myGIFPlayer.height=" + myGIFPlayer.height);
			trace("ExercisePanel - onCompleteGIFLoad() (POST) myGIFMC.getRect(this)=" + myGIFMC.getRect(this));
			trace("ExercisePanel - onCompleteGIFLoad() (POST) myGIFMC.width=" + myGIFMC.width);
			trace("ExercisePanel - onCompleteGIFLoad() (POST) myGIFMC.height=" + myGIFMC.height);
			//addChild(myGIFPlayer);
			//myGIFPlayer.play();
			//myGIFPlayer.x = (290 - myGIFPlayer.width)/2;
			//myGIFPlayer.y = 0;
			//trace("ExercisePanel - onCompleteGIFLoad() myGIFPlayer.x=" + myGIFPlayer.x);
			//trace("ExercisePanel - onCompleteGIFLoad() myGIFPlayer.y=" + myGIFPlayer.y);
			//trace("ExercisePanel - onCompleteGIFLoad() myGIFPlayer.alpha=" + myGIFPlayer.alpha);
			//trace("ExercisePanel - onCompleteGIFLoad() myGIFPlayer.width=" + myGIFPlayer.width);
			//trace("ExercisePanel - onCompleteGIFLoad() myGIFPlayer.height=" + myGIFPlayer.height);
			//trace("ExercisePanel - onCompleteGIFLoad() myGIFPlayer.frames.length=" + myGIFPlayer.frames.length);
			//myGIFPlayer.alpha = 0.0;
			//myGIFPlayer.filters = Shadow.getDropShadowFilterArray(0x000000); 
			//TweenLite.to(myGIFPlayer, 4, {alpha:1});
			
			resize(maxWidth, maxHeight);
			
		}
		
		private function onGifInvalidFileLoaded(e:Event):void {
			trace("ExercisePanel - onGifInvalidFileLoaded() called");
			loadImg();
		}

		private function onGifIOError(e:Event):void {
			trace("ExercisePanel - onGifIOError() called");
			loadImg();
		}
		

		public function resize (maxWidth:Number, maxHeight:Number):void {
			//trace("ExercisePanel -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			
			//trace("ExercisePanel -- stageWidth: " + parent.stage.stageWidth + " stageHeight: " + parent.stage.stageHeight);
			
			
			
			//Image Credit
			if (exercise != null && exercise.getImagecredit() != null && exercise.getImagecredit() != "null") {
				var imagecreditX:Number = 0;
				var imagecreditY:Number = 235;
				//Move the image credit
				imagecredit.x = imagecreditX;
				imagecredit.y = imagecreditY;
				imagecredit.alpha = 1;
			}
			
		}
		
		private function imageInitted(e:Event):void{
			var img = exImgLoader.content;

			if (img is AVM1Movie){
				trace("is AVM1Movie");
				img = exImgLoader;
			} else {
				trace("not AVM1Movie");
				img = exImgLoader.content;
			}
			img = resizeAndKeepAspect(img, 290, 230);
			
			
			addChild(img);
			img.x = (290 - img.width)/2;
			img.y = 0;
			img.alpha = 0.0;
			img.filters = Shadow.getDropShadowFilterArray(0x000000); 
			TweenLite.to(img, 4, { alpha:1 } );
			resize(maxWidth, maxHeight);
		}
		
		private function imageIoError(e:Event):void{
			trace("imageIoError happened:"+e);
		}
		
		
		
		
		public function iDidIt(event:Event):void{
			trace("iDidIt clicked");
			var myGroup:TweenGroup = new TweenGroup();
			myGroup.align = TweenGroup.ALIGN_END;
			myGroup.push(TweenLite.to(doneButton, 1.75, {x:maxWidth+10, ease:Elastic.easeIn}));
			myGroup.push(TweenLite.to(butSkipIt, 1, {x:maxWidth+10, ease:Elastic.easeIn}));
			var callDoExercise:CallDoExercise = new CallDoExercise(exercise.getExerciseid(), exercise.getReps(), exercise.getExerciseplaceinlist());
			callDoExercise.addEventListener(ApiCallSuccess.TYPE, iDidItDone);
		}
		private function iDidItDone(e:ApiCallSuccess):void{
			trace("iDidItDone");
			PingFit.resetAutoSkipCount();
			Broadcaster.dispatchEvent(new DoExercise(exercise));
		}
		
		public function skipIt(event:Event):void{
			trace("skipIt clicked");
			var myGroup:TweenGroup = new TweenGroup();
			myGroup.align = TweenGroup.ALIGN_END;
			myGroup.push(TweenLite.to(doneButton, 1, {x:maxWidth+10, ease:Elastic.easeIn}));
			myGroup.push(TweenLite.to(butSkipIt, 1.75, {x:maxWidth+10, ease:Elastic.easeIn}));
			var callSkipExercise:CallSkipExercise = new CallSkipExercise();
			callSkipExercise.addEventListener(ApiCallSuccess.TYPE, skipItDone);
		}
		private function skipItDone(e:ApiCallSuccess):void{
			trace("skipItDone");
			PingFit.resetAutoSkipCount();
			Broadcaster.dispatchEvent(new SkipExercise(exercise));
		}
		
		public function onClickImageCredit(e:MouseEvent):void {
			try {
				trace("ExercisePanel.onClickImageCredit() - exercise.getImagecrediturl()="+exercise.getImagecrediturl());
				var request:URLRequest = new URLRequest(exercise.getImagecrediturl());
                navigateToURL(request, "_blank");
            } catch (e:Error) {
                trace(e);
            }
		}
		
		
		
		
		public static function resizeAndKeepAspect(img,boundW,boundH):DisplayObject {
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
			trace("ExercisePanel - resizeAndKeepAspect() img.width="+img.width+" img.height="+img.height);
			return img;
		}
		
		private function resizeAndKeepAspectGif(img:GIFPlayer, startW, startH, boundW,boundH):GIFPlayer {
			var imgW:Number = startW;
			var imgH:Number = startH;
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
			trace("ExercisePanel - resizeAndKeepAspectGif() imgW="+imgW+" imgH="+imgH);
			trace("ExercisePanel - resizeAndKeepAspectGif() img.width="+img.width+" img.height="+img.height);
			return img;
		}
		
		private function resizeAndKeepAspectMC(img, startW, startH, boundW, boundH):MovieClip {
			var imgW:Number = startW;
			var imgH:Number = startH;
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
			//Now the trick with this GIF reader is to scale it, not change height or width
			trace("ExercisePanel - resizeAndKeepAspectMC() imgW=" + imgW + " imgH=" + imgH);
			var amtToScale:Number = 1;
			if (startW>0) {
				amtToScale = imgW / startW;
			}
			trace("ExercisePanel - resizeAndKeepAspectMC() amtToScale=" + amtToScale);
			img.scaleX = amtToScale;
			img.scaleY = amtToScale;
			//trace("ExercisePanel - resizeAndKeepAspectMC() img.width="+img.width+" img.height="+img.height);
			return img;
		}
		

		
		
		
	}

	
	
}