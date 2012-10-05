package com.pingfit.controls {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import com.pingfit.events.*;
	
	public class BackgroundColorButtons extends MovieClip {
		
		private var maxWidth:Number = 200;
		private var maxHeight:Number = 400;
		
		private var squareBlue:MovieClip;
		private var squareGrey:MovieClip;
		private var squarePink:MovieClip;
		private var squareGreen:MovieClip;
		private var squareYellow:MovieClip;

		public function BackgroundColorButtons(maxWidth:Number, maxHeight:Number) { 
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;

			squareBlue = new MovieClip();
			squareBlue.addEventListener(MouseEvent.MOUSE_UP, changeColorToBlue);	
			squareBlue.alpha = 1;
			addChild(squareBlue);
			
			squareGrey = new MovieClip();
			squareGrey.addEventListener(MouseEvent.MOUSE_UP, changeColorToGrey);	
			squareGrey.alpha = 1;
			addChild(squareGrey);
			
			squarePink = new MovieClip();
			squarePink.addEventListener(MouseEvent.MOUSE_UP, changeColorToPink);	
			squarePink.alpha = 1;
			addChild(squarePink);
			
			squareGreen = new MovieClip();
			squareGreen.addEventListener(MouseEvent.MOUSE_UP, changeColorToGreen);	
			squareGreen.alpha = 1;
			addChild(squareGreen);
			
			squareYellow = new MovieClip();
			squareYellow.addEventListener(MouseEvent.MOUSE_UP, changeColorToYellow);	
			squareYellow.alpha = 1;
			addChild(squareYellow);
			
			resize(maxWidth, maxHeight);
		
		}
		
		public function resize (maxWidth:Number, maxHeight:Number):void {
			trace("Background -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			
			var squaresY = 0;
			var squaresSpacing = 3;
			var squaresWidth = 10;
			
			squareBlue.graphics.clear();
			squareBlue.graphics.beginFill(0x0000FF);
			squareBlue.graphics.drawRoundRect(0,0, squaresWidth, squaresWidth, 3);
			squareBlue.graphics.endFill();
			squareBlue.x = 0;
			squareBlue.y = squaresY;
			
			squareGrey.graphics.clear();
			squareGrey.graphics.beginFill(0x333333);
			squareGrey.graphics.drawRoundRect(0,0, squaresWidth, squaresWidth, 3);
			squareGrey.graphics.endFill();
			squareGrey.x = squareBlue.x + squaresWidth + squaresSpacing;
			squareGrey.y = squaresY;
			
			squareYellow.graphics.clear();
			squareYellow.graphics.beginFill(0xFFCC00);
			squareYellow.graphics.drawRoundRect(0,0, squaresWidth, squaresWidth, 3);
			squareYellow.graphics.endFill();
			squareYellow.x = squareGrey.x + squaresWidth + squaresSpacing;
			squareYellow.y = squaresY;
			
			squareGreen.graphics.clear();
			squareGreen.graphics.beginFill(0x827B00);
			squareGreen.graphics.drawRoundRect(0,0, squaresWidth, squaresWidth, 3);
			squareGreen.graphics.endFill();
			squareGreen.x = squareYellow.x + squaresWidth + squaresSpacing;
			squareGreen.y = squaresY;
			
			squarePink.graphics.clear();
			squarePink.graphics.beginFill(0xEC008C);
			squarePink.graphics.drawRoundRect(0,0, squaresWidth, squaresWidth, 3);
			squarePink.graphics.endFill();
			squarePink.x = squareGreen.x + squaresWidth + squaresSpacing;
			squarePink.y = squaresY;
			
		}
		
		private function changeColorToBlue(e:MouseEvent){ Broadcaster.dispatchEvent(new ChangeBgColor(Background.BGCOLOR_BLUE)); }
		private function changeColorToGrey(e:MouseEvent){ Broadcaster.dispatchEvent(new ChangeBgColor(Background.BGCOLOR_GREY));}
		private function changeColorToPink(e:MouseEvent){ Broadcaster.dispatchEvent(new ChangeBgColor(Background.BGCOLOR_PINK)); }
		private function changeColorToGreen(e:MouseEvent){ Broadcaster.dispatchEvent(new ChangeBgColor(Background.BGCOLOR_GREEN)); }
		private function changeColorToYellow(e:MouseEvent){ Broadcaster.dispatchEvent(new ChangeBgColor(Background.BGCOLOR_YELLOW)); }

	}
	
}