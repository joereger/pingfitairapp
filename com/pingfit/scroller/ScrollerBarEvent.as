package com.pingfit.scroller {
	
	import flash.events.Event;
			/**
			* Dispatched as a result of change in the position of the thumbBar on the scrollTrack. The scrollPercent property contains the position on the scrollTrack of the
			* scrollThumb as an Number, in the 0-1 range.
			*
			* @eventType ScrollerBarEvent.SCROLL_CHANGE
			*/
			[Event(name="scrollChange",type="com.pingfit.scroller.ScrollerBarEvent")]
			
			/**
			* Dispatched as a result of a user rolling over the dragBar sprite on the scrollTrack. Using this events <code>event.target</code> property gives you access to
			* the dragBar sprite, allowing you to create visual state changes to the dragBar sprite.
			*
			* @eventType ScrollerBarEvent.DRAG_ROLL_OVER
			*/
			[Event(name="dragRollover",type="com.pingfit.scroller.ScrollerBarEvent")]
			
			/**
			* Dispatched as a result of a user rolling off the dragBar sprite on the scrollTrack. Using this events <code>event.target</code> property gives you access to
			* the dragBar sprite, allowing you to create visual state changes to the dragBar sprite.
			*
			* @eventType ScrollerBarEvent.DRAG_ROLL_OUT
			*/
			[Event(name="dragRollout",type="com.pingfit.scroller.ScrollerBarEvent")]
			
			/**
			* Dispatched as a result of a user mousing down on the dragBar sprite on the scrollTrack. Using this events <code>event.target</code> property gives you access to
			* the dragBar sprite, allowing you to create visual state changes to the dragBar sprite.
			*
			* @eventType ScrollerBarEvent.DRAG_PRESS
			*/
			[Event(name="dragPress",type="com.pingfit.scroller.ScrollerBarEvent")]
			
			/**
			* Dispatched as a result of a user releasing their mouse after pressing down on the dragBar sprite on the scrollTrack. Using this events <code>event.target</code> property gives you access to
			* the dragBar sprite, allowing you to create visual state changes to the dragBar sprite.
			*
			* @eventType ScrollerBarEvent.DRAG_RELEASE
			*/
			[Event(name="dragRelease",type="com.pingfit.scroller.ScrollerBarEvent")]
			
	public class ScrollerBarEvent extends Event {

			/**
			 * The <code>ScrollerBarEvent.SCROLL_CHANGE</code> constant defines the value of the <code>type</code> property of the event object for a <code>scrollChange</code> event.
	         * <p>
	         * The properties of the event object have the following values:
	         * </p>
	         * <table class="innertable">
	         * <tr><th>Property</th> <th>Value</th></tr>
	         * <tr><td><code>type</code></td> <td><code>"scrollchange"</code></td></tr>
	         * <tr><td><code>bubbles</code></td> <td><code>true</code></td></tr>
	         * <tr><td><code>cancelable</code></td> <td><code>false</code></td></tr>
			 * <tr><td><code>scrollPercent</code></td> <td><code>Number - position on the scrollTrack of the scrollThumb as an Number, in the 0-1 range. Access via event.scrollPercent.</code></td></tr>
	         * </table>
	         *
	         * @eventType scrollChange
	         */
		public static  const SCROLL_CHANGE:String="scrollChange";
			/**
			 * The <code>ScrollerBarEvent.DRAG_ROLL_OVER</code> constant defines the value of the <code>type</code> property of the event object for a <code>dragRollover</code> event.
	         * <p>
	         * The properties of the event object have the following values:
	         * </p>
	         * <table class="innertable">
	         * <tr><th>Property</th> <th>Value</th></tr>
	         * <tr><td><code>type</code></td> <td><code>"dragrollover"</code></td></tr>
	         * <tr><td><code>bubbles</code></td> <td><code>true</code></td></tr>
	         * <tr><td><code>cancelable</code></td> <td><code>true</code></td></tr>
			 * <tr><td><code>scrollPercent</code></td> <td><code>Number - undefined for this event type</code></td></tr>
			 
	         * </table>
	         *
	         * @eventType dragRollover
	         */
		public static  const DRAG_ROLL_OVER:String="dragrollover";
			/**
			 * The <code>ScrollerBarEvent.DRAG_ROLL_OUT</code> constant defines the value of the <code>type</code> property of the event object for a <code>dragRollout</code> event.
	         * <p>
	         * The properties of the event object have the following values:
	         * </p>
	         * <table class="innertable">
	         * <tr><th>Property</th> <th>Value</th></tr>
	         * <tr><td><code>type</code></td> <td><code>"dragrollout"</code></td></tr>
	         * <tr><td><code>bubbles</code></td> <td><code>true</code></td></tr>
	         * <tr><td><code>cancelable</code></td> <td><code>true</code></td></tr>
			 * <tr><td><code>scrollPercent</code></td> <td><code>Number - undefined for this event type</code></td></tr>			 
	         * </table>
	         *
	         * @eventType dragRollout
	         */
			 
		public static  const DRAG_ROLL_OUT:String="dragRollout";
		
			/**
			 * The <code>ScrollerBarEvent.DRAG_PRESS</code> constant defines the value of the <code>type</code> property of the event object for a <code>dragPress</code> event.
	         * <p>
	         * The properties of the event object have the following values:
	         * </p>
	         * <table class="innertable">
	         * <tr><th>Property</th> <th>Value</th></tr>
	         * <tr><td><code>type</code></td> <td><code>"dragrollout"</code></td></tr>
	         * <tr><td><code>bubbles</code></td> <td><code>true</code></td></tr>
	         * <tr><td><code>cancelable</code></td> <td><code>true</code></td></tr>
			 * <tr><td><code>scrollPercent</code></td> <td><code>Number - undefined for this event type</code></td></tr>			 
	         * </table>
	         *
	         * @eventType dragPress
	         */
		public static  const DRAG_PRESS:String="dragPress";
		
			/**
			 * The <code>ScrollerBarEvent.DRAG_RELEASE</code> constant defines the value of the <code>type</code> property of the event object for a <code>dragRelease</code> event.
	         * <p>
	         * The properties of the event object have the following values:
	         * </p>
	         * <table class="innertable">
	         * <tr><th>Property</th> <th>Value</th></tr>
	         * <tr><td><code>type</code></td> <td><code>"dragrollout"</code></td></tr>
	         * <tr><td><code>bubbles</code></td> <td><code>true</code></td></tr>
	         * <tr><td><code>cancelable</code></td> <td><code>true</code></td></tr>
			 * <tr><td><code>scrollPercent</code></td> <td><code>Number - undefined for this event type</code></td></tr>			 
	         * </table>
	         *
	         * @eventType dragRelease
	         */
		public static  const DRAG_RELEASE:String="dragRelease";
		
		//--------------------------------------
		// PUBLIC INSTANCE PROPERTIES
		//--------------------------------------	
		
		public var scrollPercent:Number;

		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		*	The ScrollerBarEvent is dispatched by the SliderBar Class. 
		*   Extended Event class used by the SliderBar class to dispatch an event with a scrollPercent property that contains the current position of the thumbBar on the the
		*	scrollTrack as a percentage in the 0-1 range.
		*	@langversion ActionScript 3.0
		*	@playerversion	Flash 9
		*/
		public function ScrollerBarEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false,scrollPercent:Number=undefined) {
			super(type,bubbles,cancelable);
			this.scrollPercent=scrollPercent;
		}
		/**
		*	@langversion ActionScript 3.0
		*	@playerversion	Flash 9
		*	Creates a copy of an ScrollerBarEvent object and sets the value of each property to match that of the original.
		*	@return Event A new ScrollerBarEvent object with property values that match those of the original.
		*/
		override public function clone():Event {
			return new ScrollerBarEvent(this.type,this.bubbles,this.cancelable,this.scrollPercent);
		}
		/**
		*	@langversion ActionScript 3.0
		*	@playerversion	Flash 9
		*	Returns a string that contains all the properties of the ScrollerBarEvent object. The following format is used:
		*	[ScrollerBarEvent type=value bubbles=value cancelable=value eventPhase=value scrollPercent=value]
		*	@return String A string that contains all the properties of the ScrollerBarEvent object.
		*/
		override public function toString():String {
			return formatToString("ScrollerBarEvent ","type","bubbles","cancelable","eventPhase","scrollPercent");
		}
	}
	
}