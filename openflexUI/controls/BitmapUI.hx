/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.controls;

import openfl.display.Bitmap;
import openfl.display.BitmapData;

/**
	* The Bitmap class represents display objects that represent bitmap images.
	*/
class BitmapUI extends Bitmap
{	
	@:dox(hide)
	public var noLayout:Bool = false;
	
	@:dox(hide)
	public var noAddedEvent:Bool = false;
	
	/**
		* Initializes a Bitmap object to refer to the specified BitmapData object.
		*/
	public function new(bitmapData:BitmapData = null, pixelSnapping:String = "auto", smoothing:Bool = false)
	{
		super(bitmapData, pixelSnapping, smoothing);
	}
	
	/**
		 * Disposes the resources of all children.
		 */
	public function dispose():Void
	{
		//
	}
}