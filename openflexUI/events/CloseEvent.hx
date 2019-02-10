/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.events;

import openfl.events.Event;

/**
 * The CloseEvent class represents event objects specific to popup windows.
 */
class CloseEvent extends Event
{
	/**
		 * The Yes value is `1`.
		 */
	public static var YES:Int = 1;
	/**
		 * The No value is `2`.
		 */
	public static var NO:Int = 2;
	/**
		 * The Ok Value is `4`.
		 */
	public static var OK:Int = 4;
	/**
		 * The Cancel value is `8`.
		 */
	public static var CANCEL:Int = 8;
	
	/**
		 * Identifies the button in the popped up control that was clicked.
		 */
	public var detail:Int;
	
	/**
	 * Creates an Event object to pass as a parameter to event listeners.
	 * 
	 * @param type       The type of the event, accessible as
	 *                   `Event.type`.
	 * @param bubbles    Determines whether the Event object participates in the
	 *                   bubbling stage of the event flow. The default value is
	 *                   `false`.
	 * @param cancelable Determines whether the Event object can be canceled. The
	 *                   default values is `false`.
	 * @param detail Identifies the button in the popped up control that was clicked. The default value is `-1`.
	 */
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, detail:Int = -1)
	{
		super(type, bubbles, cancelable);
		this.detail = detail;
	}
	
	@:dox(hide)
	override public function clone():Event
	{
		return new CloseEvent(type, bubbles, cancelable, this.detail);
	}
	
	@:dox(hide)
	public override function toString():String
	{
		return formatToString("CloseEvent", "type", "bubbles", "cancelable", "detail");
	}
}