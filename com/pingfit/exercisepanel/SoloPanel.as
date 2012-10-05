package com.pingfit.exercisepanel {
	
	
	import flash.display.MovieClip;
	import fl.containers.ScrollPane;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Stage;
	import flash.text.*;
	import flash.display.*;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.net.*;
	import com.pingfit.xml.*;
	import com.pingfit.events.*;
	import gs.TweenLite;
	import gs.easing.*;
	import gs.TweenGroup;
	import com.pingfit.format.TextUtil;
	import com.pingfit.format.Shadow;
	import com.pingfit.data.objects.Room;
	import com.pingfit.data.static.NetConn;
	import com.pingfit.data.static.CurrentRoom;
	import com.pingfit.data.static.Friends;
	import com.pingfit.data.static.CurrentUser;
	import com.pingfit.data.static.ExerciseLists;
	import com.pingfit.data.static.BigRefresh;
	import com.pingfit.data.objects.ExerciseList;
	import com.pingfit.roomspanel.ChangeRoomsButton;
	import com.pingfit.roomspanel.ExerciseWithFriendsButton;
	import com.pingfit.scroller.Scroller;
	import com.pingfit.data.objects.User;
	import com.pingfit.controls.InviteFriendsButton;
	import fl.controls.Slider;
	import fl.controls.SliderDirection;
	import fl.controls.ComboBox;
	import fl.controls.CheckBox;
	import fl.events.SliderEvent;
	
	public class SoloPanel extends MovieClip {
		
		private var maxWidth:Number = 200;
		private var maxHeight:Number = 400;
		private var bg:MovieClip;
		private var panelLabel:TextField;
		private var exerciseWithFriendsButton:ExerciseWithFriendsButton;
		private var workoutEverySlider:Slider;
		private var workoutEverySliderLabel:TextField;
		private var exerciseListsComboBox:ComboBox;
		
		public function SoloPanel(maxWidth:Number, maxHeight:Number){
			//trace("ChatPanel instanciated");
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			if (stage) {initListener(null);} else {addEventListener(Event.ADDED_TO_STAGE, initListener);}
			//addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}
		
		function initListener (e:Event):void {
			//trace("ChatPanel.initListener() called");
			removeEventListener(Event.ADDED_TO_STAGE, initListener);
			
			
			bg = new MovieClip();
			addChild(bg);
			
			

			
			panelLabel = TextUtil.getTextField(TextUtil.getHelveticaRounded(25, 0xE6E6E6, true), maxWidth-100, "Exercise Solo");
			panelLabel.filters = Shadow.getDropShadowFilterArray(0x000000);
			panelLabel.x = 10;
			panelLabel.y = 23;
			panelLabel.alpha = .5;
			addChild(panelLabel);
			
			exerciseWithFriendsButton = new ExerciseWithFriendsButton(10,10);
			exerciseWithFriendsButton.x = panelLabel.x + panelLabel.textWidth + 10;
			exerciseWithFriendsButton.y = 28;
			exerciseWithFriendsButton.buttonMode = true;
			addChild(exerciseWithFriendsButton);
			
			
			
			
			var leftColX:Number = 50;
			var rightColX:Number = 450;
			
			exerciseListsComboBox = new ComboBox();
			exerciseListsComboBox.x = leftColX;
			exerciseListsComboBox.y = 150;
			exerciseListsComboBox.setSize(300,22);
			var exerciselists:Array  = ExerciseLists.getExerciseLists();
			for each (var exerciselist:ExerciseList in exerciselists) {
				exerciseListsComboBox.addItem( { label: exerciselist.getName(), data:exerciselist.getExerciselistid()} );
				if (exerciselist.getExerciselistid() == CurrentUser.getUser().getExerciselistid()){
					exerciseListsComboBox.selectedIndex=exerciseListsComboBox.length-1;
				}
			}
			exerciseListsComboBox.addEventListener(Event.CHANGE, exerciseListsComboBoxChanged);
			addChild(exerciseListsComboBox);
			
			
			

			workoutEverySlider = new Slider();
			workoutEverySlider.direction = SliderDirection.HORIZONTAL;
			workoutEverySlider.width = 300;
			workoutEverySlider.minimum = 1;
			workoutEverySlider.maximum = 60;
			workoutEverySlider.value = CurrentUser.getUser().getExerciseeveryxminutes(); 
			workoutEverySlider.addEventListener(SliderEvent.CHANGE, workoutEverySliderChanged);
			workoutEverySlider.addEventListener(SliderEvent.THUMB_DRAG, workoutEverySliderDrag);
			workoutEverySlider.addEventListener(SliderEvent.THUMB_PRESS, workoutEverySliderPress);            
			workoutEverySlider.addEventListener(SliderEvent.THUMB_RELEASE, workoutEverySliderRelease);
			workoutEverySlider.x = rightColX;
			workoutEverySlider.y = 175;
			addChild(workoutEverySlider);

			workoutEverySliderLabel = TextUtil.getTextField(TextUtil.getHelveticaRounded(13, 0xE6E6E6, true), 180, "Exercise every "+workoutEverySlider.value+" minutes");
			workoutEverySliderLabel.width = 300;
			workoutEverySliderLabel.height = 20;
			workoutEverySliderLabel.x =rightColX;
			workoutEverySliderLabel.y = 150;
			addChild(workoutEverySliderLabel);
			

			
			//Resize
			resize(maxWidth, maxHeight);
		}
		
		
		
		
		public function resize (maxWidth:Number, maxHeight:Number):void {
			//trace("SoloPanel -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			bg.graphics.clear();
			bg.graphics.beginFill(0x000000);
			bg.graphics.drawRoundRect(0,0, maxWidth, maxHeight-50, 30);
			bg.graphics.endFill();
			bg.alpha = .15;
			bg.y = 50;
		}
		
		
		
		private function exerciseListsComboBoxChanged(e:Event):void {
			trace("ComboBox changed: exerciseListsComboBox.selectedItem.data=" + exerciseListsComboBox.selectedItem.data);
			callSetExerciseList(exerciseListsComboBox.selectedItem.data);
        }
		
		
		
		private function workoutEverySliderDrag(e:SliderEvent):void {
            trace("Slider dragging: " + e.target.value);
            workoutEverySliderLabel.htmlText =  "Exercise every "+e.target.value+" minutes";     
        }
        private function workoutEverySliderPress(e:SliderEvent):void {
            trace("Slider pressed: " + e.target.value);
			workoutEverySliderLabel.htmlText =  "Exercise every "+e.target.value+" minutes";     
        }
        private function workoutEverySliderRelease(e:SliderEvent):void {
			trace("Slider released: " + e.target.value);
            workoutEverySliderLabel.htmlText =  "Exercise every "+e.target.value+" minutes";   
        }
        private function workoutEverySliderChanged(e:SliderEvent):void {
			trace("Slider changed: " + e.target.value);
            workoutEverySliderLabel.htmlText =  "Exercise every "+e.target.value+" minutes"; 
			callSetExerciseEveryXMinutes();
        }
		

		private function callSetExerciseEveryXMinutes():void{
			trace("SettingsPanel.callSetExerciseEveryXMinutes called");
			var callSetExerciseEveryXMinutesAPI:CallSetExerciseEveryXMinutes = new CallSetExerciseEveryXMinutes(workoutEverySlider.value);
			callSetExerciseEveryXMinutesAPI.addEventListener(ApiCallSuccess.TYPE, callSetExerciseEveryXMinutesDone);
		}
		private function callSetExerciseEveryXMinutesDone(e:ApiCallSuccess):void{
			trace("SettingsPanel.callSetExerciseEveryXMinutesDone");
			BigRefresh.load(e.xmlData.bigrefresh[0]);
			Broadcaster.dispatchEvent(new PEvent(PEvent.CHANGEEXERCISEEVERYXMINUTES));
		}

	
		private function callSetExerciseList(exerciselistid:int):void{
			trace("SettingsPanel.callSetExerciseList called");
			var callSetExerciseListAPI:CallSetExerciseList = new CallSetExerciseList(exerciselistid);
			callSetExerciseListAPI.addEventListener(ApiCallSuccess.TYPE, callSetExerciseListDone);
		}
		private function callSetExerciseListDone(e:ApiCallSuccess):void{
			trace("SettingsPanel.callSetExerciseListDone");
			BigRefresh.load(e.xmlData.bigrefresh[0]);
			Broadcaster.dispatchEvent(new PEvent(PEvent.CHANGEEXERCISELIST));
		}
		
		

		
		

	}
	
}