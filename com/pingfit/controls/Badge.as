package com.pingfit.controls {
	
	import flash.display.MovieClip;
	import com.pingfit.format.TextUtil;
	import flash.text.*;
	import flash.filters.DropShadowFilter;
	import com.pingfit.format.Shadow;
	import gs.TweenLite;
	import gs.easing.*;
	import gs.TweenGroup;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Badge extends MovieClip{
		

		private var topText:TextField;
		private var middleText:TextField;
		private var bgTimer:Timer;
		public var sunburst;

		public function Badge() { 
			

			bgTimer = new Timer(8000);
			bgTimer.addEventListener(TimerEvent.TIMER, bgTimerTick);
			bgTimer.start();
			

			var topFormat = TextUtil.getHelveticaRounded(15, 0xFFFFFF, true);
			topFormat.align = "center";
			topText = TextUtil.getTextField(topFormat, this.width, "exercise");
			topText.filters = Shadow.getDropShadowFilterArray(0x000000);
			topText.x = (-(this.width/2)) + 4;
			topText.y = -((this.height/2)-28);
			addChild(topText);
			
			var middleFormat = TextUtil.getHelveticaRounded(40, 0xFFFFFF, true);
			middleFormat.align = "center"; 
			middleText = TextUtil.getTextField(middleFormat, this.width, "now!");
			middleText.filters = Shadow.getDropShadowFilterArray(0x000000, 8, 6, .8);
			middleText.x = -(this.width/2);
			middleText.y = -38;
			addChild(middleText);

		
		
		}
		
		private function bgTimerTick(e:TimerEvent):void{
			var range = 60;
			var amtToRotate = range*Math.random();
			var myGroup:TweenGroup = new TweenGroup();
			myGroup.align = TweenGroup.ALIGN_SEQUENCE;
			myGroup.push(TweenLite.to(sunburst, 1, {rotation:amtToRotate, ease:Elastic.easeOut}));
			myGroup.push(TweenLite.to(sunburst, 3, {rotation:0, ease:Elastic.easeIn}));
		}
	

	}
	
}