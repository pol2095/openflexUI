/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.events;

import openfl.events.Event;

/**
 * The FlexEvent class represents the event object passed to the event listener for many Flex events.
 */
class FlexEvent extends Event
{
	/**
		 * The FlexEvent.INITIALIZE constant defines the value of the type property of the event object for a initialize event.
		 */
	public static var INITIALIZE:String = "initialize";
	/**
		 * The FlexEvent.PREINITIALIZE constant defines the value of the type property of the event object for a preinitialize event.
		 */
	public static var PREINITIALIZE:String = "preinitialize";
	@:dox(hide)
	public static var COMPONENT_COMPLETE:String = "componentComplete";
	/**
		 * The FlexEvent.CREATION_COMPLETE constant defines the value of the type property of the event object for a creationComplete event.
		 */
	public static var CREATION_COMPLETE:String = "creationComplete";
	
	@:dox(hide)
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false)
	{
		super(type, bubbles, cancelable);
	}
}