package com.pingfit.timerpanel {
	
	import flash.display.MovieClip;
	import com.pingfit.format.TextUtil;
	import flash.text.TextField;
	import com.pingfit.format.Shadow;
	import gs.TweenLite;
	import gs.TweenGroup;
	
	public class TimeRemainingText extends MovieClip {
		
		private var secondsRemaining:Number;
		private var countdownDisplay:TextField;
		private var hrsLabel:TextField;
		private var minLabel:TextField;
		private var secLabel:TextField;

		public function TimeRemainingText(secondsRemaining:Number) {
			trace("TimeRemainingText instanciated");
			this.secondsRemaining = secondsRemaining;
			var labelsX = 0;
			var labelsY = 30;
			
			hrsLabel = TextUtil.getTextField(TextUtil.getHelveticaRounded(9, 0xFFFFFF, true), 40, "hrs");
			hrsLabel.x = labelsX + 3;
			hrsLabel.y = labelsY;
			hrsLabel.alpha = 1;
			addChild(hrsLabel);
			
			minLabel = TextUtil.getTextField(TextUtil.getHelveticaRounded(9, 0xFFFFFF, true), 40, "min");
			minLabel.x = labelsX + 40;
			minLabel.y = labelsY;
			minLabel.alpha = 1;
			addChild(minLabel);
			
			secLabel = TextUtil.getTextField(TextUtil.getHelveticaRounded(9, 0xFFFFFF, true), 40, "sec");
			secLabel.x = labelsX + 75;
			secLabel.y = labelsY;
			secLabel.alpha = 1;
			addChild(secLabel);
			
			countdownDisplay = TextUtil.getTextField(TextUtil.getHelveticaRounded(30, 0xFFFFFF, true), 180, "");
			countdownDisplay.filters = Shadow.getDropShadowFilterArray(0x000000);
			countdownDisplay.alpha = 1;
			addChild(countdownDisplay);
			
			redrawIt();
		}
		
		public function updateSecondsRemaining(secondsRemaining:Number):void{
			this.secondsRemaining = secondsRemaining;
			redrawIt();
		}
		
		private function redrawIt():void{
			var displ:Number = secondsRemaining;
			if (displ<=0){
				displ = 0;
			}
			countdownDisplay.htmlText = timeToString(displ*1000);
			var myGroup:TweenGroup = new TweenGroup();
			if (displ==0 && countdownDisplay.alpha==1){
				myGroup.align = TweenGroup.ALIGN_START;
				myGroup.push(TweenLite.to(countdownDisplay, 3, {alpha:.25}));
				myGroup.push(TweenLite.to(hrsLabel, 3, {alpha:.25}));
				myGroup.push(TweenLite.to(minLabel, 3, {alpha:.25}));
				myGroup.push(TweenLite.to(secLabel, 3, {alpha:.25}));
			} else if (displ>0 && countdownDisplay.alpha<=.25){
				myGroup.align = TweenGroup.ALIGN_START;
				myGroup.push(TweenLite.to(countdownDisplay, 3, {alpha:1}));
				myGroup.push(TweenLite.to(hrsLabel, 3, {alpha:1}));
				myGroup.push(TweenLite.to(minLabel, 3, {alpha:1}));
				myGroup.push(TweenLite.to(secLabel, 3, {alpha:1}));
			} else {
				countdownDisplay.alpha = .99;
			}
		}
		
		private function timeToString(time_to_convert:Number) {
			var elapsed_hours:Number = Math.floor(time_to_convert/3600000);
			var remaining:Number = time_to_convert-(elapsed_hours*3600000);
			var elapsed_minutes:Number = Math.floor(remaining/60000);
			remaining = remaining-(elapsed_minutes*60000);
			var elapsed_seconds:Number = Math.floor(remaining/1000);
			remaining = remaining-(elapsed_seconds*1000);
			var elapsed_fs:Number = Math.floor(remaining/10);
			var hours:String;
			var minutes:String;
			var seconds:String;
			var hundredths:String;
			if (elapsed_hours<10) {
				hours = "0"+elapsed_hours.toString();
			} else {
				hours = elapsed_hours.toString();
			}
			if (elapsed_minutes<10) {
				minutes = "0"+elapsed_minutes.toString();
			} else {
				minutes = elapsed_minutes.toString();
			}
			if (elapsed_seconds<10) {
				seconds = "0"+elapsed_seconds.toString();
			} else {
				seconds = elapsed_seconds.toString();
			}
			if (elapsed_fs<10) {
				hundredths = "0"+elapsed_fs.toString();
			} else {
				hundredths = elapsed_fs.toString();
			}
			//return hours+":"+minutes+":"+seconds+":"+hundredths;
			return hours+":"+minutes+":"+seconds;
		}

	

	}
	
}