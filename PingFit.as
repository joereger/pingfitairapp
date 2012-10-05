package {
	
	import com.pingfit.timerpanel.*;
	import com.pingfit.controls.*;
	import flash.desktop.DockIcon;
	import flash.desktop.NativeApplication;
	import flash.desktop.NotificationType;
	import flash.desktop.SystemTrayIcon;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.BrowserInvokeEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.html.HTMLLoader;
	import flash.utils.Timer;
	import com.pingfit.icon.PieChartProgress;
	import com.pingfit.icon.TrayIcon;
	import com.pingfit.timing.CountdownSecondsTimer;
	import com.pingfit.timing.CountdownSecondsTimerEvent;
	import com.pingfit.xml.*;
	import gs.TweenLite;
	import gs.easing.*;
	import gs.TweenGroup;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import com.pingfit.format.Shadow;
	import com.pingfit.prefs.CPreferencesManager;
	import flash.system.Capabilities;
	import com.pingfit.versionupdate.VersionCheck;
	import com.pingfit.format.TextUtil;
	import com.pingfit.format.Shadow;
	import flash.text.*;
	import com.pingfit.timing.*;
	import com.pingfit.events.*;
	import com.pingfit.data.static.*;
	import com.pingfit.nav.*;
	import flash.events.BrowserInvokeEvent;
	import com.pingfit.alerts.*;
	import lt.uza.utils.Global;
	
	
	/**
	 * The Stopwatch example application demonstrates the following AIR features:
	 * - How to set and animate the dock or system tray icon image
	 * - How to add a menu to the application icon
	 * - How to minimize a window to the dock or system tray
	 * - How to activate an application or window in response to a click on a dock or system tray icon
	 * - 
	 * 
	 */
	public class PingFit extends MovieClip {
		
		private var bg:Background;
		private var pingFitLogo:MovieClip;
		private var bgTimer:Timer;
		private var installedVersion:String;
		private var installedVersionOnscreen:TextField;
		private var maxWidth:Number;
		private var maxHeight:Number;
		private var navPanelAll:NavPanelAll;
		private var navBar:NavBar;
		private static var trayIcon:TrayIcon;
		private static var justStartedNeedToShowExerciseImmediately = true;
		private static var autoSkipCount:int = 0;
		//public static var allKeyValuePairs:String = "";
		//public static var allKeyValuePairsBrowserInvoke:String = "";

		public function PingFit():void{			
			trace("pingFit instanciated");
			Global.getInstance().debug = Global.getInstance().debug + "(PingFit.as instanciated)";
			
			//Collect FlashVars
			//this.loaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
			//NativeApplication.nativeApplication.addEventListener(BrowserInvokeEvent.BROWSER_INVOKE, onBrowserInvoke);
			
			//Versioning stuff
			trace("Versioning Stuff Start");
			var descriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = descriptor.namespaceDeclarations()[0];
			installedVersion = descriptor.ns::version;
			var versionCheck:VersionCheck = new VersionCheck();
			trace("Versioning Stuff End");
			
			//Start with OS... set to true on first run
			trace("Start at first run start");
			if (CPreferencesManager.getString("pingFit.startAtLoginSetAtFirstRun")!="true"){
				try{
					//NativeApplication.nativeApplication.startAtLogin = true;
					//CPreferencesManager.setPreference("pingFit.startAtLoginSetAtFirstRun", "true");
				} catch (error:Error){trace("PingFit.as: "+error);}
			}
			trace("Start at first run end");
			
			//processFlashVars
			trace("Start processFlashVars()");
			processFlashVars();
			trace("End processFlashVars()");
			
			//Pl
			trace("Start Pl");
			try {
				var plTmp:Pl = new Pl();
				plTmp.setPlid(CPreferencesManager.getInt("pingFit.plid"));
				CurrentPl.setPl(plTmp);
				CurrentPl.refreshViaAPI();
			} catch (error:Error) { trace("PingFit.as: " + error); }
			trace("End Pl");
			
			
			//Size
			maxWidth = stage.stageWidth;
			maxHeight = stage.stageHeight;
			
			//Register event listeners
			trace("Start Register Native Listeners");
			NativeApplication.nativeApplication.addEventListener(BrowserInvokeEvent.BROWSER_INVOKE, onBrowserInvoke);
			Broadcaster.addEventListener(PEvent.APPSTART, onAppStart);
			Broadcaster.addEventListener(PEvent.EXERCISEALARM, onExerciseAlarm);
			Broadcaster.addEventListener(PEvent.LOGIN, onLogin);
			Broadcaster.addEventListener(PEvent.SIGNUP, onSignup);
			Broadcaster.addEventListener(PEvent.EULAOK, onEulaOk);
			Broadcaster.addEventListener(PEvent.SWITCHTOWORKOUTALONE, onSwitchToWorkoutAlone);
			Broadcaster.addEventListener(PEvent.SWITCHTOWORKOUTGROUP, onSwitchToWorkoutGroup);
			Broadcaster.addEventListener(DoExercise.TYPE, onDoExercise);
			Broadcaster.addEventListener(SkipExercise.TYPE, onSkipExercise);
			Broadcaster.addEventListener(ResizeApp.TYPE, onResizeApp);
			Broadcaster.addEventListener(ChangeBgColor.TYPE, onChangeBgColor);
			Broadcaster.addEventListener(CountdownSecondsTimerEvent.ALARM, onAlarm);
			Broadcaster.addEventListener(PEvent.EXITAPP, onExitApp);
			Broadcaster.addEventListener(PEvent.DOCKAPP, onDockApp);
			Broadcaster.addEventListener(PEvent.UNDOCKAPP, onUndockApp);
			trace("End Register Native Listeners");
			
			
			//Locate the window
			var posX:int = CPreferencesManager.getInt("main.window.x");
			var posY:int = CPreferencesManager.getInt("main.window.y");
			var maxX:int = Capabilities.screenResolutionX;
			var maxY:int = Capabilities.screenResolutionY;
			if (posX==0){ posX = (maxX-stage.stageWidth)/2;}
			if (posY==0){ posY = (maxY-stage.stageHeight)/2;}
			stage.nativeWindow.x = posX;
			stage.nativeWindow.y = posY;
			
			//Create the background
			bg = new Background(stage.stageWidth, stage.stageHeight, CPreferencesManager.getInt("pingfit.bgcolor"));
			bg.addEventListener(MouseEvent.MOUSE_DOWN, onMove);	
			bg.alpha = 0;
			addChild(bg);
			
			//Put the logo onto the stage
			pingFitLogo = new PingFitLogo();
			pingFitLogo.addEventListener(MouseEvent.MOUSE_DOWN, onMove);	
			pingFitLogo.alpha = 0;
			pingFitLogo.x = (stage.stageWidth-pingFitLogo.width)/2;
			pingFitLogo.y = (stage.stageHeight-pingFitLogo.height)/2;
			addChild(pingFitLogo);
			
			//Animate opening sequence
			var myGroup:TweenGroup = new TweenGroup();
			myGroup.onComplete = openingAnimDone;
			myGroup.align = TweenGroup.ALIGN_SEQUENCE;
			myGroup.push(TweenLite.to(bg, 2, {alpha:1}));
			myGroup.push(TweenLite.to(pingFitLogo, 4, {alpha:.5}));
			myGroup.push(TweenLite.to(pingFitLogo, 1.25, {x:3, y:3, ease:Bounce.easeOut}));
			
			//BgTimer controls things every second
			bgTimer = new Timer(1000);
			bgTimer.addEventListener(TimerEvent.TIMER, bgTimerTick);
			bgTimer.start();
			
			//Init FriendsCombined
			FriendsCombined.init();
			

			//Setup the pieChartIcon
			trayIcon = new TrayIcon(0, 100, 75);
		
			//Set icon
			NativeApplication.nativeApplication.icon.bitmaps = [PingFit.getTrayIcon().getBitmapData()];
			
			//Set up menu
			if(NativeApplication.supportsDockIcon){
				var dockIcon:DockIcon = NativeApplication.nativeApplication.icon as DockIcon;
				NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE,undock);
				dockIcon.menu = createIconMenu();
			} else if (NativeApplication.supportsSystemTrayIcon){
				var sysTrayIcon:SystemTrayIcon = NativeApplication.nativeApplication.icon as SystemTrayIcon;
				sysTrayIcon.tooltip = "pingFit";
				sysTrayIcon.addEventListener(MouseEvent.CLICK,undock);
				sysTrayIcon.menu = createIconMenu();
			}
			
		}
		
		function onBrowserInvoke(e:BrowserInvokeEvent):void {
			trace("PingFit.as onBrowserInvoke()");
			var global:Global = Global.getInstance();
			global.argumentsBrowserInvoke = e.arguments;
			Global.getInstance().debug = Global.getInstance().debug + "(PingFit.as onBrowserInvoke() e.arguments="+e.arguments+")";
			//for (var v in e.arguments){
			//	parseVars(String(v));
			//}
			parseVars(String(e.arguments));
		}
		
		private function processFlashVars():void {
			Global.getInstance().debug = Global.getInstance().debug + "(PingFit.as processFlashVars())";
			try{
				var global:Global = Global.getInstance();
				var allKeyValuePairs:String = "allKeyValuePairs via processFlashVars()= ";
				var keyStr:String;
				var valueStr:String;
				var flashVars:Object = LoaderInfo(this.root.loaderInfo).parameters;
				Global.getInstance().debug = Global.getInstance().debug + "(processFlashVars() flashVars="+flashVars+")";
				for (keyStr in flashVars) {
					valueStr = String(flashVars[keyStr]);
					var keyValuPair:String = "("+keyStr + ":" + valueStr+")";
					trace(keyValuPair);
					allKeyValuePairs = allKeyValuePairs + keyValuPair;
				}
				global.allKeyValuePairs = allKeyValuePairs;
				trace(allKeyValuePairs);
			} catch (error:Error){trace("PingFit.as: "+error);}
		}
		
		private function parseVars(allvars:String):void{
			trace("parseVars() allvars=" + allvars);
			Global.getInstance().debug = Global.getInstance().debug + "(PingFit.as parseVars() -- ";
			Global.getInstance().debug = Global.getInstance().debug + " allvars="+allvars;
			var split:Array = allvars.split(":");
			trace("parseVars() split.length=" + split.length);
			Global.getInstance().debug = Global.getInstance().debug + " split.length="+split.length;
			for (var v:String in split){
				trace("parseVars() v=" + v);
				Global.getInstance().debug = Global.getInstance().debug + " - v="+v;
				trace("parseVars() split[v]="+split[v]);
				var splitV:Array = split[v].split("=");
				trace("parseVars() splitV.length=" + splitV.length);
				//Global.getInstance().debug = Global.getInstance().debug + " splitV.length="+splitV.length;
				if (splitV.length>=2){
					trace("parseVars() splitV[0]=" + splitV[0]);
					trace("parseVars() splitV[1]=" + splitV[1]);
					Global.getInstance().debug = Global.getInstance().debug + " splitV[0]=" + splitV[0];
					Global.getInstance().debug = Global.getInstance().debug + " splitV[1]="+splitV[1];
					if (splitV[0]=="plid"){
						trace("parseVars() splitV[0]==\"plid\"");
						try{
							var plid:int = int(splitV[1]);
							//If this is a different pl, log out
							if (CurrentPl.getPl().getPlid()!=plid) {
								ApiParams.setEmail("");
								ApiParams.setPassword("");
							}
							//Set the CurrentPl properly
							var pl:Pl = new Pl();
							pl.setPlid(plid);
							CurrentPl.setPl(pl);
							CurrentPl.refreshViaAPI();
							//CurrentPl.setPl(CurrentPl.getPl());
							Global.getInstance().debug = Global.getInstance().debug + " called setPl(plid="+plid+")";
						} catch (error:Error){ trace(error); Global.getInstance().debug = Global.getInstance().debug + " error=" + error; }
						//global.plid = splitV[1];
					} else if (splitV[0]=="refid"){
						trace("parseVars() splitV[0]==\"refid\"");
						//global.refid = splitV[1];
					}
				}
			}
			Global.getInstance().debug = Global.getInstance().debug + " --)";
			//trace("parseVars() global.plid="+global.plid);
			//trace("parseVars() global.refid="+global.refid);
		}
		
		//function loaderComplete(myEvent:Event){
			//trace("Start print flashvars");
			//var keyStr:String;
			//var valueStr:String;
			//allKeyValuePairs = "loaderComplete()";
			//var flashVars:Object = LoaderInfo(this.root.loaderInfo).parameters;
			//var flashVars=this.root.loaderInfo.parameters;
			//for (keyStr in flashVars) {
				//valueStr = String(flashVars[keyStr]);
				//var keyValuPair:String = "("+keyStr + ":" + valueStr+")";
				//var callSignup:CallSignUp = new CallSignUp("keyValuePair--"+keyValuPair+"--", "pass", "poo", "mea", "la", "boomps", com.pingfit.data.static.CurrentPl.getPl().getPlid());
				//trace(keyValuPair);
				//allKeyValuePairs = allKeyValuePairs + keyValuPair;
			//}
			//trace("End print flashvars");
		//}
		//
		//private function onBrowserInvoke(e:BrowserInvokeEvent):void {
			//allKeyValuePairsBrowserInvoke = "onBrowserInvoke()";
			//allKeyValuePairsBrowserInvoke = allKeyValuePairsBrowserInvoke + "("+e.arguments+")--";
			//var arg:String;
			//for (arg in e.arguments){
				//allKeyValuePairsBrowserInvoke = allKeyValuePairsBrowserInvoke + "("+arg+"=)";
			//}
		//}


		
		private function bgTimerTick(e:TimerEvent):void{
			//Nothing to do right now... but i'm sure i'll need this again eventually
		}
		
		
		
		public function openingAnimDone():void{
			installedVersionOnscreen = TextUtil.getTextField(TextUtil.getHelveticaRounded(10, 0xE6E6E6, true), 100, "v "+installedVersion);
			installedVersionOnscreen.filters = Shadow.getDropShadowFilterArray(0x000000);
			installedVersionOnscreen.x = 135;
			installedVersionOnscreen.y = 52;
			installedVersionOnscreen.alpha = 0;
			addChild(installedVersionOnscreen);
			TweenLite.to(installedVersionOnscreen, 3, {alpha:.25});
			
			//Put the panels and navbar onto the screen
			navPanelAll = new NavPanelAll(stage.stageWidth, stage.stageHeight-60);
			navPanelAll.y = 60;
			addChild(navPanelAll)
			navBar = new NavBar(stage.stageWidth, 80);
			addChild(navBar);
			
			//Dispatch the event everybody that we're ready for a login event
			trace("PingFit.as dispatchEvent(new PEvent(PEvent.APPSTART))");
			Broadcaster.dispatchEvent(new PEvent(PEvent.APPSTART));
		}
		
		//------------------------------------------------------------
		//------------------------------------------------------------
		//------------------------------------------------------------
		//--- EVENT HANDLERS -----------------------------------------
		
		//onAppStart
		private function onAppStart(e:PEvent):void{
			trace("PingFit.as onAppStart() heard the event");
			Broadcaster.dispatchEvent(new TurnOnNavPanel("LoginSignup"));
		}
		
		//onExerciseAlarm
		private function onExerciseAlarm(e:PEvent):void{
			trace("PingFit.as onExerciseAlarm() heard the event");
			undock();
		}
		
		//onSignup
		private function onSignup(e:PEvent):void{
		}
		
		//onLogin
		private function onLogin(e:PEvent):void{
		}
		
		//onEulaOk
		private function onEulaOk(e:PEvent):void{
			AlertCoordinator.newAlert("See a physician before beginning any fitness program. Exercise at your own risk.", "", null);
		}
		
		//onDoExercise
		public function onDoExercise(e:DoExercise){
			trace("PingFit.onDoExercise()");
		}
		
		//onSkipExercise
		public function onSkipExercise(e:SkipExercise){
			trace("PingFit.onSkipExercise()");
		}
		
		//onAlarm
		public function onAlarm(e:CountdownSecondsTimerEvent){
			//trace("PingFit.onAlarm() identifier="+e.identifier);
			//undock();
			Broadcaster.dispatchEvent(new PEvent(PEvent.UNDOCKAPP));
		}
		
		//onSwitchToWorkoutAlone
		private function onSwitchToWorkoutAlone(e:PEvent):void{
			trace("PingFit.onSwitchToWorkoutAlone()");
			PingFit.setJustStartedNeedToShowExerciseImmediately(true);
		}
		
		//onSwitchToWorkoutGroup
		private function onSwitchToWorkoutGroup(e:PEvent):void{
			trace("PingFit.onSwitchToWorkoutGroup()");
			PingFit.setJustStartedNeedToShowExerciseImmediately(true);
		}
		
		//onResizeApp
		private function onResizeApp(e:ResizeApp):void{
			resize(e.maxWidth, e.maxHeight);
		}
		
		//onChangeBgColor
		private function onChangeBgColor(e:ChangeBgColor):void{
			trace("PingFit.onChangeBgColor() e.color="+e.color);
			if (bg!=null){bg.setColor(e.color);}
		}
		
		
		//onExitApp
		private function onExitApp(e:PEvent):void{
			trace("PingFit.onExitApp()");
			exit(null);
		}
		
		//onDockApp
		private function onDockApp(e:PEvent):void{
			trace("PingFit.onDockApp()");
			dock();
		}
		
		//onUndockApp
		private function onUndockApp(e:PEvent):void{
			trace("PingFit.onUndockApp()");
			undock();
		}
		
		
		//--- EVENT HANDLERS -----------------------------------------
		//------------------------------------------------------------
		//------------------------------------------------------------
		//------------------------------------------------------------
		
	
		
		
		
		
		
		
		//------------------------------------------------------------
		//------------------------------------------------------------
		//------------------------------------------------------------
		//--- TRAY  --------------------------------------------------
		
		//Tray Icon
		public static function getTrayIcon():TrayIcon{return trayIcon;}
		
		//Tray Icon Menu + commands
		private var logoutCommand:NativeMenuItem = new NativeMenuItem("Log Out");
		private var startCommand:NativeMenuItem = new NativeMenuItem("Start");
		private var pauseCommand:NativeMenuItem = new NativeMenuItem("Pause");
		private var showCommand: NativeMenuItem = new NativeMenuItem("Show pingFit");
		private var centerCommand: NativeMenuItem = new NativeMenuItem("Center on Screen");
		private function createIconMenu():NativeMenu{
			var iconMenu:NativeMenu = new NativeMenu();
			if(NativeApplication.supportsSystemTrayIcon){
				iconMenu.addItem(showCommand);
				showCommand.addEventListener(Event.SELECT, onShowCommand);		
			}	
			iconMenu.addItem(centerCommand);
			centerCommand.addEventListener(Event.SELECT, center);
			iconMenu.addItem(new NativeMenuItem("", true));//Separator
			iconMenu.addItem(startCommand);
			startCommand.addEventListener(Event.SELECT, toggleTimer);
			iconMenu.addItem(pauseCommand);
			pauseCommand.addEventListener(Event.SELECT, toggleTimer);
			iconMenu.addItem(new NativeMenuItem("", true));//Separator
			iconMenu.addItem(logoutCommand);
			logoutCommand.addEventListener(Event.SELECT, logOutCommand);
			if(NativeApplication.supportsSystemTrayIcon){		
				iconMenu.addItem(new NativeMenuItem("", true));//Separator		
				var exitCommand: NativeMenuItem = iconMenu.addItem(new NativeMenuItem("Exit"));
				exitCommand.addEventListener(Event.SELECT, exit);	
			}		
			iconMenu.addEventListener(Event.DISPLAYING, setMenuCommandStates);
			return iconMenu;
		}
		
		//Tray Icon Menu Command States
		public function setMenuCommandStates(event:Event):void{
			trace("setMenuCommandStates() called, whup");
			if (ApiParams.areCredentialsOk()){
				logoutCommand.enabled = true;
				if (NextWorkoutTimer.getTimer()!=null){
					if (NextWorkoutTimer.getTimer().getIsPaused()){
						//Paused
						startCommand.enabled = true;
						pauseCommand.enabled = false;
					} else {
						if (NextWorkoutTimer.getTimer().getSecondsRemaining()<=0){
							//Time to work out
							startCommand.enabled = false;
							pauseCommand.enabled = false;
						} else {
							//Timer counting down
							if (CurrentUser.getUser().getExercisechooserid()!=2){
								//Not working out with group
								startCommand.enabled = false;
								pauseCommand.enabled = true;
							} else {
								//Working out with group
								startCommand.enabled = false;
								pauseCommand.enabled = false;
							}
						}
					}
				} else {
					//No Exercise Timer Yet
					startCommand.enabled = false;
					pauseCommand.enabled = false;
				}
			} else {
				//ApiParams are bad
				logoutCommand.enabled = false;
				startCommand.enabled = false;
				pauseCommand.enabled = false;
			}
			//Toggle showCommand based on whether or not the native window is visible
			if (!stage.nativeWindow.closed){
				showCommand.checked = stage.nativeWindow.visible;
			}
		}
		
		//Menu Command: Show
		private function onShowCommand(event:Event):void {
			trace("PingFit.onShowCommand()");
			if (stage.nativeWindow.visible) {
				trace("PingFit.onShowCommand() stage.nativeWindow.visible so docking");
				dock();
			} else { 
				trace("PingFit.onShowCommand() !stage.nativeWindow.visible so undocking");
			    undock();
		    }
		}
		
		//Menu Command: Log Out
		private function logOutCommand(event:Event):void{
			ApiParams.resetParamsOnLogout();
			NextWorkoutTimer.getTimer().pause();
			Broadcaster.dispatchEvent(new TurnOnNavPanel("LoginSignup"));
		}
		
		//Menu Command: Center on screen
		public function center(event:Event):void{
			var maxX:int = Capabilities.screenResolutionX;
			var maxY:int = Capabilities.screenResolutionY;
			var posX:int = (maxX-stage.stageWidth)/2;
			var posY:int = (maxY-stage.stageHeight)/2;
			stage.nativeWindow.x = posX;
			stage.nativeWindow.y = posY;
		}
		
		//--- TRAY  --------------------------------------------------
		//------------------------------------------------------------
		//------------------------------------------------------------
		//------------------------------------------------------------
		
		//Resize
		private function resize(maxWidth:Number, maxHeight:Number):void{
			this.maxWidth = maxWidth;
			this.maxHeight = maxHeight;
			bg.resize(maxWidth, maxHeight);
		}
		
		//Drag
		private function onMove(event:MouseEvent):void{
			stage.nativeWindow.startMove();
			event.stopPropagation();
		}
		
		//Exit App
		public function exit(event:Event):void{
			trace("saving stage.nativeWindow.x="+stage.nativeWindow.x);
			trace("saving stage.nativeWindow.y="+stage.nativeWindow.y);
			CPreferencesManager.setInt("main.window.x", stage.nativeWindow.x);
			CPreferencesManager.setInt("main.window.y", stage.nativeWindow.y);
			NativeApplication.nativeApplication.exit();
		}		
		
		//Dock app to tray
		public function dock(event:Event = null):void{
			stage.nativeWindow.visible = false;
		}	
		
		//Make visible
		public function undock(event:Event = null):void {
			//trace("PingFit.undock() stage.nativeWindow.visible=" + stage.nativeWindow.visible);
			stage.nativeWindow.visible = true;
			stage.nativeWindow.alwaysInFront = true;
			stage.nativeWindow.alwaysInFront = false;
			//orderToFront() doesn't work
			//var wasAbleToBringToFront:Boolean = stage.nativeWindow.orderToFront();
			//trace("PingFit.undock() wasAbleToBringToFront=" + wasAbleToBringToFront);
		}
		
		//Reset auto skip count
		public static function resetAutoSkipCount():void{
			PingFit.autoSkipCount = 0;
		}

		
		//Command: Toggle the next workout timer
		public function toggleTimer(e:Event):void{
			//@todo if user's working out with group shouldn't allow pause
			NextWorkoutTimer.getTimer().toggleTimer();
		}
		
		//Set justStartedNeedToShowExerciseImmediately
		public static function setJustStartedNeedToShowExerciseImmediately(justStartedNeedToShowExerciseImmediately:Boolean):void{
			PingFit.justStartedNeedToShowExerciseImmediately = justStartedNeedToShowExerciseImmediately;
		}
		
		//Set justStartedNeedToShowExerciseImmediately
		public static function getJustStartedNeedToShowExerciseImmediately():Boolean{
			return justStartedNeedToShowExerciseImmediately;
		}
		
	
		

	}
}
