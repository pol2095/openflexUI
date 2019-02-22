/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.controls;

import openfl.display.Sprite;

/**
 * The Sprite class is a basic display list building block: a display list node that can display graphics and can also contain children.
 */
class SpriteUI extends Sprite
{	
	@:dox(hide)
	public var noLayout:Bool = false;
	
	@:dox(hide)
	public var noAddedEvent:Bool = false;
	
	/**
		 * Disposes the resources of all children.
		 */
	public function dispose():Void
	{
		//
	}
}