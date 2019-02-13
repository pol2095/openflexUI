/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.controls;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openflexUI.controls.UIComponent;

/**
 * The Image control lets you display bitmapData at runtime.
 */
class Image extends UIComponent
{	
	private var bitmap:Bitmap = new Bitmap();
	
	private var _source:BitmapData;
	/**
		 * The source used for the bitmap fill.
		 */
	public var source(get, set):BitmapData;
	
	private function get_source()
	{
		return _source;
	}
	
	private function set_source(value:BitmapData)
	{
		_source = value;
		createChildren();
		return value;
	}
	
	@:dox(hide)
	public function new()
	{
		super();
		Reflect.setProperty(bitmap, "noLayout", true);
		this.addChild( bitmap );
		this.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
	}
	
	private function addedToStageHandler(event:Event):Void
	{
		this.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
	}
	
	override private function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void
	{
		createImage();
		super.updateDisplayList(unscaledWidth, unscaledHeight);
	}
	
	private function createImage():Void
	{
		/*if( bitmap != null ) this.removeChild( bitmap );
		bitmap = new Bitmap( source );
		this.addChild( bitmap );*/
		bitmap.bitmapData = source;
	}
	
	@:dox(hide)
	override public function dispose():Void
	{
		super.dispose();
	}
}