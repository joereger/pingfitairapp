package com.pingfit.alerts {
	
	import flash.display.MovieClip;
	import flash.display.*;
	import com.pingfit.controls.Background;
	import com.pingfit.events.*;
	import com.pingfit.format.TextUtil;
	import com.pingfit.format.Shadow;
	import flash.text.*;
	import flash.events.*;
	import gs.TweenLite;
	import gs.easing.*;
	import gs.TweenGroup;
	import flash.utils.Timer;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	public class Alert extends MovieClip {
		
		private var maxWidth:Number = 0;
		private var maxHeight:Number = 0;
		private var bg:MovieClip;
		private var boldmsg:String = "";
		private var boldmsgTxt:TextField;
		private var tinymsg:String = "";
		private var tinymsgTxt:TextField;
		private var eventToDispatchOnClick:Event;
		private var bgTimer:Timer;
		
		public function Alert(maxWidth:Number, maxHeight:Number, boldmsg:String, tinymsg:String="", eventToDispatchOnClick:Event=null) {
			trace("Alert instanciated");
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			this.boldmsg = boldmsg;
			this.tinymsg = tinymsg;
			this.eventToDispatchOnClick = eventToDispatchOnClick;
			if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
		}
		
		function initListener(e:Event):void {
			trace("Alert.initListener() called");
			removeEventListener(Event.ADDED_TO_STAGE, initListener);
			
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver); 
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			//Create the background
			bg = new MovieClip();
			bg.alpha = 0;
			addChild(bg);
			
			boldmsgTxt = TextUtil.getTextField(TextUtil.getHelveticaRounded(16, 0xFFFFFF, true), maxWidth-15, boldmsg);
			//boldmsgTxt.filters = Shadow.getDropShadowFilterArray(0x000000);
			boldmsgTxt.mouseEnabled = true;
			boldmsgTxt.alpha = 0;
			addChild(boldmsgTxt);
			
			tinymsgTxt = TextUtil.getTextField(TextUtil.getHelveticaRounded(10, 0xFFFFFF, true), maxWidth-15, tinymsg);
			tinymsgTxt.filters = Shadow.getDropShadowFilterArray(0x000000);
			tinymsgTxt.mouseEnabled = true;
			tinymsgTxt.alpha = 0;
			addChild(tinymsgTxt);
			
			
			bgTimer = new Timer(6000, 1);
			bgTimer.addEventListener(TimerEvent.TIMER, bgTimerTick);
			bgTimer.start();
			

			var myGroup:TweenGroup = new TweenGroup();
			//myGroup.onComplete = startTimer;
			myGroup.align = TweenGroup.ALIGN_START;
			myGroup.push(TweenLite.to(bg, 1, { alpha:1 } ));
			myGroup.push(TweenLite.to(boldmsgTxt, 1, { alpha:1 } ));
			myGroup.push(TweenLite.to(tinymsgTxt, 1, { alpha:1 } ));
			
			//Initial Resize
			resize(maxWidth, maxHeight);
		}
		
		
		private function pauseTimer():void {
			bgTimer.stop();
		}
		
		private function startTimer():void {
			bgTimer.start();
		}
		
		private function bgTimerTick(e:TimerEvent):void{
			close();
		}
		
		private function onMouseOver(e:MouseEvent):void{
			pauseTimer();
		}
		private function onMouseOut(e:MouseEvent):void{
			startTimer();
		}
		
		//Resize
		public function resize(maxWidth:Number, maxHeight:Number):void {
			trace("Alert -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			
			bg.graphics.clear();
			bg.graphics.beginFill(0x333333);
			bg.graphics.drawRoundRect(0,0, maxWidth, maxHeight, 5);
			bg.graphics.endFill();
			bg.filters = Shadow.getDropShadowFilterArray(0x000000);
			bg.alpha = 1;
			
			boldmsgTxt.x = 5;
			boldmsgTxt.y = 5;
			
			tinymsgTxt.x = 5;
			tinymsgTxt.y = boldmsgTxt.textHeight + 2;
		}
		
		private function close():void {
			var myGroup:TweenGroup = new TweenGroup();
			myGroup.onComplete = closeParentWindow;
			myGroup.align = TweenGroup.ALIGN_START;
			myGroup.push(TweenLite.to(bg, 1, { alpha:0 } ));
			myGroup.push(TweenLite.to(boldmsgTxt, 1, { alpha:0 } ));
			myGroup.push(TweenLite.to(tinymsgTxt, 1, { alpha:0 } ));
		}
		
		private function closeParentWindow():void {
			trace("Alert.closeParentWindow() parent=" + parent);
			var window:NativeWindow = stage.nativeWindow;
			window.close();
			//NativeWindow(parent).close();
		}
		
	}
	
}