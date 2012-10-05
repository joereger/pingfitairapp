package com.pingfit.icon {
	
	import flash.display.Sprite;
	import flash.display.BitmapData;
	
	public class PieChartProgress extends Sprite {

		private var radius:Number = 75;
		private var totalProgress:Number = 100;
		private var currentProgress:Number = 0;
		private var step:Number = 1;
		private var circle_pi:Number = Math.PI/180;
		
		public function PieChartProgress(currentProgress:Number, totalProgress:Number, radius:Number) { 
			setEverything(currentProgress, totalProgress, radius);
		}
		
		public function setEverything(currentProgress:Number, totalProgress:Number, radius:Number) { 
			this.radius = radius;
			this.currentProgress = currentProgress;
			this.totalProgress= totalProgress;
			redrawPie();
		}
		
		public function setRadius(radius:Number):void{
			this.radius = radius;
			redrawPie();
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
			//trace("redrawPie() called");
			var degree:Number = 0;
			var ratio:Number = ((totalProgress-currentProgress)/totalProgress)*360;
			//trace("ratio="+ratio);
			if (ratio>360){
				ratio = 360;
			}
			with (graphics) {
				clear();
				lineStyle(0, 0xFFFFFF, 0);
				beginFill(0xFFFFFF, 100);
				lineTo(0, -radius);
				//lineTo(radius, radius);
				while (degree-step>=(-ratio)) {
						degree -= step;
						var xCoord:Number = -radius*Math.sin(degree*circle_pi);
						var yCoord:Number = -radius*Math.cos(degree*circle_pi);
						//var xCoord:Number = radius + (-radius*Math.sin(degree*circle_pi));
						//var yCoord:Number = radius + (-radius*Math.cos(degree*circle_pi));
						//trace("degree="+degree+" xCoord="+xCoord+" yCoord="+yCoord);
						lineTo(xCoord, yCoord);
				}
				endFill();
			}
		}
		
	
		

		public function getBitmapData():BitmapData{
			//trace("getBitmapData() called");
			var img:BitmapData = new BitmapData(this.width, this.height, true , 0x00000000);
			img.draw(this);
			return img;
		}
		

	}
	
}

