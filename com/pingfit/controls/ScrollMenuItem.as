package com.pingfit.controls {
	
	import flash.display.MovieClip;
	import com.pingfit.format.TextUtil;
	import flash.text.TextField;
	import flash.events.*;
	
	public class ScrollMenuItem extends MovieClip {
		
		private var maxWidth:Number = 200;
		private var maxHeight:Number = 400;
		
		private var square:MovieClip;
		private var title:TextField;
		private var description:TextField;
		private var uniqueid:String;
		

		public function ScrollMenuItem(maxWidth:Number, maxHeight:Number, titleTxt:String, descriptionTxt:String, uniqueid:String) { 
			//trace("ScrollMenuItem instanciated -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			this.uniqueid = uniqueid;

			square = new MovieClip();
			addChild(square);
			
			title = TextUtil.getTextField(TextUtil.getHelveticaRounded(13, 0xE6E6E6, true), maxWidth-20, titleTxt);
			addChild(title);
			
			description = TextUtil.getTextField(TextUtil.getHelveticaRounded(9, 0xE6E6E6, true), maxWidth-20, descriptionTxt);	
			addChild(description);
			
			resize(maxWidth, maxHeight);
		}
		
		public function resize (maxWidth:Number, maxHeight:Number):void {
			//trace("ScrollMenuItem -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			
			title.x = 10;
			title.y = 10;
			title.width = maxWidth - 20;
			
			description.x  = 10;
			description.y = title.textHeight + 6;
			description.width = maxWidth - 20;
			
			var squareHeight:Number = description.y + description.textHeight + 10;
			if (squareHeight<maxHeight){
				squareHeight = maxHeight;
			}
			
			square.graphics.clear();
			square.graphics.beginFill(0x000000);
			square.graphics.drawRoundRect(0,0, maxWidth, squareHeight, 5);
			square.graphics.endFill();
			square.alpha = .20;
		}
		
		public function getTitle():String{
			return title.text;
		}
		
		public function getUniqueid():String{
			return uniqueid;
		}
		

	}
	
}