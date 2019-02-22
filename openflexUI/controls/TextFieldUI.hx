/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.controls;

import openfl.text.TextField;

/**
 * The TextField class is used to create display objects for text display and input.
 */
class TextFieldUI extends TextField
{	
	@:dox(hide)
	public var noLayout:Bool = false;
	
	@:dox(hide)
	public var noAddedEvent:Bool = false;
	
	@:dox(hide)
	public function new()
	{
		super();
	}
	
	/**
		 * Disposes the resources of all children.
		 */
	public function dispose():Void
	{
		//
	}
}