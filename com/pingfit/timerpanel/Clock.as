package com.pingfit.timerpanel {
	
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import com.pingfit.icon.PieChartProgress;
	import com.pingfit.controls.Badge;
	
	public class Clock extends Sprite {
		
		private var pieChartProgress:PieChartProgress;
		private var radius:Number = 75;
		private var totalProgress:Number = 100;
		private var currentProgress:Number = 0;
		private var rim:Sprite = new Sprite();
		private var buttonYellow:ButtonYellow;
		
		public function Clock(currentProgress:Number, totalProgress:Number, radius:Number) { 
			this.radius = radius;
			this.currentProgress = currentProgress;
			this.totalProgress = totalProgress;
			
			with (rim.graphics){
				beginFill(0x000000);
				drawCircle(radius,radius,radius);
				endFill();
			}
			addChild(rim);
			
			
			
			//pieChartProgress = new PieChartProgress(currentProgress, totalProgress, radius-(radius*.1));
			pieChartProgress = new PieChartProgress(currentProgress, totalProgress, radius);
			pieChartProgress.x = radius;
			pieChartProgress.y = radius;
			addChild(pieChartProgress);

			
			buttonYellow = new ButtonYellow();
			buttonYellow.x = radius;
			buttonYellow.y = radius;
			buttonYellow.alpha = 1;
			buttonYellow.mask = pieChartProgress;
			addChild(buttonYellow);
			
			
		}
		
		
		
		public function setCurrentProgress(currentProgress:Number):void{
			this.currentProgress = currentProgress;
			redrawPie();
		}
		
		public function setTotalProgress(currentProgress:Number, totalProgress:Number):void{
			this.currentProgress = currentProgress;
			this.totalProgress= totalProgress;
			redrawPie();
		}
		
		private function redrawPie():void{
			//pieChartProgress.setEverything(currentProgress, totalProgress, radius-(radius*.1));
			pieChartProgress.setEverything(currentProgress, totalProgress, radius);
		}
		
		public function getBitmapData():BitmapData{
			//trace("PieChartIcon.getBitmapData() called");
			var img:BitmapData = new BitmapData(this.width, this.height, true , 0x00000000);
			img.draw(this);
			return img;
		}
	
		
	}
	
}