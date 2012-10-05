package com.pingfit.controls {
	
	import flash.display.MovieClip;
	import com.pingfit.format.TextUtil;
	import flash.text.*;
	import flash.filters.DropShadowFilter;
	import com.pingfit.format.Shadow;
	
	public class DoneButton extends MovieClip{
		
		private var txt:String = "";
		private var displayDoNow:Boolean = false;
		private var doTxt:TextField;

		public function DoneButton(txt:String="", displayTxt:Boolean=false) { 
			this.txt = txt;
			this.displayDoNow = displayTxt;
			buttonMode = true;
			if (txt.length>0 && displayTxt){
				doTxt = TextUtil.getTextField(TextUtil.getHelveticaRounded(28, 0xE6E6E6, true), this.width, txt);
				doTxt.x = 50;
				doTxt.y = 0;
				addChild(doTxt);
			}
		
		}
	

	}
	
}