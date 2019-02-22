/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.themes;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.GradientType;
import openfl.display.Shape;
import openfl.display.Sprite;
import flash.geom.Matrix;
import openfl.geom.Rectangle;

/**
 * The theme.
 */
class Theme
{
	private static var shape:Shape = new Shape();
	
	private static var _chromeColor:Int= -1;
	/**
		 * The chrome color.
		 */
	public static var chromeColor(get, set):Int;
	
	private static function get_chromeColor()
	{
		return _chromeColor;
	}
	
	private static function set_chromeColor(value:Int)
	{
		_chromeColor = value;
		gradient( chromeColor );
		return value;
	}
	
	private static var _overColor:Int= -1;
	/**
		 * The over color.
		 */
	public static var overColor(get, set):Int;
	
	private static function get_overColor()
	{
		return _overColor;
	}
	
	private static function set_overColor(value:Int)
	{
		_overColor = value;
		return value;
	}
	
	private static var _downColor:Int= -1;
	/**
		 * The down color.
		 */
	public static var downColor(get, set):Int;
	
	private static function get_downColor()
	{
		return _downColor;
	}
	
	private static function set_downColor(value:Int)
	{
		_downColor = value;
		return value;
	}
	
	private static var _borderColor:Int= -1;
	/**
		 * The border color.
		 */
	public static var borderColor(get, set):Int;
	
	private static function get_borderColor()
	{
		return _borderColor;
	}
	
	private static function set_borderColor(value:Int)
	{
		_borderColor = value;
		return value;
	}
	
	private static var _iconColor:Int= -1;
	/**
		 * The icon color.
		 */
	public static var iconColor(get, set):Int;
	
	private static function get_iconColor()
	{
		return _iconColor;
	}
	
	private static function set_iconColor(value:Int)
	{
		_iconColor = value;
		return value;
	}
	
	private static var _backgroundColor:Int= -1;
	/**
		 * The background color.
		 */
	public static var backgroundColor(get, set):Int;
	
	private static function get_backgroundColor()
	{
		return _backgroundColor;
	}
	
	private static function set_backgroundColor(value:Int)
	{
		_backgroundColor = value;
		return value;
	}
	
	private static var _scrollBarColor:Int= -1;
	/**
		 * The scrollBar color.
		 */
	public static var scrollBarColor(get, set):Int;
	
	private static function get_scrollBarColor()
	{
		return _scrollBarColor;
	}
	
	private static function set_scrollBarColor(value:Int)
	{
		_scrollBarColor = value;
		return value;
	}
	
	private static function gradient(color:Int):Void
	{
		shape.graphics.clear();
		var gradientBoxMatrix:Matrix = new Matrix(); 
		gradientBoxMatrix.createGradientBox(2, 200, Math.PI/2, 0, 0); 
		shape.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, color, 0x000000], [1, 1, 1], [0, 128, 255], gradientBoxMatrix); 
		shape.graphics.drawRect(0, 0, 20, 200); 
		shape.graphics.endFill();
		var bitmapData:BitmapData = new BitmapData( Std.int(shape.width), Std.int(shape.height) );
		bitmapData.draw( shape );
		
		overColor = bitmapData.getPixel( 1, 160 );
		downColor = bitmapData.getPixel( 1, 130 );
		backgroundColor = bitmapData.getPixel( 1, 40 );
	}
	
	@:dox(hide)
	public static function dispose():Void
	{
		//
	}
}