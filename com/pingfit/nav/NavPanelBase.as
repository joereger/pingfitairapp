package com.pingfit.nav {
	
	
	import flash.display.MovieClip;
	import com.pingfit.controls.Background;
	import com.pingfit.events.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	
	
	public class NavPanelBase extends MovieClip {
		
		protected var maxWidth:Number = 0;
		protected var maxHeight:Number = 0;
		protected var navPanelType:String=""; //Handles NavBar stuff, categorizes this panel
		protected var navPanelName:String=""; //Identifies this exact instance of the panel
		protected var hasBeenInitted:Boolean = false;
		protected static var mostCurrentTurnOnNavPanelTime:Number = 0; //Makes sure only most recent call is executed
		protected static var currentNavPanelName:String = ""; //Tells me which panel is currently on
		

		
		
		public function NavPanelBase(maxWidth:Number, maxHeight:Number, navPanelType:String, navPanelName:String){
			//trace("NavPanelBase instanciated");
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			this.navPanelType = navPanelType;
			this.navPanelName = navPanelName;
			Broadcaster.addEventListener(TurnOnNavPanel.TYPE, onTurnOnNavPanel);
		}
		
		public function initListener(e:Event):void {
			//trace("NavPanelBase.initListener() called");
		}
		
		
		//Turn On/Off
		private function onTurnOnNavPanel(e:TurnOnNavPanel):void{
			//trace("NavPanelBase.onTurnOnNavPanel() saying switch to e.navPanelName=" + e.navPanelName + " heard by navPanelName=" + navPanelName +" - e.timeCreated="+e.timeCreated+" mostCurrentTurnOnNavPanelTime="+mostCurrentTurnOnNavPanelTime);
			//Ignore old, out-of-date navpanel changes
			if (e.timeCreated >= mostCurrentTurnOnNavPanelTime) {
				mostCurrentTurnOnNavPanelTime = e.timeCreated;
				currentNavPanelName = e.navPanelName;
			} else {
				//trace("NavPanelBase.onTurnOnNavPanel() saying switch to e.navPanelName=" + e.navPanelName + " heard by navPanelName=" + navPanelName +" - ignoring request because it's too old ");
				return;
			}
			//Capture the current state of this panel
			var isCurrentlyVisible = this.visible;
			//Only one NavPanel can be on at a time... them's the rules Poncho
			if (e.navPanelName == navPanelName) {
				//trace("NavPanelBase.onTurnOnNavPanel() saying switch to e.navPanelName=" + e.navPanelName + " heard by navPanelName=" + navPanelName +" - setting this.visible=true because e.navPanelName==navPanelName");
				this.visible = true;
				//Only init the first time it's added to the screen.
				if (!hasBeenInitted) {
					//trace("NavPanelBase.onTurnOnNavPanel() saying switch to e.navPanelName=" + e.navPanelName + " heard by navPanelName=" + navPanelName +" - !hasBeenInitted so calling initListener(null) ");
					initListener(null);
					hasBeenInitted = true;
				}
				if (!isCurrentlyVisible) {
					//trace("NavPanelBase.onTurnOnNavPanel() saying switch to e.navPanelName=" + e.navPanelName + " heard by navPanelName=" + navPanelName +" - !isCurrentlyVisible ");
					//Turn navbar on or off based on this panel's settings
					if (isNavBarVisibleForThisPanel()) {
						//trace("NavPanelBase.onTurnOnNavPanel() saying switch to e.navPanelName=" + e.navPanelName + " heard by navPanelName=" + navPanelName +" - isNavBarVisibleForThisPanel()==true so calling TURNONNAVBAR ");
						Broadcaster.dispatchEvent(new PEvent(PEvent.TURNONNAVBAR));
					} else {
						//trace("NavPanelBase.onTurnOnNavPanel() saying switch to e.navPanelName=" + e.navPanelName + " heard by navPanelName=" + navPanelName +" - isNavBarVisibleForThisPanel()==false so calling TURNOFFNAVBAR ");
						Broadcaster.dispatchEvent(new PEvent(PEvent.TURNOFFNAVBAR));
					}
					onSwitchFromHiddenToVisible();
				}
				
			} else {
				//trace("NavPanelBase.onTurnOnNavPanel() saying switch to e.navPanelName=" + e.navPanelName + " heard by navPanelName=" + navPanelName +" - setting this.visible=false because e.navPanelName!=navPanelName");
				this.visible = false;
			}
		}
		
		//Run only when panel goes from hidden to visible
		public function onSwitchFromHiddenToVisible():void {
			//Override in classes that extend to add specific functionality
		}
		
		
		
		//Override to hide NavBar for a specific panel
		public function isNavBarVisibleForThisPanel():Boolean {
			return true;
		}
		
		
		
		//Resize
		public function resize(maxWidth:Number, maxHeight:Number):void {
			//trace("NavPanelBase -- RESIZE -- maxWidth="+maxWidth+" maxHeight="+maxHeight);
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			//bg.resize(maxWidth, maxHeight);
		}
		
		//Drag
		private function onMove(event:MouseEvent):void{
			stage.nativeWindow.startMove();
			event.stopPropagation();
		}
		
		//onChangeBgColor
		//private function onChangeBgColor(e:ChangeBgColor):void{
			//trace("NavPanelBase.onChangeBgColor() e.color="+e.color);
			//if (bg!=null){bg.setColor(e.color);}
		//}
		
		
		public function getNavPanelType():String{return navPanelType;}
		public function getNavPanelName():String { return navPanelName; }
		public static function getCurrentNavPanelName():String { return currentNavPanelName; }

	}
	
}