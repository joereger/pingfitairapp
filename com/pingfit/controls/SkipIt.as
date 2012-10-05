package com.pingfit.controls {
	
	import flash.display.MovieClip;
	import com.pingfit.format.TextUtil;
	import flash.text.*;
	import flash.filters.DropShadowFilter;
	import com.pingfit.format.Shadow;
	
	public class SkipIt extends MovieClip{

		private var doTxt:TextField;

		public function SkipIt() { 
			buttonMode = true;
			doTxt = TextUtil.getTextField(TextUtil.getHelveticaRounded(15, 0xE6E6E6, true), 125, "I'll Skip It");
			doTxt.x = 0;
			doTxt.y = 0;
			addChild(doTxt);
		}
	

	}
	
}