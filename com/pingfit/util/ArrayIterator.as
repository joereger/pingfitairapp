package com.pingfit.util
{
	
/**
 * A generic implementation of the Iterator interface.  Takes an
 * array of items in the constructor and uses the interface to loop
 * over the elements present in the array.
 */
public class ArrayIterator implements Iterator
{
	private var items:Array;
	
	private var index:int;
	
	/**
	 * Constructor.
	 * 
	 * @param array The array of elements to construct and Iterator for
	 */
	public function ArrayIterator( array:Array )
	{
		items = array;
		// If the array is null, create a new empty array
		if ( items == null )
		{
			items = new Array();
		}
		index = 0;
	}
	
	/** 
	 * @return <code>true</code> if the iteration has more elements, false otherwise.
	 */
	public function hasNext():Boolean
	{
		return index < items.length;
	}
	
	/** 
	 * @return The next element in the iteration. 
	 */
	public function next():*
	{
		return items[ index++ ];
	}
	
	/**
	 * Resets the iterator's state to start from the very first element.
	 */
	public function reset():void
	{
		index = 0;
	}
	
}
}