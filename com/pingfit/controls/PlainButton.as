package com.pingfit.controls {
	
	
	import flash.display.MovieClip;
	import com.pingfit.controls.Background;
	import com.pingfit.events.*;
	import com.pingfit.format.TextUtil;
	import com.pingfit.format.Shadow;
	import flash.text.*;
	import flash.events.Event;
	import flash.events.*;
	
	
	public class PlainButton extends MovieClip {
		
		private var maxWidth:Number = 0;
		private var maxHeight:Number = 0;
		private var bg:MovieClip;
		private var buttonText:String="";
		private var buttonLabel:TextField;
		
		
		public function PlainButton(maxWidth:Number, maxHeight:Number, buttonText:String=""){
			//trace("PlainButton instanciated");
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			this.buttonText = buttonText;
			this.buttonMode = true;
			if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
		}
		
		function initListener(e:Event):void {
			//trace("PlainButton.initListener() called");
			removeEventListener(Event.ADDED_TO_STAGE, initListener);
			
			//Listen
			Broadcaster.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			Broadcaster.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			
			//Create the background
			bg = new MovieClip();
			addChild(bg);
			
			//buttonLabel
			buttonLabel = TextUtil.getTextField(TextUtil.getHelveticaRounded(13, 0xFFFFFF, true), maxWidth-10, buttonText, TextFieldAutoSize.CENTER);
			buttonLabel.filters = Shadow.getDropShadowFilterArray(0x000000);
			buttonLabel.x = ((maxWidth-10-buttonLabel.textWidth)/2);
			buttonLabel.y = 2;
			buttonLabel.mouseEnabled = false;
			addChild(buttonLabel);
			
			//Initial Resize
			resize(maxWidth, maxHeight);
			makeCold();
		}
		
		
		//Resize
		public function resize(maxWidth:Number, maxHeight:Number):void {
			//trace("NavButton -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
		}
		
		private function onMouseOver(event:MouseEvent):void{
			makeHot();
		}
		private function onMouseOut(event:MouseEvent):void{
			makeCold();
		}
		
		
		public function makeHot():void{
			//trace("NavButton.makeHot()");
			bg.graphics.clear();
			bg.graphics.beginFill(0xFFFFFF);
			bg.graphics.drawRoundRect(0,0, maxWidth, maxHeight, 15);
			bg.graphics.endFill();
			bg.filters = Shadow.getDropShadowFilterArray(0x000000);
			bg.alpha = .35;
		}
		
		public function makeCold():void{
			//trace("NavButton.makeCold()");
			bg.graphics.clear();
			bg.graphics.beginFill(0xFFFFFF);
			bg.graphics.drawRoundRect(0,0, maxWidth, maxHeight, 30);
			bg.graphics.endFill();
			bg.filters = Shadow.getDropShadowFilterArray(0x000000);
			bg.alpha = .15;
		}



	}
	
}