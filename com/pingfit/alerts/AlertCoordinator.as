package com.pingfit.alerts {
	
	import flash.display.*;
	import flash.system.Capabilities;
	import flash.events.Event;

	public class AlertCoordinator {
		
		
		public static var alertWindows:Array = new Array();
		
		public function AlertCoordinator() {
			
		}
		
		public static function newAlert(boldmsg:String, tinymsg:String = "", eventToDispatchOnClick:Event = null):void {
			trace("AlertCoordinator.newAlert() boldmsg="+boldmsg);
			var widthOfAlert:Number = 250;
			var heightOfAlert:Number = 100;
			var toolbarHeight:Number = 25;
			
			//Create the alert movieclip
			var alert = new Alert(widthOfAlert, heightOfAlert, boldmsg, tinymsg, eventToDispatchOnClick);
			
			//Now for the window that holds the alert
			var alertWindow:NativeWindow = createNativeWindow();
			var screenMaxX:int = Capabilities.screenResolutionX;
			var screenMaxY:int = Capabilities.screenResolutionY;
			alertWindow.x = screenMaxX - widthOfAlert - 50;
			alertWindow.y = screenMaxY - heightOfAlert - toolbarHeight - 50;
			alertWindow.width = widthOfAlert;
			alertWindow.height = heightOfAlert;
			alertWindow.activate();
			alertWindow.stage.addChild(alert);
			
			//Clean up
			cleanNullAlertWindowsFromArray();
			
			//Add to array
			alertWindows.push(alertWindow);
		}
		
		private static function cleanNullAlertWindowsFromArray():void {
			if (alertWindows != null) {
				for ( var i:int = 0; i < alertWindows.length; i++ ) {
					var nativeWindow:NativeWindow = NativeWindow(alertWindows[i]);
					trace("AlertCoordinator.cleanNullAlertWindowsFromArray() i="+i);
					if (nativeWindow.closed) {
						//Remove this closed window
						alertWindows.splice(i, 1);
						trace("AlertCoordinator.cleanNullAlertWindowsFromArray() removing i="+i);
						//Reset i=0 to go back to the beginning
						i = 0;
					}
				}
			}
		}
		
		
		
		public static function createNativeWindow():NativeWindow{
			var windowOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
			windowOptions.minimizable = false;
			windowOptions.maximizable = false;
			windowOptions.resizable = true;
			windowOptions.type = NativeWindowType.UTILITY;
			windowOptions.systemChrome = NativeWindowSystemChrome.NONE;
			windowOptions.transparent = true;
			var nativeWindow:NativeWindow = new NativeWindow(windowOptions);
			nativeWindow.stage.scaleMode = StageScaleMode.NO_SCALE;
			nativeWindow.stage.align = StageAlign.TOP_LEFT;
			return nativeWindow;
		}
		
		
	}
	
}