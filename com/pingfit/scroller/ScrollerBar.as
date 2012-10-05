package com.pingfit.scroller {
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.events.Event;
	

	public class ScrollerBar extends Sprite {
		//--------------------------------------
		// PRIVATE INSTANCE PROPERTIES
		//--------------------------------------
		private var scrubBarTrack:*;
		private var dragHandle:*;
		private var percentChange:Number = 0
		private var usingDefaults:Boolean = true;
		private var scrollDirection:String;
		private var scrubBarColour:uint = 0xCCCCCC;//defaults
		private var scrubBarAlpha:Number = .25; //default
		private var slideBarHeight:int = 10;
		private var slideBarWidth:int = 100;
		private var dragBoxColour:uint = 0x000000;//defaults
		private var dragBoxHeight:int = 10;
		private var dragBoxWidth:int = 10;
		private var dragButtonMode:Boolean = false;//default
		private var offSetY:int = 0;
		private var offSetX:int = 0;
		private var target:Number;
		private var dragScrollEase:Number = .2


		
		//--------------------------------------
		// GETTERS/SETTERS
		//--------------------------------------

		/**
		 *	Get / Set the <code>x</code> Offset off the dragHandle from the Scroll Track. This allows you to create scrollers than have thinner or wider scrolling tracks compared to the dragHandle.
		 *	@default 0
		 *	@return int
		 */
		public function get dragHandleOffSetX():int {
			return offSetX;
		}
		/**
		* @private
		*/
		public function set dragHandleOffSetX(newOffSetX:int):void {
			offSetX = newOffSetX;
		}
		/**
		 *	Get / Set the <code>y</code> Offset off the dragHandle from the Scroll Track. This allows you to create scrollers than have thinner or wider scrolling tracks compared to the dragHandle.
		 *	@default 0
		 *	@return int
		 */
		public function get dragHandleOffSetY():int {
			return offSetY;
		}
		/**
		* @private
		*/
		public function set dragHandleOffSetY(newOffSetY:int):void {
			offSetY = newOffSetY;
		}
		
		/**
		 *	Set the slidebars colour as a hex, or uint value.
		 *	@default 0xCCCCCC
		 *	@return uint representing colour of scrollTrack/ScrollerBar
		 */
		public function get sliderBarColour():uint {
			return scrubBarColour;
		}
		/**
		* @private
		*/		
		public function set sliderBarColour(newColour:uint):void {
			scrubBarColour = newColour;
		}
		/**
		 *	Set the slidebars alpha value for its colour.
		 *	@default 1
		 *	@return Number
		 */
		public function get sliderBarAlpha():Number {
			return scrubBarAlpha;
		}
		/**
		* @private
		*/		
		public function set sliderBarAlpha(newAlpha:Number):void {
			 scrubBarAlpha = newAlpha;
		}
		/**
		 *	Set the slidebars <code>height</code> as an int pixel value. 
		 *	@return void
		 */
		public function set sliderBarHeight(newHeight:int):void {
			slideBarHeight = newHeight;
			updateProps()
		}
		/**
		 *	Set the slidebars <code>width</code> as an int pixel value.
		 *	@return void
		 */
		public function set sliderBarWidth(newWidth:int):void {
			slideBarWidth = newWidth;
			updateProps()
		}
		/**
		 *	Set the dragBars button mode for triggering the hand cursor.
		 *	@default false
		 *	@return Boolean representing whether or not to enable buttonMode. A value of <code>true</code> enables buttonMode. A value of <code>false</code> disables buttonMode.
		 */
		public function get dragBarButtonMode():Boolean {
			return dragButtonMode
		}
		/**
		* @private
		*/		
		public function set dragBarButtonMode(newBtnMode:Boolean):void {
			dragButtonMode = newBtnMode
		}
		/**
		 *	Set the dragBars <code>height</code> as an int pixel value.
		 *	@return void
		 */
		public function set dragBarHeight(newHeight:int):void {
			dragBoxHeight = newHeight;
			updateProps()
		}
		/**
		 *	Set the dragBars <code>width</code> as an int pixel value.
		 *	@return void
		 */
		public function set dragBarWidth(newWidth:int):void {
			dragBoxWidth = newWidth;
			updateProps()
		}
		/**
		 *	Set the dragBars colour as a hex or uint value.
		 *	@default 0x000000
		 *	@return uint representing colour of thumbTrack/dragBar
		 */
		public function get dragHandleColour():uint {
			return dragBoxColour;
		}
		/**
		* @private
		*/		
		public function set dragHandleColour(newDrgColour:uint):void {
			dragBoxColour = newDrgColour;
		}
		
		public function set dragEase(newDragEase:Number):void {
			dragScrollEase = newDragEase;
		}
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		/**
		*	Constructor.
		*	You can pass in existing display list assets for the scrolling track and for the dragBar. If you don't pass
		 *	in valid objects, the class defaults to drawing its own. Adjust your clips registration points to offset their positions relative to each other.
		 *	<p>See the various getter/setter methods for setting scrollTrack and dragHandle properties. To access the scrollers 
		 *	<code>percentChange</code> property, you can either use the classes getter function <code>scrollPercent</code> or add an event listener for the SCROLL_CHANGE event, 
		 *	and access the events <code>scrollPercent</code> property.</p>
		 *	<p>The class also has a setter <code>sliderDragHandlePos</code> which you can use to position the dragHandle on the scrollTrack via actionScript. A typical use for this would
		 *	be to set the dragHandle position to match the volume of a playing .mp3 at load time.</p>
		 *	<p>This class is still a work in progress!</p>
		 *	@param scrollDirection String indicating what orientation the scrollBar is in. Valid values are "horizontal" or "vertical".
		 *	@param dragHandle InteractiveObject. Use this to pass in a premade dragBar asset. Default is null.
		 *	@param scrubBarTrack InteractiveObject. Use this to pass in a premade scrollTrack asset. Default is null.
		 *	<br/><br/>
		 * <listing version="3.0">
		 *	//Create a new instance of the ScrollerBar class, set it slide horixontally and pass in two existing display assets
		 *	var mySlider:ScrollerBar = new ScrollerBar("horizontal", handleInsance, scrollTrackInstance);
		 *	</listing>
		 *	
		 *	@see #sliderBarColour
		 *	@see #sliderBarHeight
		 *	@see #sliderBarWidth
		 *	@see #dragHandleColour
		 *	@see #dragBarHeight
		 *	@see #dragBarWidth
		 *	@see #dragBarButtonMode
		 *	@see #dragHandleOffSetX
		 *	@see #dragHandleOffSetY		 
		 *	@see noponies.events.ScrollerBarEvent#SCROLL_CHANGE
		*	@example Example Useage
		 *
		 * <listing version="3.0">
		 *	var volumeSlider:ScrollerBar;
		 *  volumeSlider = new ScrollerBar("horizontal");
		 *	volumeSlider.dragHandleColour = 0x333333;
	 	 *	volumeSlider.sliderBarHeight = 5;
		 *	volumeSlider.sliderBarWidth = 200;
		 *	volumeSlider.dragBarHeight = 5;
		 *	volumeSlider.dragBarButtonMode = true;
		 *	volumeSlider.x = 10;
		 *	volumeSlider.y = 495;
		 *	addChild(volumeSlider);
		 *	volumeSlider.addEventListener(ScrollerBarEvent.SCROLL_CHANGE, changeVolume);
		 *	
		 *	function changeVolume(event:ScrollerBarEvent):void {
		 *		someintsance.volume = event.scrollPercent;
		 *	}
		 * </listing>
		 *
		 */
		public function ScrollerBar(scrollDirection:String = "vertical", dragHandle:InteractiveObject = null,scrubBarTrack:InteractiveObject = null) {
			//error checking - check if we have an appropriate orientation mode
			switch (scrollDirection.toLowerCase()){
				case "horizontal":
					//trace("it's a horizontal scroll bar");
					this.scrollDirection = scrollDirection.toLowerCase()
					break
				case "vertical":
					//trace("it's a vertical scroll bar");
					this.scrollDirection = scrollDirection.toLowerCase()
					break
				default :
					throw new Error("Problem :The direction parameter passed "+"\""+ scrollDirection+"\"" + " does not match the allowed orientation modes, which are: \"horizontal\", \"vertical\"");
			}
				
			//check to see if we have objects passed into to class to act as ui elements
			if (dragHandle != null) {
				this.dragHandle = dragHandle;
				usingDefaults = false;
			}
			if (scrubBarTrack != null) {
				this.scrubBarTrack = scrubBarTrack;
				usingDefaults = false;
			}
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, removeSlider);
			
		}
		//--------------------------------------
		// PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	Set position of dragHandle on slider bar. Set as a % of slider bar width or height, depending on what orientation mode the slider is current in. The useable value range is <code>0-1</code>.
		 *	@param Number representing the position to scroll to.
		 *	@param Boolean (Default = true) Whether or not to dispatch an event to listeners that scroll position has changed.
		 *	@param Boolean (Default = true) Whether or not to tween drag hangle to position. Listeners are updated of scroll position change.
		 *	@return void
		 */
		public function setScrollPercent(newPos:Number, update:Boolean = true, tweenVals:Boolean = true):void {
			if (newPos > 1) {
				newPos = 1;
			}
			if (newPos < 0) {
				newPos = 0;
			}
			if (dragHandle == null && scrubBarTrack == null) {
				return;
			}
			if (update) {
				if (tweenVals) {
					doTween(newPos);
				} else {

					if (scrollDirection == "horizontal") {
						dragHandle.x = usingDefaults ? (slideBarWidth-dragHandle.width)*newPos : ((slideBarWidth-dragHandle.width)*newPos)+scrubBarTrack.getBounds(stage).x;
					} else {
						dragHandle.y = usingDefaults ? (slideBarHeight-dragHandle.height)*newPos : ((slideBarHeight-dragHandle.height)*newPos)+scrubBarTrack.getBounds(stage).y;
					}
					updatePercent();
				}

			} else {
				if (scrollDirection == "horizontal") {
					dragHandle.x = usingDefaults ? (slideBarWidth-dragHandle.width)*newPos : ((slideBarWidth-dragHandle.width)*newPos)+scrubBarTrack.getBounds(stage).x;
				} else {
					dragHandle.y = usingDefaults ? (slideBarHeight-dragHandle.height)*newPos : ((slideBarHeight-dragHandle.height)*newPos)+scrubBarTrack.getBounds(stage).y;
				}
			}
		}
		 /**
		 *	Get the current scrollPercent value. Returns an Number in the 0-1 range.
		 *	@return Number representing the current scrollPercent value.
		 *	@default 0
		 */
		public function getScrollPercent():Number {
			if(scrollDirection == "horizontal") {
				usingDefaults ? percentChange = (dragHandle.x-scrubBarTrack.x) / (scrubBarTrack.width - dragHandle.width) : percentChange = (dragHandle.getBounds(stage).x - scrubBarTrack.getBounds(stage).x) / (scrubBarTrack.width - dragHandle.width);
			}else{
				usingDefaults ? percentChange = (dragHandle.y-scrubBarTrack.y) / (scrubBarTrack.height - dragHandle.height) : percentChange = (dragHandle.getBounds(stage).y - scrubBarTrack.getBounds(stage).y) / (scrubBarTrack.height - dragHandle.height);
			}
			return percentChange;
		}
		
		//--------------------------------------
		// PRIVATE METHODS
		//--------------------------------------
		
		private function init(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//these only run if we are not using passed in drag assets
			//track
			if (scrubBarTrack == null) {
				scrubBarTrack = new Sprite();
				scrubBarTrack.graphics.beginFill( scrubBarColour, scrubBarAlpha );
				scrubBarTrack.graphics.drawRect( 0, 0, slideBarWidth, slideBarHeight );
				scrubBarTrack.graphics.endFill();
				addChild(scrubBarTrack);
			} else {
				scrubBarTrack.x = this.getBounds(stage).x + offSetX;
				scrubBarTrack.y = this.getBounds(stage).y + offSetY;
				slideBarHeight = scrubBarTrack.height;
				slideBarWidth = scrubBarTrack.width;
			}
			//drag handle
			if (dragHandle == null) {
				
				dragHandle = new Sprite();
				dragHandle.graphics.beginFill( dragBoxColour, 1 );
				dragHandle.graphics.drawRect( 0, 0, dragBoxWidth, dragBoxHeight );
				dragHandle.graphics.endFill();
				addChild(dragHandle);
				dragHandle.y = offSetY;
				dragHandle.x = offSetX;
			} else {
				
				dragHandle.x = this.getBounds(stage).x + offSetX;
				dragHandle.y = this.getBounds(stage).y + offSetY;
			}

			//add event listeners
			dragHandle.buttonMode = dragButtonMode
			dragHandle.addEventListener( MouseEvent.MOUSE_DOWN, dragHandlePress );
			dragHandle.addEventListener(MouseEvent.ROLL_OUT, dragHandleOut);
			dragHandle.addEventListener(MouseEvent.ROLL_OVER, dragHandleOver);
			stage.addEventListener(MouseEvent.MOUSE_UP, dragHandleRelease );
			scrubBarTrack.addEventListener(MouseEvent.MOUSE_DOWN, sliderBarClick);
		}
		
		private function updateProps():void{
			if (scrubBarTrack != null && usingDefaults) {
				scrubBarTrack.width = slideBarWidth;
				scrubBarTrack.height = slideBarHeight;
			}
			if (dragHandle != null && usingDefaults) {
				dragHandle.width = dragBoxWidth;
				dragHandle.height = dragBoxHeight;
			}
		}
		//--------------------------------------
		// UPDATE SCROLL CHANGE VAR - DISPATCH SCROLL CHANGE EVENT
		//--------------------------------------
		//update track percent, and dispatch event. Could also be done using a getter......
		private function updatePercent(event:MouseEvent = null):void {
			if(scrollDirection == "horizontal") {
				usingDefaults ? percentChange = (dragHandle.x-scrubBarTrack.x) / (scrubBarTrack.width - dragHandle.width) : percentChange = (dragHandle.getBounds(stage).x - scrubBarTrack.getBounds(stage).x) / (scrubBarTrack.width - dragHandle.width);
			}else{
				usingDefaults ? percentChange = (dragHandle.y-scrubBarTrack.y) / (scrubBarTrack.height - dragHandle.height) : percentChange = (dragHandle.getBounds(stage).y - scrubBarTrack.getBounds(stage).y) / (scrubBarTrack.height - dragHandle.height);
			}
			
			dispatchEvent(new ScrollerBarEvent(ScrollerBarEvent.SCROLL_CHANGE,true, true, percentChange));
		}
		
		//--------------------------------------
		// HANDLE CLICK ON THUMB TRACK
		//--------------------------------------		
		private function sliderBarClick(event:MouseEvent):void {
			scrollDirection == "horizontal" ? doTween(event.localX/scrubBarTrack.width) : doTween(event.localY/scrubBarTrack.height);
		}
		
		//--------------------------------------
		// HANDLE DRAGGING THE DRAG HANDLE
		//--------------------------------------
		//set up new rects to constrain drag etc
		//the offsets in here have not really been tested!!
		private function dragHandlePress( event:MouseEvent ):void {
			if(scrollDirection == "horizontal") {
				usingDefaults ? dragHandle.startDrag( false, new Rectangle( 0, scrubBarTrack.y+offSetY, scrubBarTrack.width-dragHandle.width, 0)) : dragHandle.startDrag( false, new Rectangle( scrubBarTrack.getBounds(stage).x + offSetX, scrubBarTrack.getBounds(stage).y + offSetY, scrubBarTrack.width-dragHandle.width, 0));
			}else{
				usingDefaults ? dragHandle.startDrag( false, new Rectangle( 0+offSetX, scrubBarTrack.y, 0, scrubBarTrack.height-dragHandle.height)) : dragHandle.startDrag( false, new Rectangle( scrubBarTrack.getBounds(stage).x + offSetX, scrubBarTrack.getBounds(stage).y +offSetY, 0, scrubBarTrack.height-dragHandle.height));
			}
			dragHandle.dispatchEvent(new ScrollerBarEvent(ScrollerBarEvent.DRAG_PRESS,true, true, percentChange));

			stage.addEventListener( MouseEvent.MOUSE_MOVE, updatePercent );
		}
		
		//--------------------------------------
		// HANDLE DRAG HANDLE RELEASE
		//--------------------------------------
		private function dragHandleRelease( event:MouseEvent ):void {
			dragHandle.stopDrag();
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, updatePercent );
			dragHandle.dispatchEvent(new ScrollerBarEvent(ScrollerBarEvent.DRAG_RELEASE,true, true, undefined));
		}
		
		//--------------------------------------
		// HANDLE DRAG ROLLOVER AND ROLLOUT - REDISPATCH EVENT
		//--------------------------------------		
		private function dragHandleOut(event:MouseEvent):void{
			dragHandle.dispatchEvent(new ScrollerBarEvent(ScrollerBarEvent.DRAG_ROLL_OUT,true, true, undefined));
		}
		
		private function dragHandleOver(event:MouseEvent):void{
			dragHandle.dispatchEvent(new ScrollerBarEvent(ScrollerBarEvent.DRAG_ROLL_OVER,true, true, undefined));
		}
		
		//--------------------------------------
		// HANDLE SLIDERBAR ROLLOVER AND ROLLOUT - REDISPATCH EVENT
		//--------------------------------------				
		private function sliderBarOver(event:MouseEvent):void {
			dispatchEvent(event);
		}
		
		private function sliderBarOff(event:MouseEvent):void {
			dispatchEvent(event);
		}
		
		//--------------------------------------
		// TWEENING METHOD
		//--------------------------------------
		private function doTween(targetPos:Number):void{
			 
			if(scrollDirection == "horizontal") {
				target = usingDefaults ? (slideBarWidth-dragHandle.width)*targetPos : ((slideBarWidth-dragHandle.width)*targetPos)+scrubBarTrack.getBounds(stage).x
			}else{
				target = usingDefaults ? (slideBarHeight-dragHandle.height)*targetPos : ((slideBarHeight-dragHandle.height)*targetPos)+scrubBarTrack.getBounds(stage).y
			}
				//add enterframe handler
			addEventListener(Event.ENTER_FRAME, tween);
			//update percent
			updatePercent();
		}
		
		private function tween(event:Event):void{
			if(scrollDirection == "horizontal") {
				usingDefaults ? dragHandle.x+= Number(((target-dragHandle.x)) * dragScrollEase) : dragHandle.x+= Number(((target-dragHandle.x)) * dragScrollEase);
			}else{
				usingDefaults ? dragHandle.y+=Number(((target-dragHandle.y)) * dragScrollEase) : dragHandle.y+=Number(((target-dragHandle.y)) * dragScrollEase);
			}
			//update the percent number
			updatePercent()
			//dampen tween, so that it technically completes and set clip to final position
			var n:Number = scrollDirection == "horizontal" ? dragHandle.x - target : dragHandle.y - target;
			
			if (n < 0)  n = -n;
			if (n < .5) {
				scrollDirection == "horizontal" ? dragHandle.x = target : dragHandle.y = target;
				removeEventListener(Event.ENTER_FRAME, tween);
				updatePercent();
				
			}
		}

		//--------------------------------------
		// REMOVED FROM STAGE - DO THE CLEANUP
		//--------------------------------------
		private function removeSlider(event:Event):void {
			try {
				dragHandle.removeEventListener( MouseEvent.MOUSE_DOWN, dragHandlePress );
				stage.removeEventListener( MouseEvent.MOUSE_UP, dragHandleRelease );
				stage.removeEventListener( MouseEvent.MOUSE_MOVE, updatePercent );
				dragHandle.removeEventListener(MouseEvent.ROLL_OUT, dragHandleOut);
				dragHandle.removeEventListener(MouseEvent.ROLL_OVER, dragHandleOver);
				removeChild(scrubBarTrack);
				removeChild(dragHandle);
				removeEventListener(Event.REMOVED_FROM_STAGE, removeSlider);
				removeEventListener(Event.ENTER_FRAME, tween);
				
			} catch (error:Error) {
				trace("error removing slider content "+error);
			}
		}

	}

	
}