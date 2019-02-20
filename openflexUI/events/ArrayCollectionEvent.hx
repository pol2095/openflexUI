/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.events;

import openfl.display.BitmapData;
import openfl.events.Event;

/**
 * The CloseEvent class represents event objects specific to popup windows.
 */
class ArrayCollectionEvent extends Event
{
	public static var ADDED:String = "added";
	public static var REMOVED:String = "removed";
	public static var REMOVE_ALL:String = "removeAll";
	public static var REPLACE:String = "replace";
	
	//public var item:{label:String, icon:BitmapData};
	public var item:Dynamic;
	public var index:Int;
	
	//public function new(type:String, item:{label:String, icon:BitmapData}, index:Int, bubbles:Bool = false, cancelable:Bool = false)
	public function new(type:String, item:Dynamic, index:Int, bubbles:Bool = false, cancelable:Bool = false)
	{
		super(type, bubbles, cancelable);
		this.item = item;
		this.index = index;
	}
	
	@:dox(hide)
	override public function clone():Event
	{
		return new ArrayCollectionEvent(type, this.item, this.index, bubbles, cancelable);
	}
	
	@:dox(hide)
	public override function toString():String
	{
		return formatToString("ArrayCollectionEvent", "type", "item", "index", "bubbles", "cancelable");
	}
}