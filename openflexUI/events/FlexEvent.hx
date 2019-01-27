/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.events;

import openfl.events.Event;

class FlexEvent extends Event
{
	public static var INITIALIZE:String = "initialize";
	public static var PREINITIALIZE:String = "preinitialize";
	public static var COMPONENT_COMPLETE:String = "componentComplete";
	public static var CREATION_COMPLETE:String = "creationComplete";
}