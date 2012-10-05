package com.pingfit.nav {
	

	import com.pingfit.events.*;
	import flash.display.MovieClip;
	import fl.containers.ScrollPane;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.text.*;
	import flash.display.*;
	import flash.net.URLRequest;
	import flash.events.*;
	import com.pingfit.xml.*;
	import noponies.events.NpTextScrollBarEvent;
	import noponies.ui.NpTextScroller;
	import gs.TweenLite;
	import gs.easing.*;
	import gs.TweenGroup;
	import com.pingfit.format.TextUtil;
	import com.pingfit.format.Shadow;
	import com.pingfit.controls.DoneButton;
	import com.pingfit.controls.SkipIt;
	import com.pingfit.controls.Congrats;
	import com.pingfit.data.static.*;
	import com.pingfit.data.objects.*;
	import com.pingfit.events.*;
	import com.pingfit.timerpanel.TimerPanel;
	import com.pingfit.exercisepanel.ExercisePanel;
	import com.pingfit.exercisepanel.SoloPanel;
	import com.pingfit.chat.ChatPanel;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import fl.controls.CheckBox;
	import com.pingfit.alerts.*;
	
	
	public class NavPanelExercise extends NavPanelBase {
		
		private var exercisePanel:ExercisePanel;
		private var timerPanel:TimerPanel;
		private var chatPanel:ChatPanel;
		private var soloPanel:SoloPanel;
		private var congrats:Congrats;
		
		public function NavPanelExercise(maxWidth:Number, maxHeight:Number, navPanelType:String="Exercise", navPanelName:String="Exercise"){
			trace("NavPanelExercise instanciated");
			super(maxWidth, maxHeight, navPanelType, navPanelName);
			//if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
		}
		
		public override function initListener (e:Event):void {
			trace("NavPanelExercise.initListener() called");
			super.initListener(e);
		
			//Listen
			Broadcaster.addEventListener(DoExercise.TYPE, onDoExercise);
			Broadcaster.addEventListener(SkipExercise.TYPE, onSkipExercise);
			Broadcaster.addEventListener(PEvent.DISPLAYCURRENTEXERCISE, onDisplayCurrentExercise);
			Broadcaster.addEventListener(EnterRoom.TYPE, onEnterRoom);
			Broadcaster.addEventListener(LeaveRoom.TYPE, onLeaveRoom);
			Broadcaster.addEventListener(PEvent.SWITCHTOWORKOUTALONE, onSwitchToWorkoutAlone);
			Broadcaster.addEventListener(PEvent.SWITCHTOWORKOUTGROUP, onSwitchToWorkoutGroup);
			Broadcaster.addEventListener(PEvent.CHANGEEXERCISELIST, onChangeExerciseList);
			Broadcaster.addEventListener(PEvent.CHANGEEXERCISEEVERYXMINUTES, onChangeExerciseEveryXMinutes);
			
			timerPanel = new TimerPanel(200, 240);
			addChild(timerPanel);
			
			trace("NavPanelExercise CurrentUser.getUser().getExercisechooserid()="+CurrentUser.getUser().getExercisechooserid());
			if (CurrentUser.getUser().getExercisechooserid()==2){
				turnOnChatPanel();
			} else {
				turnOnSoloPanel();
			}
			
			
			//Initial Resize
			resize(maxWidth, maxHeight);
		}
		
		//Note: doesn't run if panel is already visible and is called again and again
		public override function onSwitchFromHiddenToVisible():void {   }
		
		//Resize
		public override function resize (maxWidth:Number, maxHeight:Number):void {
			//trace("NavPanelExercise -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			super.resize(maxWidth, maxHeight);
		}
		
		private var congratsRemoveTimer:Timer;
		private function onDoExercise(e:DoExercise){
			trace("NavPanelExercise.onDoExercise() e.target="+e.target+" e.exercise.name="+e.exercise.getName());
			var exercise:Exercise = e.exercise;
			if (exercisePanel!=null){removeChild(exercisePanel); exercisePanel=null;}
			if (congrats==null){  
				congrats = new Congrats(550, 60);  
				addChild(congrats); 
				congrats.addEventListener(MouseEvent.MOUSE_OVER, onCongratsMouseOver); 
				congrats.addEventListener(MouseEvent.MOUSE_OUT, onCongratsMouseOut);
			}
			congrats.nextFact();
			congrats.nextCongrat();
			congrats.x = maxWidth + 10;
			congrats.y = 180;
			congrats.visible = true;
			TweenLite.to(congrats, 1.25, {x:maxWidth-600, ease:Elastic.easeOut});
			congratsRemoveTimer = new Timer(10000, 1);
			congratsRemoveTimer.addEventListener(TimerEvent.TIMER, onCongratsRemoveTimer);
			congratsRemoveTimer.start();
		}
		private function onCongratsRemoveTimer(e:TimerEvent):void{
			TweenLite.to(congrats, 1, {x:maxWidth+10, ease:Elastic.easeIn, onComplete:onCongratsRemoveTimerDone});
		}
		private function onCongratsRemoveTimerDone():void{
			congrats.visible = false;
		}
		private function onCongratsMouseOver(e:MouseEvent):void{
			congratsRemoveTimer.stop();
		}
		private function onCongratsMouseOut(e:MouseEvent):void{
			congratsRemoveTimer.start();
		}
		
		private function onSkipExercise(e:SkipExercise){
			trace("NavPanelExercise.onSkipExercise() e.target="+e.target+" e.exercise.name="+e.exercise.getName());
			var exercise:Exercise = e.exercise;
			if (exercisePanel!=null){removeChild(exercisePanel); exercisePanel=null;}
		}
		
		public function onDisplayCurrentExercise(e:PEvent){
			trace("NavPanelExercise.onDisplayCurrentExercise()");
			if (congrats!=null && congrats.visible){onCongratsRemoveTimer(null);}
			if (exercisePanel!=null){removeChild(exercisePanel); exercisePanel=null;}
			//@todo remove advertising panel
			exercisePanel = new ExercisePanel(maxWidth-200, maxHeight-300, NextExercises.getCurrentExercise());
			exercisePanel.x = 200;
			exercisePanel.y = 0;
			addChild(exercisePanel);
		}
		

		//onEnterRoom
		public function onEnterRoom(e:EnterRoom){
			trace("NavPanelExercise.onEnterRoom()");
			if (exercisePanel!=null){removeChild(exercisePanel); exercisePanel=null;}
		}

		
		//onLeaveRoom
		public function onLeaveRoom(e:LeaveRoom){
			trace("NavPanelExercise.onLeaveRoom()");
			if (exercisePanel!=null){removeChild(exercisePanel); exercisePanel=null;}
		}
		
		//onSwitchToWorkoutAlone
		public function onSwitchToWorkoutAlone(e:PEvent){
			trace("NavPanelExercise.onSwitchToWorkoutAlone()");
			if (exercisePanel!=null){removeChild(exercisePanel); exercisePanel=null;}
			turnOnSoloPanel();
		}

		//onSwitchToWorkoutGroup
		public function onSwitchToWorkoutGroup(e:PEvent){
			trace("NavPanelExercise.onSwitchToWorkoutGroup()");
			if (exercisePanel!=null){removeChild(exercisePanel); exercisePanel=null;}
			turnOnChatPanel();
		}
		
		//onChangeExerciseList
		public function onChangeExerciseList(e:PEvent){
			trace("NavPanelExercise.onChangeExerciseList()");
			if (exercisePanel!=null){removeChild(exercisePanel); exercisePanel=null;}
		}
		
		//onChangeExerciseEveryXMinutes
		public function onChangeExerciseEveryXMinutes(e:PEvent){
			trace("NavPanelExercise.onChangeExerciseEveryXMinutes()");
			if (exercisePanel!=null){removeChild(exercisePanel); exercisePanel=null;}
		}
		
		
		//ChatPanel Turn On / Turn Off
		public function turnOnChatPanel():void {
			removeSoloPanel();
			if (chatPanel!=null){removeChatPanelDone();}
			chatPanel = new ChatPanel(maxWidth-28, maxHeight - 240 - 18);
			chatPanel.x = 10;
			chatPanel.y = 240;
			addChild(chatPanel);
		}
		public function removeChatPanel(){
			if (chatPanel!=null){TweenLite.to(chatPanel, 1, {alpha:0, onComplete:removeChatPanelDone});}
		}
		private function removeChatPanelDone():void {
			if (chatPanel!=null){removeChild(chatPanel); chatPanel = null;}
		}
		
		
		//SoloPanel Turn On / Turn Off
		public function turnOnSoloPanel():void {
			removeChatPanel();
			if (soloPanel!=null){removeSoloPanelDone();}
			soloPanel = new SoloPanel(maxWidth-28, maxHeight - 240 - 18);
			soloPanel.x = 10;
			soloPanel.y = 240;
			addChild(soloPanel);
		}
		public function removeSoloPanel(){
			if (soloPanel!=null){TweenLite.to(soloPanel, 1, {alpha:0, onComplete:removeSoloPanelDone});}
		}
		private function removeSoloPanelDone():void {
			if (soloPanel!=null){removeChild(soloPanel); soloPanel = null;}
		}
		
		
		
		


	}
	
}