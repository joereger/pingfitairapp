//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2008 __noponies__
// 
////////////////////////////////////////////////////////////////////////////////

package noponies.ui {
		import flash.display.InteractiveObject;
		import flash.display.Sprite;
		import flash.events.Event;
		import flash.events.MouseEvent;
		import flash.events.KeyboardEvent;
		import flash.text.TextField;
		import flash.text.TextFormat;
		import flash.text.TextLineMetrics;
		import flash.text.TextFieldType;
    	import flash.text.TextFieldAutoSize;
    	import flash.text.AntiAliasType;
		import flash.geom.Point;
		import flash.geom.Rectangle;
		import flash.filters.BlurFilter;
		import flash.text.StyleSheet;
		
		//noponies Class Imports
		import noponies.ui.NpTextScrollBar;
		import noponies.events.NpTextScrollBarEvent;
		//mac mouseWheel support
		//import com.pixelbreaker.ui.osx.MacMouseWheel;
		//http://blog.pixelbreaker.com/flash/as30-mousewheel-on-mac-os-x/
		
	/**
	*	<p>The NpTextScroller Class is designed to enable you to scroll a block of text via either the mouseWheel, keyBoard or via a slider bar. The Class itself does not handle any loading in of content. You must
	*	provide the class with the text for it to scroll.</p>
	*	<p>The class is scrollRect based. It supports html text, styled by either a TextFormat Object, or a CSS Object. The class will autohide the scrollBar if there is not enough text to scroll, and reveal it again, if more text is added, making a scroll operation
	*	possible.<p>
	*	<p>If you need to access the scrollBars widgets, review the events dispatched by the <code>NpTextScrollBarEvent</code> class.</p>
	*	<p><em>This class uses the MacMouseWheel Class from <a href"http://blog.pixelbreaker.com/flash/as30-mousewheel-on-mac-os-x/">Pixelbreaker</a> to enable mouseWheel scrolling on the mac platform.
	*	Please visit Pixelbreakers site for any issues etc you may have with this class! MouseWheel scrolling wont work in the IDE when authoring on a Mac! You must debug your swf for scrollwheel support, or view in a browser.</em></p>
	* 	<br /><br />
	*	<b>Author:</b> noponies - <a href="http://www.blog.noponies.com/" target="_blank">www.blog.noponies.com</a><br />
	* 	<b>Class version:</b> 1<br />
	* 	<b>Actionscript version:</b> 3.0 Player Version 9.0.28<br />
	* 	<b>Copyright:</b>
	* 	License<br /> 
	* 	<a href="http://www.blog.noponies.com/terms-and-conditions" target="_blank">http://www.blog.noponies.com/terms-and-conditions</a><br />
	* 	<br />
	* 	<b>Date:</b> 04 Jan 2009<br />
	*/
	public class NpTextScroller extends Sprite {
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		private var _sWidth:int = 300;	
		private var _sHeight:int = 300;
		private var _scrollField:TextField;
		private var _scrollerAdded:Boolean = false;
		private var _scrollFormat:TextFormat;
		private var _sRect:Rectangle;
		private var _textScrollBar:NpTextScrollBar;
		private var _cacheAsBit:Boolean = true;
		private var __blurAmount:Number = .4;
		private var _blur:BlurFilter = new BlurFilter();
		private var _useEmbeddedFonts:Boolean = false;
		private var _blurScroll:Boolean = true;
		private var _blurQual:int = 3;
		private var _textRect:Rectangle;
		private var _textCrispness:Number = 400;
		private var _scrollEaseing:Number = .2;
		private var _useWheelMouseScroll:Boolean = false;
		private var _mouseWheelMoveAmount:int = 8;
		private var _useKeyScroll:Boolean = true;
		private var _keyScrollAmount:Number = 0.15
		private var _targPos:Number = 0;
		private var _mPos:int = 0;
		private var _textRectHeight:int;
		private var _sAmount:Number = 0;
		private var _mScrolling:Boolean = false;
		
		//slider values
		private var _dragBarAsset:InteractiveObject
		private var _scrubBarColour:uint = 0x000000;//defaults
		private var _slideBarHeight:int = 300;
		private var _slideBarWidth:int = 10;
		private var _dragBoxColour:uint = 0xFFFFFF;//defaults
		private var _dragBoxHeight:int = 30;
		private var _dragBoxWidth:int = 10;
		private var _dragButtonMode:Boolean = true;//default
		private var _offSetX:int = 0;
		private var _sliderBarX:int = 0; //default
		private var _sliderBarY:int = 0;
		
		public function getTextRectHeight(){
			return _textRectHeight;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------	
		/**
		 *	Get / Set whether or not the text can be scrolled by a user focusing on the text field and then pressing either the UP or DOWN arrow keys.
		 *	@default true
		 *	@return Boolean
		 */
		public function get keyScrolling():Boolean {
			return _useKeyScroll;
		}
		/**
		* @private
		*/
		public function set keyScrolling(newUseKeyScroll:Boolean):void {
			_useKeyScroll = newUseKeyScroll;
		}
		/**
		 *	Get / Set the amount the text will scroll with each keypress. By default it scrolls <code>15%</code> of the text field with each press. Greater numbers
		 *	will increase scrolling speed. Valid number range is <code>0-1</code>. Easing is controlled by the <code>scrollEase</code> property.
		 *	@default 0.15
		 *	@return Number
		 */
		public function get keyScrollingAmount():Number {
			return _keyScrollAmount;
		}
		/**
		* @private
		*/
		public function set keyScrollingAmount(newAmount:Number):void {
			_keyScrollAmount = newAmount;
		}
		/**
		 *	Get / Set whether or not the text can be scrolled by a user scrolling their mouse.
		 *	@default true
		 *	@see #mouseWheelScrollAmount
		 *	@return Boolean
		 */
		public function get mouseWheelScrolling():Boolean {
			return _useWheelMouseScroll;
		}
		/**
		* @private
		*/
		public function set mouseWheelScrolling(newUseMouseScroll:Boolean):void {
			_useWheelMouseScroll = newUseMouseScroll;
		}
		/**
		 *	Get / Set the amount the text will scroll with each turn of a users mouse wheel. Greater numbers will create faster scrolls.
		 *	@default 5
		 *	@return int
		 */
		public function get mouseWheelScrollAmount():int {
			return _mouseWheelMoveAmount;
		}
		/**
		* @private
		*/
		public function set mouseWheelScrollAmount(newMouseScrollAmount:int):void {
			_mouseWheelMoveAmount = newMouseScrollAmount;
		}
		/**
		 *	Get / Set the easing for scrolling of the NpTextScroller's and the slider bars scrolling.
		 *	@default .2
		 *	@return Number
		 */
		public function get scrollEase():Number {
			return _scrollEaseing;
		}
		/**
		* @private
		*/
		public function set scrollEase(newScrollMaxSpeed:Number):void {
			_scrollEaseing = newScrollMaxSpeed;
		}
		/**
		 *	Get / Set the width of the scrollable area.
		 *	@default 300
		 *	@return int
		 */
		public function get scrollWidth():int {
			return _sWidth;
		}
		/**
		* @private
		*/
		public function set scrollWidth(newWidth:int):void {
			_sWidth = newWidth;
		}
		/**
		 *	Get / Set the height of the scrollable area.
		 *	@default 500
		 *	@return int
		 */
		public function get scrollHeight():int {
			return _sHeight;
		}
		/**
		* @private
		*/
		public function set scrollHeight(newHeight:int):void {
			_sHeight = newHeight;
		}
		/**
		 *	Get / Set if you want to blur the text as it scrolls. The amount of blur depends on how far the text has to scroll. Bigger distances
		 * equate to bigger blurs.
		 *	<p><em>Be aware that this WILL affect peformance</em></p>
		 *	@default false
		 *	@return Boolean
		 *	@see #textBlurQuality
		 */
		public function get textScrollBlur():Boolean {
			return _blurScroll
		}
		/**
		* @private
		*/
		public function set textScrollBlur(newBlur:Boolean):void {
			_blurScroll = newBlur
		}
		
		/**
		 *	Get / Set the quality of the blur if you have enabled the <code>textScrollBlur</code> property. Higher numbers set higher quality blurs but degrade performance!
		 *	<p><em>Be aware that this high will affect peformance</em></p>
		 *	@default 3
		 *	@return int
		 *	@see textScrollBlur
		 */
		public function get textBlurQuality():int {
			return _blurQual
		}
		/**
		* @private
		*/
		public function set textBlurQuality(newBlurQual:int):void {
			_blurQual = newBlurQual
		}
		
		/**
		 *	Get / Set the amount of the blurring if you have enabled the <code>textScrollBlur</code> property. Higher numbers create greater amounts of blur!
		 *	<p>Blurring is a proportion of the distance the text has to travel. The effect of this property is to divide that amount to arrive at the level of blur.
		 *	So, if you set a amount of <code>.5</code> then the blur will be calculated as .5 of that distance.</p>
		 *	@default .4
		 *	@return Number
		 *	@see textScrollBlur
		 */
		public function get textBlurAmount():Number {
			return __blurAmount
		}
		/**
		* @private
		*/
		public function set textBlurAmount(newBlurAmount:Number):void {
			__blurAmount = newBlurAmount
		}
		/**
		 *	Get / Set whether or not to cache the scrolling content as a whole as a bitmap. This increases performance, but you will suffer a performance hit if your content
		 *	visually changes etc. 
		 *	<p>If you have enabled the <code>textScrollBlur</code> property, the scrolling content will be bitmap cached when it is _blurred, and returned to is previous cache state
		 *	when the _blur has finished.</p>
		 *	@default true
		 *	@return Boolean
		 */
		public function get scrollAsBitmap():Boolean {
			return _cacheAsBit
		}
		/**
		* @private
		*/
		public function set scrollAsBitmap(newCachePanelAtBit:Boolean):void {
			_cacheAsBit = newCachePanelAtBit
		}
		/**
		 *	Get / Set a text navigation fonts AnitAliasing sharpness value. Set this if you are using a bitmap typeface. Min -400, Max 400
		 *	@default 400
		 *	@return Number
		 */
		public function get textSharpness():Number {
			return _textCrispness
		}
		/**
		* @private
		*/
		public function set textSharpness(newSharp:Number):void {
			_textCrispness = newSharp
		}
		/**
		 *	Get / Set whether or not to use embedded fonts. You must set this property if you are wanting to use an embedded font.
		 *	@param Boolean A value of <code>false</code> turns off the use of embedded fonts. A value of <code>true</code> enables the use of embedded fonts.
		 *  @default false
		 *	@return Boolean
		 *	@see #textSharpness
		 *	@see #fontFormat
		 */
		public function set useEmbeddedFont(embeddedFont:Boolean):void{
			_useEmbeddedFonts = embeddedFont
		}
		
		/**
		 *	Get a reference to the sliderBars instance. You can then use this to set additional properties of the sliderBar, outside of what is available directly
		 *	through this class.
		 *	@return Object
		 */
		public function get sliderInstance():Object{
			return _textScrollBar;
		}
		/**
		 *	Set the dragBars <em>dragHandle</em> <code>height</code> as an int pixel value.
		 *	@default 30
		 *	@return void
		 */
		public function set dragBarAsset(newBar:InteractiveObject):void {
			_dragBarAsset = newBar;
		}
		
		/**
		 *	Set the dragBars <em>dragHandle</em> <code>height</code> as an int pixel value.
		 *	@default 30
		 *	@return void
		 */
		public function set dragBarHeight(newHeight:int):void {
			_dragBoxHeight = newHeight;
		}
		/**
		 *	Set the dragBars <em>dragHandle</em> <code>width</code> as an int pixel value.
		 *	@default 10
		 *	@return void
		 */
		public function set dragBarWidth(newWidth:int):void {
			_dragBoxWidth = newWidth;
		}
		/**
		 *	Set the scrollBars dragHandle <em>dragHandle</em> colour as a hex or uint value.
		 *	@default 0xFFFFFF
		 *	@return
		 */
		public function set dragHandleColour(newDrgColour:uint):void {
			_dragBoxColour = newDrgColour;
		}
		/**
		 *	Get / Set the <code>x</code> Offset off the dragHandle from the scrollBars scrollTrack. This allows you to create scrollers than have thinner or wider scrolling tracks compared to the dragHandle.
		 *	@default 0
		 *	@return int
		 */
		public function set dragHandleOffSetX(newOffSetX:int):void {
			_offSetX = newOffSetX;
		}
		/**
		 *	Set the scrollBars <em>scrollTrack</em> colour as a hex, or uint value. 
		 *	@default 0x000000
		 *	@return 
		 */	
		public function set sliderBarColour(newColour:uint):void {
			_scrubBarColour = newColour;
		}
		/**
		 *	Set the slidebars <em>scrollTrack</em> <code>height</code> as an int pixel value. 
		 *	@default The height of the <code>scrollHeight</code> property.
		 *	@see #scrollHeight
		 *	@return void
		 */
		public function set sliderBarHeight(newHeight:int):void {
			_slideBarHeight = newHeight;
		}
		/**
		 *	Set the scrollBars <em>scrollTrack</em> <code>width</code> as an int pixel value.
		 *	@default 10
		 *	@return void
		 */
		public function set sliderBarWidth(newWidth:int):void {
			_slideBarWidth = newWidth;
		}
		/**
		 *	Set the scrollBars <code>x</code> as an int pixel value.
		 *	@default 300
		 *	@return void
		 */
		public function set sliderXPos(newX:int):void {
			_sliderBarX = newX;
		}
		
		/**
		 *	Set the scrollBars <code>y</code> as an int pixel value.
		 *	@default 0
		 *	@return void
		 */
		public function set sliderYPos(newY:int):void {
			_sliderBarY = newY;
		}
	
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		/**
		 * 	Call the various methods associated with this class before you add it to the stage.
		 *	<p>If you want to create rollOver and rollOut colour changes on the scrollBar, listen to the various events dispatched by the <code>NpTextScrollBar</code> class.</p>
		 *	@param InteractiveObject Object you would like to use as a drag handle, rather than say the default rectangle or square. The only property that has any effect on the position of the dragHandle when you
		 *	use your own custom asset is the <code>dragHandleOffSetX</code> property. Although, you can control where the dragHandle sits, via its registration point.
		 * 	don't attempt to 
		 * 	@example Demo Constructor with scroll _blurring turned on and mouseWheel scrolling enabled
		 * 	<listing version="3.0">
		 *  //Instantiate class first
		 * 	var textScroll:NpTextScroller
		 * 	textScroll = new NpTextScroller()
		 *	textScroll.scrollWidth = 300;
		 *	textScroll.scrollHeight = 300;
		 *	textScroll.sliderXPos = 310;
		 *	textScroll.sliderYPos = 0;
		 *	textScroll.dragHandleColour = 0xFFCCFF;
		 *	textScroll.sliderBarWidth = 10;
		 *	textScroll.textScrollBlur = true
		 *	textScroll.mouseWheelScrolling = true
		 *	textScroll.addScrollText(myTextLoader.loadedText)
		 *	textScroll.y = textScroll.x = 10
		 *	addChild(textScroll)
		 * </listing>
		 */
		public function NpTextScroller(_dragBarAsset:InteractiveObject = null){
			this._dragBarAsset = _dragBarAsset;
			_textScrollBar = new NpTextScrollBar("vertical",_dragBarAsset);
			_scrollField = createDynTextField("");
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			addChild(_scrollField);
		}
		
		//--------------------------------------
		//
		//  PUBLIC METHODS
		//
		//--------------------------------------
		/**
		 *	<p>The addScrollText method is designed to allow for you to add text into the NpTextScroller Class.</p>
		 *	<p>Calling this method will destroy any existing content you may have within the Class. To append to existing scrolled text, see the <code>appendScrollText</code> method.
		 *	@param String Representing the text you wish to add to the scrolling text.
		 *	@param Object Either a TextFormat or a StyleSheet Object, that you wish to use to style your text. These are mutally exclusive, with it being either one or the other.
		 *	@see #appendScrollText()
		 *	@return void
		 */
		 
		 public function addScrollText(textToScroll:String, tFormat:Object = null):void {
			if (_scrollField.text !="") _scrollField.text = ""
			//turn off scroll Rect, if its applied
			_scrollField.scrollRect = null;

			//remove any CSS formatting, if we are loading in text to an already existing text field
			if(_scrollField.styleSheet !=null) _scrollField.styleSheet = null;
			
			if(tFormat is TextFormat) {
				_scrollFormat = tFormat as TextFormat;
				_scrollField.defaultTextFormat = _scrollFormat;
			}
			
			if(tFormat is StyleSheet) {
				_scrollField.styleSheet = tFormat as StyleSheet;
			}
			
			_scrollField.htmlText = textToScroll;
			
			_scrollField.width = _sWidth;
			
			//store rect of textField before we apply scrollRect
			_textRect = _scrollField.getRect(this);
			_sRect = new Rectangle(0,0, _sWidth, _sHeight);
			//apply scrollRect
			_scrollField.scrollRect = _sRect;
			
			//find the descender value of the last line of text
			var metrics:TextLineMetrics = _scrollField.getLineMetrics(_scrollField.numLines-1);
			
			//find our height of the text. Because we are using a scrollRect, we need to use the textHeight, plus the metrics.descent of
			//the last line to find the actual text height. As textHeight does not include any descenders. We also add 1 px for good measure.
			_textRectHeight = _scrollField.textHeight+metrics.descent+1;
			
			//check to see if we are cacheing the content
			_cacheAsBit ? _scrollField.cacheAsBitmap = true : _scrollField.cacheAsBitmap = false;
			//style the slider
			if(!_scrollerAdded) styleSlider();
			//check to see if we need to make the scrollBar visible, if its not already visible
			if(_textRectHeight > _sHeight) {
				_textScrollBar.visible = true;
				if(_dragBarAsset!=null){
					_dragBarAsset.visible = true;
				}
			}else{
				_textScrollBar.visible = false;
				if(_dragBarAsset!=null){
					_dragBarAsset.visible = false;
				}
			}
		}
		
		//--------------------------------------
		// APPEND TEXT TO SCROLLER
		//--------------------------------------	
		/**
		 *	<p>The appendScrollText method is designed to allow for you to add text into an already existing block of scrolling text. You
		 *	have the option of choosing if the text is placed at the beginning of the text block or at its end.</p>
		 *	<p>Calling this method causes the scrollBar to update it's position.</p>
		 *	@param String Representing the text you wish to add to the scrolling text.
		 *	@param String (optional) String representing where you want to place the text in the scrolling text. The default is <code>"end"</code>. Any other value will 
		 *	place text at the start of the scrolling text.
		 *	@return void
		 */
		public function appendScrollText(textToAdd:String, pos:String = "end"):void {
			//cant use standard textField methods due to the possible use of CSS
			var oldText:String
			
			if(pos=="end"){
				oldText = _scrollField.htmlText + textToAdd 
				_scrollField.text = "";
				_scrollField.htmlText = oldText;
			}else{
				oldText = textToAdd + _scrollField.htmlText;
				_scrollField.text = "";
				_scrollField.htmlText = oldText;
			}
			//get the pos of text
			var metrics:TextLineMetrics = _scrollField.getLineMetrics(_scrollField.numLines-1);
			//find out how far we have to scroll
			var tempPos:Number = 1-_textRectHeight/_scrollField.textHeight;
			_textRectHeight = _scrollField.textHeight+metrics.descent;
			
			//check to see if we need to make the scrollBar visible, if its not already visible
			if(_textRectHeight > _sHeight) {
				_textScrollBar.visible = true;
				if(_dragBarAsset!=null){
					_dragBarAsset.visible = true;
				}
			}else{
				_textScrollBar.visible = false;
				if(_dragBarAsset!=null){
					_dragBarAsset.visible = false;
				}
			}
			
			if(_textRectHeight > _sHeight) scrollTextToPoint(_textScrollBar.getScrollPercent()+tempPos);
		}
		
		//--------------------------------------
		// SCROLL TEXT TO POINT METHOD
		//--------------------------------------	
		/**
		 *	<p>The scrollTextToPoint method is designed to allow for you to programatically scroll the text to a point.
		 *	<p>Values are as a percentage of the total text to scroll</p>
		 *	@param Number Representing the percentage you want to scroll the text to.
		 *	@param Boolean Represents whether or not you want to tween the scroller into its new position <code>true</code>, or jump with no tween <code>false</code> (default).
		 *	@return void
		 */		
		public function scrollTextToPoint(posToScrollTo:Number, tweenVals:Boolean = false):void {
			if(_textRectHeight < _sHeight) return
			if (! this.willTrigger(Event.ENTER_FRAME) ) {
				this.addEventListener(Event.ENTER_FRAME,entFrameScroll);
			}
			var pos:Number = (posToScrollTo > 1) ? 1 : posToScrollTo;
			//scroll the text via a call to the scrollBars setScrollPercent method
			_textScrollBar.setScrollPercent(pos, true, tweenVals);
		}
		//--------------------------------------
		// ADJUST SCROLLBOX METHOD
		//--------------------------------------	
		/**
		 *	<p>The adjustScrollBox method is designed to allow for you to change the scrollRectangle of the text at runtime. Generally this method is designed for changing the scrollRects height, although
		 *	you can also set its width. The method has two booleans as arguments that control how changes are applied to both the scrollRect, and to the scrollBar. The first controls whether or not to
		 *	set the scrolled texts width to match the new passed in width value for the scrollRect. The second, controls whether or not to redraw the scrollBar. This allows for you to change the scrollBars
		 *	height, width etc before you call this method, adjusting the scrollBar inline with the dimensions of the scrollRect.
		 *	@param w int Representing width of the scroll box.
		 *	@param h int Representing the height of the scroll box.
		 *	@param changeTextWidth Boolean Represents if you want to adjust the texts width inline with the new scrollRect width. Default is false.
		 *	@param changeScroller Boolean Represents if you want to adjust the scroll bars properties. Default is false.
		 *	@return void
		 */			
		public function adjustScrollBox(w:int, h:int, changeTextWidth:Boolean = false, changeScroller:Boolean = false):void {
			//test if we have a scroller
			if(!_scrollerAdded) return;
			//set width height values for class
			_sWidth = _sRect.width = w;
			_sHeight = _sRect.height = h;
			
			if(changeTextWidth){
				_scrollField.width = w;
				var metrics:TextLineMetrics = _scrollField.getLineMetrics(_scrollField.numLines-1);
				_textRectHeight = _scrollField.textHeight+metrics.descent+1;
			}

			if(changeScroller){
				styleSlider();
			}
			
			//force a redraw of the scrollRect
			scrollTextY(_sAmount)
			
			//check to see if we need to make the scrollBar visible, if its not already visible
			if(_textRectHeight > _sHeight) {
				_textScrollBar.visible = true;
				if(_dragBarAsset!=null){
					_dragBarAsset.visible = true;
				}
			}else{
				_textScrollBar.visible = false;
				if(_dragBarAsset!=null){
					_dragBarAsset.visible = false;
				}
			}
		}
		
		//--------------------------------------
		//
		//  EVENT HANDLERS
		//
		//--------------------------------------
		
		//--------------------------------------
		// ADDED TO STAGE HANDLER
		//--------------------------------------			
		private function addedToStageHandler(event:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			//are we gonna use the mouseWheel
			if(_useWheelMouseScroll) {
				//MacMouseWheel.setup(this.stage);
				_scrollField.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			}
			//are we gonna use keyboard scrolling
			if(_useKeyScroll){
			 _scrollField.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			}
		}
		
		//--------------------------------------
		// KEYBOARD SCROLLING
		//--------------------------------------	
		//Simple keyboard scrolling, using the up and down arrows.

		private function keyDownHandler(event:KeyboardEvent):void{
			if(_textRectHeight<_sHeight) return;
			   
			switch(event.keyCode){
				case 40:
				_textScrollBar.setScrollPercent(_textScrollBar.getScrollPercent()+_keyScrollAmount, true, true);
				break;
				case 38:
				_textScrollBar.setScrollPercent(_textScrollBar.getScrollPercent()-_keyScrollAmount, true, true);
				break;
			}
		}
		
		//--------------------------------------
		// MOUSEWHEEL SCROLLING
		//--------------------------------------	
		//The enterframe handler here deals with the different values passed from mouseWheel changes.

		private function mouseWheelHandler(event:MouseEvent):void{
			if(_textRectHeight < _sHeight) return
				if (!this.willTrigger(Event.ENTER_FRAME)) this.addEventListener(Event.ENTER_FRAME,entFrameScroll);
				_mScrolling = true;
				if( _sRect.y >= 0 && _sRect.y <= (_textRectHeight - _sHeight)){
				_sAmount = (_sRect.y + -event.delta * _mouseWheelMoveAmount) / (_textRectHeight - _sHeight);
				}else{
					return;
				}
		}

		//--------------------------------------
		// SCROLL TRACK SCROLLING
		//--------------------------------------	
		
		//The enterframe handler here deals with the different values passed from the scrolling track.

		//--------------------------------------
		// ENTERFRAME HANDLER
		//--------------------------------------	
		private function entFrameScroll(event:Event):void{
			scrollTextY(_sAmount);
		}
		//--------------------------------------
		//  HANDLE A CLICK ON THE SCROLL BAR
		//--------------------------------------	
		private function scrollText(event:NpTextScrollBarEvent = null):void {
			if(_textRectHeight<_sHeight) return;
			if(event != null) _sAmount = event.scrollPercent, scrollTextY(_sAmount);
			if (! this.willTrigger(Event.ENTER_FRAME)) this.addEventListener(Event.ENTER_FRAME,entFrameScroll);
			
		}
		
		//--------------------------------------
		//  REMOVED FROM STAGE
		//--------------------------------------			
		private function removedFromStageHandler(event:Event):void {
			try {
				removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler)
				if (this.willTrigger(Event.ENTER_FRAME)) {
					this.removeEventListener(Event.ENTER_FRAME,entFrameScroll);
				}
			} catch (error:Error) {
				trace("error removing text scroller content " + error);
			}
		}
		
		//--------------------------------------
		//
		//  PRIVATE METHODS
		//
		//--------------------------------------		
		//--------------------------------------
		// CREATE THE SLIDER
		//--------------------------------------		
		//this method pulls in its values either from what has been set via the classes setter methods or via the classes defaults
		private function styleSlider():void{
			_textScrollBar.x = _sliderBarX;
			_textScrollBar.y = _sliderBarY;
			_textScrollBar.sliderBarColour = _scrubBarColour;
			_textScrollBar.sliderBarHeight = _slideBarHeight;
			_textScrollBar.sliderBarWidth = _slideBarWidth;
			_textScrollBar.dragEase = _scrollEaseing;
			
			if(_dragBarAsset != null){
				_textScrollBar.dragHandleOffSetX = _offSetX;
				_textScrollBar.dragBarHeight = _dragBarAsset.height;
				_textScrollBar.dragBarWidth = _dragBarAsset.width;
				_textScrollBar.dragBarButtonMode = _dragButtonMode;
			}else{
				_textScrollBar.dragHandleColour = _dragBoxColour;
				_textScrollBar.dragBarHeight = _dragBoxHeight;
				_textScrollBar.dragBarWidth = _dragBoxWidth;
				_textScrollBar.dragHandleOffSetX = _offSetX;
				_textScrollBar.dragBarButtonMode = _dragButtonMode;
			}
			if(!_scrollerAdded){
				addChild(_textScrollBar);
				addEventListener(NpTextScrollBarEvent.SCROLL_CHANGE, scrollText);
			}
			_scrollerAdded = true
		}
		
		//--------------------------------------
		//  SCROLL THE TEXT
		//--------------------------------------	
		private function scrollTextY(_nPos:Number):void {
			_mPos = _sRect.height * _nPos;
			
			//quick ABS
			var n:Number = _sRect.y - _targPos;
			if (n < 0)  n = -n;
			
			//calc where we are gonna move to
			_targPos = (_mPos/(_sHeight/(_textRectHeight - _sHeight)));
			
			//bounds testing
			if(_targPos > _textRectHeight - _sHeight) {
				_targPos = _textRectHeight - _sHeight;
			}else if (_targPos < 0) {
				_targPos = 0;
			}
			
			//turn on _blurring, if its being used and only if we have a big enough movement in the text
			 if(_blurScroll &&  n > .5) {
				 _blur.blurY = (n * __blurAmount)*.8;
				 _blur.blurX = 0;
				 _blur.quality = _blurQual;
				 _scrollField.filters=[_blur];
			 }
			
			 if(_blurScroll &&   n < .5) _scrollField.filters=[];
			 
			//adjust the scrollRects y
			_sRect.y += Number(((_targPos - _sRect.y)) * _scrollEaseing);
			
			//reapply the scrollRect
			_scrollField.scrollRect = _sRect;
			
			//update drag thumb pos if we are scrolling via the mousewheel
			if(_mScrolling) _textScrollBar.setScrollPercent((_sRect.y / (_textRectHeight - _sHeight)), false);
			
			 //if we are below .5 px movements, kill the enterframe
			if (n < .5) killEntFrame();
		}
		
		//kill the enterframe
		private function killEntFrame():void{
			this.removeEventListener(Event.ENTER_FRAME, entFrameScroll);
			if(_blurScroll) {
				 _blur.blurY = 0;
				_scrollField.filters=[];
			}
			_mScrolling = false;
			//set scrollRect to int value, removes any rounding errors caused by the easing of the texts movement
			_sRect.y = int(_targPos);
			_scrollField.scrollRect = _sRect;
		}
		
		//-------------------------------------- 
		// TEXT FIELD CREATING FUNCTION
		//-------------------------------------- 
		//fileText = createDynTextField("Selected File: " + fileNameString)
		private function createDynTextField(txt:String):TextField {
			var tf:TextField = new TextField()
			tf.type=TextFieldType.DYNAMIC;
			tf.autoSize=TextFieldAutoSize.LEFT;
			tf.embedFonts = _useEmbeddedFonts;
			if(_useEmbeddedFonts){
					tf.antiAliasType = AntiAliasType.ADVANCED;
					tf.sharpness=_textCrispness;
			}
			tf.multiline = true;
			tf.wordWrap = true;
			tf.mouseEnabled = true;
			tf.selectable = true;
			tf.text = txt;
			return tf;
		}
	
		//--------------------------------------
		// CREATE TEXTFORMAT OBJECTS
		//-------------------------------------- 
		//util textformat creaton function
		//titlesText.setTextFormat(createTextFormat(45, 0x000000, false,HelveticaNeueHvCn,-3,-1.4));
		private function createTextFormat(size:int=10, colour:uint=0x000000,font:Class = null,leading:int = 0, kerning:Number=0 ):TextFormat {
			var tfFormat:TextFormat = new TextFormat();
			if(font !=null){
			tfFormat.font = new font().fontName;
			}else{
				tfFormat.font="Arial";
			}
			tfFormat.size=size;
			tfFormat.color=colour;
			tfFormat.letterSpacing=kerning;
			tfFormat.leading = leading;
			tfFormat.kerning = true;
			return tfFormat;
		}
		
	}
}

