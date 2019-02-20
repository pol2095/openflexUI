/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.layouts;

/**
 * The HorizontalLayout class arranges the layout elements in a horizontal sequence, left to right, with optional gaps between the elements.
 */
class HorizontalLayout
{
	/**
		 * The vertical alignment of layout elements. Possible values are `top`, `middle`, or `bottom`.
		 *
		 * The default value is `top`
		 */
	public var verticalAlign:String = "top";
	
	/**
		 * The space, in pixels, between items..
		 *
		 * The default value is `0`
		 */
	public var gap:Float;
	
	@:dox(hide)
	public function new()
	{
		gap = 0;
	}
}