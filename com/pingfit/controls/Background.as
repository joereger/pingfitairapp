package com.pingfit.controls {
	
	import flash.display.MovieClip;
	import com.pingfit.format.Shadow;
	import flash.events.MouseEvent;
	import com.pingfit.prefs.CPreferencesManager;
	
	public class Background extends MovieClip {
		
		public static var BGCOLOR_BLUE:int = 1;
		public static var BGCOLOR_GREY:int = 2;
		public static var BGCOLOR_PINK:int = 3;
		public static var BGCOLOR_GREEN:int = 4;
		public static var BGCOLOR_YELLOW:int = 5;
		
		private var maxWidth:Number = 200;
		private var maxHeight:Number = 400;
		private var bg:MovieClip;
		private var bgBar:MovieClip;
		private var bgMask:MovieClip;
		private var bgMask2:MovieClip;
		private var bgBottom:BackgroundBottom;
		private var background_color:int = BGCOLOR_BLUE;
		


		public function Background(maxWidth:Number, maxHeight:Number, background_color:int=2)  { 
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			this.background_color = background_color;
		
			//Create the background
			bg = new MovieClip();	
			addChild(bg);

			//Create the background mask
			//bgMask = new MovieClip();
			//addChild(bgMask);
			
			//Create the background
			//bgBar = new MovieClip();
			//bgBar.mask = bgMask;
			//addChild(bgBar);
			
			//Create the background mask
			//bgMask2 = new MovieClip();
			//addChild(bgMask2);
			
			//Bottom of window
			//bgBottom = new BackgroundBottom();
			//bgBottom.mask = bgMask2;
			//addChild(bgBottom);
		
			
			resize(maxWidth, maxHeight);
		}
		
		public function setColor(background_color:int=2):void{
			this.background_color = background_color;
			CPreferencesManager.setInt("pingfit.bgcolor", background_color);
			resize(maxWidth, maxHeight);
		}
		
		public function resize (maxWidth:Number, maxHeight:Number):void {
			trace("Background -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			
			var bgcolor:int = 0x333333;
			var bgbarcolor:int = 0x534741;
			if (background_color == BGCOLOR_BLUE){
				bgcolor = 0x238BAE;
				bgbarcolor = 0x238BAE;
			} else if (background_color == BGCOLOR_GREY){
				bgcolor = 0x333333;
				bgbarcolor = 0x534741;
			} else if (background_color == BGCOLOR_PINK){
				bgcolor = 0xf06eaa;
				bgbarcolor = 0xec008c;
			} else if (background_color == BGCOLOR_GREEN){
				bgcolor = 0x00ff00;
				bgbarcolor = 0x406618;
			} else if (background_color == BGCOLOR_YELLOW){
				bgcolor = 0xfff200;
				bgbarcolor = 0xffcc00;
			}
			
			bg.graphics.clear();
			bg.graphics.beginFill(bgcolor);
			bg.graphics.drawRoundRect(0,0, maxWidth-8, maxHeight-8, 30);
			bg.graphics.endFill();
			bg.filters = Shadow.getDropShadowFilterArray(0x000000, 4, 3, .4);
			
			//bgMask.graphics.clear();
			//bgMask.graphics.beginFill(bgcolor);
			//bgMask.graphics.drawRoundRect(0,0, maxWidth-8, maxHeight-8, 30);
			//bgMask.graphics.endFill();
			
			
			//bgBar.graphics.clear();
			//bgBar.graphics.beginFill(bgbarcolor);
			//bgBar.graphics.drawRect(0,0, maxWidth, 50);
			//bgBar.graphics.endFill();
			//bgBar.x = 0;
			//bgBar.y = maxHeight - 50; 
			
			//bgMask2.graphics.clear();
			//bgMask2.graphics.beginFill(bgcolor);
			//bgMask2.graphics.drawRoundRect(0,0, maxWidth-8, maxHeight-8, 30);
			//bgMask2.graphics.endFill();
			
			//bgBottom.width = maxWidth;
			//bgBottom.x = maxWidth;
			//bgBottom.y = maxHeight-8;
			
			
		}
		
		

	}
	
}