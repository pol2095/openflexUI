/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.layouts;

/**
 * The VerticalLayout class arranges the layout elements in a vertical sequence, top to bottom, with optional gaps between the elements.
 */
class VerticalLayout
{
	/**
		 * The horizontal alignment of layout elements. Possible values are "left", "center", or "right".
		 *
		 * The default value is "left"
		 */
	public var horizontalAlign:String = "left";
	
	/**
		 * The space, in pixels, between items..
		 *
		 * The default value is 0
		 */
	public var gap:Float = 0;
	
	@:dox(hide)
	public function new()
	{
		//
	}
}