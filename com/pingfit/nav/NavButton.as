package com.pingfit.nav {
	
	
	import flash.display.MovieClip;
	import com.pingfit.controls.Background;
	import com.pingfit.events.*;
	import com.pingfit.format.TextUtil;
	import com.pingfit.format.Shadow;
	import flash.text.*;
	import flash.events.Event;
	
	
	public class NavButton extends MovieClip {
		
		private var maxWidth:Number = 0;
		private var maxHeight:Number = 0;
		private var bg:MovieClip;
		private var navPanelType:String="";
		private var buttonText:String="";
		private var buttonLabel:TextField;
		
		
		public function NavButton(maxWidth:Number, maxHeight:Number, navPanelType:String="", buttonText:String=""){
			//trace("NavButton instanciated");
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			this.navPanelType = navPanelType;
			this.buttonText = buttonText;
			this.buttonMode = true;
			if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
		}
		
		function initListener(e:Event):void {
			//trace("NavButton.initListener() called");
			removeEventListener(Event.ADDED_TO_STAGE, initListener);
			
			//Listen
			Broadcaster.addEventListener(TurnOnNavPanel.TYPE, onTurnOnNavPanel);

			
			//Create the background
			bg = new MovieClip();
			addChild(bg);
			
			//buttonLabel
			buttonLabel = TextUtil.getTextField(TextUtil.getHelveticaRounded(13, 0xFFFFFF, true), maxWidth-10, buttonText, TextFieldAutoSize.CENTER);
			buttonLabel.filters = Shadow.getDropShadowFilterArray(0x000000);
			buttonLabel.x = ((maxWidth-10-buttonLabel.textWidth)/2);
			buttonLabel.y = 5;
			buttonLabel.mouseEnabled = false;
			addChild(buttonLabel);
			
			//Initial Resize
			resize(maxWidth, maxHeight);
			makeCold();
		}
		
		//Turn On/Off
		private function onTurnOnNavPanel(e:TurnOnNavPanel):void{
			//trace("NavButton.onTurnOnNavPanel() e.navPanelType="+e.navPanelType+" navPanelType="+navPanelType);
			if (e.navPanelType==navPanelType){
				makeHot();
			} else {
				makeCold();
			}
		}
		
		//Resize
		public function resize(maxWidth:Number, maxHeight:Number):void {
			//trace("NavButton -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
		}
		
		
		public function makeHot():void{
			//trace("NavButton.makeHot()");
			bg.graphics.clear();
			bg.graphics.beginFill(0xFFFFFF);
			bg.graphics.drawRoundRect(0,0, maxWidth, maxHeight, 30);
			bg.graphics.endFill();
			bg.alpha = .35;
		}
		
		public function makeCold():void{
			//trace("NavButton.makeCold()");
			bg.graphics.clear();
			bg.graphics.beginFill(0xFFFFFF);
			bg.graphics.drawRoundRect(0,0, maxWidth, maxHeight, 30);
			bg.graphics.endFill();
			bg.alpha = .15;
		}
		
		public function getNavPanelType():String{
			return navPanelType;
		}


	}
	
}