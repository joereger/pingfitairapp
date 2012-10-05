package com.pingfit.timerpanel
{
	
	import flash.display.MovieClip;
	import fl.containers.ScrollPane;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.text.*;
	import flash.desktop.DockIcon;
	import flash.desktop.NativeApplication;
	import flash.desktop.NotificationType;
	import flash.desktop.SystemTrayIcon;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.events.InvokeEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.html.HTMLLoader;
	import flash.utils.Timer;
	import com.pingfit.xml.*;
	import com.pingfit.timerpanel.Clock;
	import flash.display.*;
	import flash.display.SimpleButton;
	import fl.controls.Slider;
	import fl.controls.SliderDirection;
	import fl.controls.ComboBox;
	import fl.controls.CheckBox;
	import fl.events.SliderEvent;
	import com.pingfit.format.TextUtil;
	import gs.TweenLite;
	import gs.easing.*;
	import gs.TweenGroup;
	import com.pingfit.controls.Badge;
	import com.pingfit.timerpanel.TimeRemainingText;
	import com.pingfit.data.static.NextWorkoutTimer;
	import com.pingfit.data.static.NextExercises;
	import com.pingfit.data.static.CurrentUser;
	import com.pingfit.timing.*;
	import com.pingfit.events.*;
	import com.pingfit.format.TextUtil;
	import flash.text.TextField;
	import com.pingfit.format.Shadow;
	import com.pingfit.data.static.AlarmStatus;



	public class TimerPanel extends MovieClip {
		
		private var maxWidth:Number = 200;
		private var maxHeight:Number = 400;
		private var clock:Clock;
		private var bgTimer:Timer;
		private var badge:Badge;
		private var radius:Number = 75;
		private var timeRemainingText:TimeRemainingText;
		private var timeUntilNextLabel:TextField;
		private var timeUntilNext:TimeRemainingText;
		private var badgeRim:Sprite = new Sprite();
		
	    
		
		public function TimerPanel(maxWidth:Number, maxHeight:Number){
			trace("TimerPanel instanciated");
			if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			
			//BgTimer controls things every second
			bgTimer = new Timer(1000);
			bgTimer.addEventListener(TimerEvent.TIMER, bgTimerTick);
			bgTimer.start();
		}
		
		function initListener (e:Event):void {
			trace("TimerPanel.initListener() called");
			removeEventListener(Event.ADDED_TO_STAGE, initListener);
			
			//Init timer
			//NextWorkoutTimer.resetWithNextExercisesAndUser();
			
			//Listen
			Broadcaster.addEventListener(DoExercise.TYPE, onDoExercise);
			Broadcaster.addEventListener(SkipExercise.TYPE, onSkipExercise);
			Broadcaster.addEventListener(EnterRoom.TYPE, onEnterRoom);
			Broadcaster.addEventListener(LeaveRoom.TYPE, onLeaveRoom);
			Broadcaster.addEventListener(PEvent.SWITCHTOWORKOUTALONE, onSwitchToWorkoutAlone);
			Broadcaster.addEventListener(PEvent.SWITCHTOWORKOUTGROUP, onSwitchToWorkoutGroup);
			Broadcaster.addEventListener(PEvent.CHANGEEXERCISELIST, onChangeExerciseList);
			Broadcaster.addEventListener(PEvent.CHANGEEXERCISEEVERYXMINUTES, onChangeExerciseEveryXMinutes);
			Broadcaster.addEventListener(CountdownSecondsTimerEvent.ALARM, onAlarm);
			
			var currentProgress:Number = NextWorkoutTimer.getTimer().getSecondsTotal() - NextWorkoutTimer.getTimer().getSecondsRemaining();
			var totalProgress:Number = NextWorkoutTimer.getTimer().getSecondsTotal();
			clock = new Clock(currentProgress, totalProgress, radius);
			clock.x = 20;
			clock.y = 20;
			addChild(clock);
			
			with (badgeRim.graphics){
				beginFill(0x000000);
				drawCircle(radius,radius,radius);
				endFill();
			}
			badgeRim.x = -((radius*2) + 10);
			badgeRim.y = clock.y;
			badgeRim.alpha = 1;
			addChild(badgeRim);
			
			badge = new Badge();
			badge.x = -(64 + 10);
			badge.y = clock.y + radius;
			badge.alpha = 1;
			addChild(badge);
			
			
			//Time remaining text
			if (NextWorkoutTimer.getTimer()!=null){
				timeRemainingText = new TimeRemainingText(NextWorkoutTimer.getTimer().getSecondsRemaining());
			} else {
				timeRemainingText = new TimeRemainingText(0);
			}
			timeRemainingText.x = 43;
			timeRemainingText.y = clock.y + clock.height + 10;
			addChild(timeRemainingText);
			
			//Time until next text
			timeUntilNextLabel = TextUtil.getTextField(TextUtil.getHelveticaRounded(9, 0xFFFFFF, true), 120, "next exercise in:");
			timeUntilNextLabel.filters = Shadow.getDropShadowFilterArray(0x000000);
			timeUntilNextLabel.x = 68;
			timeUntilNextLabel.y = clock.y + radius + 15;
			timeUntilNextLabel.alpha = .5;
			timeUntilNextLabel.visible = false;
			addChild(timeUntilNextLabel);
			timeUntilNext = new TimeRemainingText(0);
			timeUntilNext.x = 71;
			timeUntilNext.y = clock.y + radius + 25;
			timeUntilNext.scaleX = .5;
			timeUntilNext.scaleY = .5;
			timeUntilNext.alpha = .5;
			timeUntilNext.visible = false;
			addChild(timeUntilNext);
			
			
			
			resize(maxWidth, maxHeight);
		}
		
		private function bgTimerTick(e:TimerEvent):void{
			//If the alarm's been rung, nothing to do but make sure it's at zero!
			if (AlarmStatus.getIsAlarmRinging()){
				//trace("TimerPanel.bgTimerTick() alarmIsRinging==true");
				timeRemainingText.updateSecondsRemaining(0);
				if (!timeUntilNextLabel.visible){ timeUntilNextLabel.visible = true; }
				if (!timeUntilNext.visible){ timeUntilNext.visible = true; }
				timeUntilNext.updateSecondsRemaining(NextWorkoutTimer.getTimer().getSecondsRemaining());
				return;
			} else {
				if (timeUntilNext.visible){ timeUntilNext.visible = false; }
				if (timeUntilNextLabel.visible){ timeUntilNextLabel.visible = false; }
			}
			//Redraw the timer clock
			if (NextWorkoutTimer.getTimer()!=null){
				var currentProgress:Number = NextWorkoutTimer.getTimer().getSecondsTotal() - NextWorkoutTimer.getTimer().getSecondsRemaining();
				var totalProgress:Number = NextWorkoutTimer.getTimer().getSecondsTotal();
				//trace("TimerPanel.bgTimerTick() currentProgress="+currentProgress+" totalProgress="+totalProgress+" NextWorkoutTimer.getTimer().getSecondsRemaining()="+NextWorkoutTimer.getTimer().getSecondsRemaining());
				clock.setTotalProgress(currentProgress, totalProgress);
				//If it's time, pop the exercise panel onto the stage
				if (NextWorkoutTimer.getTimer().getSecondsRemaining()<=0){
					//shake();
					clock.setTotalProgress(100, 100);
				}
				//Update timerText
				timeRemainingText.updateSecondsRemaining(NextWorkoutTimer.getTimer().getSecondsRemaining());
			} else {
				trace("TimerPanel.bgTimerTick() NextWorkoutTimer.getTimer()==null");
				clock.setTotalProgress(0, 100);
				timeRemainingText.updateSecondsRemaining(0);
			}
			//See if we need to display the current exercise
			if (PingFit.getJustStartedNeedToShowExerciseImmediately()){
				PingFit.setJustStartedNeedToShowExerciseImmediately(false)
				Broadcaster.dispatchEvent(new PEvent(PEvent.DISPLAYCURRENTEXERCISE));
			}
		}
		
		//onDoExercise
		public function onDoExercise(e:DoExercise){
			trace("TimerPanel.onDoExercise()");
			unShake();
		}
		
		public function onSkipExercise(e:SkipExercise){
			trace("TimerPanel.onSkipExercise()");
			unShake();
		}
		
		//onAlarm
		public function onAlarm(e:CountdownSecondsTimerEvent){
			trace("TimerPanel.onAlarm()");
			if (e.identifier=="nextWorkoutTimer"){
				trace("TimerPanel.onAlarm() it's a nextWorkoutTimer event");
				NextExercises.advanceOneExercise();
				NextWorkoutTimer.resetWithNextExercisesAndUser();
				shake();
				Broadcaster.dispatchEvent(new PEvent(PEvent.EXERCISEALARM));
				Broadcaster.dispatchEvent(new PEvent(PEvent.DISPLAYCURRENTEXERCISE));
			}
		}
		
		//onEnterRoom
		public function onEnterRoom(e:EnterRoom){
			trace("TimerPanel.onEnterRoom()");
			//NextWorkoutTimer.resetWithNextExercisesAndUser();
			unShake();
		}

		//onLeaveRoom
		public function onLeaveRoom(e:LeaveRoom){
			trace("TimerPanel.onLeaveRoom()");
			NextWorkoutTimer.getTimer().pause();
		}
		
		//onSwitchToWorkoutAlone
		public function onSwitchToWorkoutAlone(e:PEvent){
			trace("TimerPanel.onSwitchToWorkoutAlone()");
			NextWorkoutTimer.resetWithNextExercisesAndUser();
			unShake();
		}

		//onSwitchToWorkoutGroup
		public function onSwitchToWorkoutGroup(e:PEvent){
			trace("TimerPanel.onSwitchToWorkoutGroup()");
			NextWorkoutTimer.resetWithNextExercisesAndUser();
			unShake();
		}
		
		//onChangeExerciseList
		public function onChangeExerciseList(e:PEvent){
			trace("TimerPanel.onChangeExerciseList()");
			NextWorkoutTimer.resetWithNextExercisesAndUser();
			unShake();
		}
		
		//onChangeExerciseEveryXMinutes
		public function onChangeExerciseEveryXMinutes(e:PEvent){
			trace("TimerPanel.onChangeExerciseEveryXMinutes()");
			NextWorkoutTimer.resetWithNextExercisesAndUser();
			unShake();
		}
		
		
		
		public function shake():void{
			trace("TimerPanel.shake()");
			if (!AlarmStatus.getIsAlarmRinging()){
				AlarmStatus.setIsAlarmRinging(true);
				var endXForClock = (-radius*2)-10;
				var endXForBadge = clock.x+radius;
				var endXForRim = clock.x;
				var myGroup:TweenGroup = new TweenGroup();
				myGroup.align = TweenGroup.ALIGN_START;
				myGroup.push(TweenLite.to(clock, 1, {x:endXForClock, ease:Elastic.easeOut}));
				myGroup.push(TweenLite.to(badge, 1.75, {x:endXForBadge, ease:Elastic.easeOut}));
				myGroup.push(TweenLite.to(badgeRim, 1.25, {x:endXForRim, ease:Elastic.easeOut}));
			}
		}
		
		public function unShake():void{
			trace("TimerPanel.unShake()");
			if (AlarmStatus.getIsAlarmRinging()) {
				AlarmStatus.setIsAlarmRinging(false);
				var endXForClock = 20;
				var endXForBadge = (-radius*2)-10;
				var endXForRim = -((radius*2) + 10);
				var myGroup:TweenGroup = new TweenGroup();
				myGroup.align = TweenGroup.ALIGN_START;
				myGroup.push(TweenLite.to(clock, 1, {x:endXForClock, ease:Elastic.easeOut}));
				myGroup.push(TweenLite.to(badge, 1.75, {x:endXForBadge, ease:Elastic.easeOut}));
				myGroup.push(TweenLite.to(badgeRim, 1.25, {x:endXForRim, ease:Elastic.easeOut}));
			}
		}
		
		
		public function resize (maxWidth:Number, maxHeight:Number):void {
			trace("TimerPanel -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
		}
		

		
	}

	
	
}