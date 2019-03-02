/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.controls;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openflexUI.controls.UIComponent;
import openflexUI.events.FlexEvent;
import openflexUI.themes.Theme;

/**
 * The BorderContainer class control the appearance of the border and background fill of the container.
 */
class BorderContainer extends UIComponent
{	
	private var backgroundBorder:SpriteUI = new SpriteUI();
	private var backgroundBorderColor:Int = 0x000000;
	private var backgroundCenter:SpriteUI = new SpriteUI();
	private var backgroundColor:Int = 0xEEEEEE;
	private var borderSize:Int = 1;
	private var background:SpriteUI = new SpriteUI();
	private var margin:Float;
	private var marginBorder:Float;
	
	private var _width:Float = Math.NaN;
	
	@:dox(hide)
	#if flash @:getter(width) override public #else override public #end function get_width():Float
	{
		if( ! Math.isNaN( _width ) ) return _width;
		return super.width + marginBorder * 2;
	}
	
	@:dox(hide)
	#if flash @:setter(width) override public #else override public #end function set_width(value:Float)
	{
		_width = value;
		if( Math.isNaN( _width ) )
		{
			super.width = value;
		}
		createChildren();
		#if !flash return value; #end
	}
	
	private var _height:Float = Math.NaN;
	
	@:dox(hide)
	#if flash @:getter(height) override public #else override public #end function get_height():Float
	{
		if( ! Math.isNaN( _height ) ) return _height;
		return super.height + marginBorder * 2;
	}
	
	@:dox(hide)
	#if flash @:setter(height) override public #else override public #end function set_height(value:Float)
	{
		_height = value;
		if( Math.isNaN( _height ) )
		{
			super.height = value;
		}
		createChildren();
		#if !flash return value; #end
	}
	
	private var _backgroundVisible:Bool = true;
	/**
		 * Determines if the backgroung is visible.
		 *
		 * The default value is `true`
		 */
	public var backgroundVisible(get, set):Bool;
	
	private function get_backgroundVisible():Bool
	{
		return _backgroundVisible;
	}
	
	private function set_backgroundVisible(value:Bool)
	{
		_backgroundVisible = value;
		background.visible = value;
		createChildren();
		return value;
	}
	
	private var _horizontalAlign:String = "left";
	/**
		 * Horizontalal alignment of the childrens, possible values are `left`, `center`, `right`.
		 *
		 * The default value is `left`
		 */
	public var horizontalAlign(get, set):String;
	
	private function get_horizontalAlign():String
	{
		return _horizontalAlign;
	}
	
	private function set_horizontalAlign(value:String)
	{
		_horizontalAlign = value;
		createChildren();
		return value;
	}
	
	private var _verticalAlign:String = "top";
	/**
		 * Vertical alignment of the childrens, possible values are `top`, `middle`, `bottom`.
		 *
		 * The default value is `top`
		 */
	public var verticalAlign(get, set):String;
	
	private function get_verticalAlign():String
	{
		return _verticalAlign;
	}
	
	private function set_verticalAlign(value:String)
	{
		_verticalAlign = value;
		createChildren();
		return value;
	}
	
	@:dox(hide)
	public function new()
	{
		super();
		
		var size:Float = 100;
		backgroundBorder.graphics.beginFill(backgroundBorderColor);
        backgroundBorder.graphics.drawRect(0, 0, size, size);
        backgroundBorder.graphics.endFill();
		backgroundBorder.noLayout = true;
		background.addChild( backgroundBorder );
		
		size = 100 - borderSize * 2;
		backgroundCenter.graphics.beginFill(backgroundColor);
        backgroundCenter.graphics.drawRect(0, 0, size, size);
        backgroundCenter.graphics.endFill();
		backgroundCenter.x = backgroundCenter.y = borderSize;
		backgroundCenter.noLayout = true;
		background.addChild( backgroundCenter );
		
		background.noLayout = true;
		this.addChild( background );
	}
	
	private function addedToStageHandler(event:Event):Void
	{
		this.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
	}
	
	override private function style():Void
	{
		super.style();
		if( Theme.borderColor != -1 ) backgroundBorderColor = Theme.borderColor;
		if( Theme.backgroundColor != -1 ) backgroundColor = Theme.backgroundColor;
	}
	
	override private function measure():Void
	{
		super.measure();
		createBackground();
	}
	
	private function createBackground():Void
	{
		margin = backgroundVisible ? borderSize * 2 : 0;
		marginBorder = backgroundVisible ? borderSize * 3 : 0;
		
		backgroundBorder.graphics.clear();
		backgroundCenter.graphics.clear();
		backgroundBorder.graphics.beginFill(backgroundBorderColor);
		backgroundCenter.graphics.beginFill(backgroundColor);
		
		var size:Int = 200;
		var width:Float = this.numChildren > 1 ? this.width : size;
		var height:Float = this.numChildren > 1 ? this.height : size;
		backgroundBorder.graphics.drawRect(0, 0, width, height);
		backgroundBorder.graphics.endFill();
		
		backgroundCenter.graphics.beginFill(backgroundColor);
		backgroundCenter.graphics.drawRect(0, 0, width - margin, height - margin);
		backgroundCenter.graphics.endFill();
		backgroundCenter.x = backgroundCenter.y = backgroundVisible ? borderSize : 0;		
		backgroundCenter.graphics.endFill();
		
		for(i in 0...this.numChildren)
		{
			if( Std.is( this.getChildAt(i), UIComponent ) )
			{
				if( ! cast( this.getChildAt(i), UIComponent ).includeInLayout )	continue;
			}
			if( hasField( this.getChildAt(i), "noLayout" ) ) continue;
			
			this.getChildAt(i).x += marginBorder;
			this.getChildAt(i).y += marginBorder;
		}
		
		if( horizontalAlign == "center" )
		{
			var superWidth:Float = super.width;
			if( ! Math.isNaN(_width) && super.width < background.width - marginBorder * 2 )
			{
				for(i in 0...this.numChildren)
				{
					if( Std.is( this.getChildAt(i), UIComponent ) )
					{
						if( ! cast( this.getChildAt(i), UIComponent ).includeInLayout )	continue;
					}
					if( hasField( this.getChildAt(i), "noLayout" ) ) continue;
					
					this.getChildAt(i).x += ( background.width - marginBorder * 2 - superWidth ) / 2;
					trace( this.getChildAt(i).x );
				}
			}
		}
		else if( horizontalAlign == "right" )
		{
			var superWidth:Float = super.width;
			if( ! Math.isNaN(_width) && super.width < background.width - marginBorder * 2 )
			{
				for(i in 0...this.numChildren)
				{
					if( Std.is( this.getChildAt(i), UIComponent ) )
					{
						if( ! cast( this.getChildAt(i), UIComponent ).includeInLayout )	continue;
					}
					if( hasField( this.getChildAt(i), "noLayout" ) ) continue;
					
					this.getChildAt(i).x += background.width - marginBorder * 2 - superWidth;
				}
			}
		}
		
		if( verticalAlign == "middle" )
		{
			var superWidth:Float = super.height;
			if( ! Math.isNaN(_height) && super.height < background.height - marginBorder * 2 )
			{
				for(i in 0...this.numChildren)
				{
					if( Std.is( this.getChildAt(i), UIComponent ) )
					{
						if( ! cast( this.getChildAt(i), UIComponent ).includeInLayout )	continue;
					}
					if( hasField( this.getChildAt(i), "noLayout" ) ) continue;
					
					this.getChildAt(i).y += ( background.height - marginBorder * 2 - superWidth ) / 2;
				}
			}
		}
		else if( verticalAlign == "bottom" )
		{
			var superWidth:Float = super.height;
			if( ! Math.isNaN(_height) && super.height < background.height - marginBorder * 2 )
			{
				for(i in 0...this.numChildren)
				{
					if( Std.is( this.getChildAt(i), UIComponent ) )
					{
						if( ! cast( this.getChildAt(i), UIComponent ).includeInLayout )	continue;
					}
					if( hasField( this.getChildAt(i), "noLayout" ) ) continue;
					
					this.getChildAt(i).y += background.height - marginBorder * 2 - superWidth;
				}
			}
		}
	}
	
	@:dox(hide)
	override public function dispose():Void
	{
		super.dispose();
	}
}