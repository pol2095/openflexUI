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
	private var background:SpriteUI = new SpriteUI();
	private var backgroundColor:Int = 0xEEEEEE;
	private var borderSize:Int = 1;
	
	@:dox(hide)
	#if flash @:getter(width) override public #else override public #end function get_width():Float
	{
		return super.width + borderSize * 6;
	}
	
	@:dox(hide)
	#if flash @:getter(height) override public #else override public #end function get_height():Float
	{
		return super.height + borderSize * 6;
	}
	
	@:dox(hide)
	public function new()
	{
		super();
		
		var size:Float = 100;
		backgroundBorder.graphics.beginFill(backgroundBorderColor);
        backgroundBorder.graphics.drawRect(0, 0, size, size);
        backgroundBorder.graphics.endFill();
		background.noLayout = true;
		this.addChild( backgroundBorder );
		
		size = 100 - borderSize * 2;
		background.graphics.beginFill(backgroundColor);
        background.graphics.drawRect(0, 0, size, size);
        background.graphics.endFill();
		background.x = background.y = borderSize;
		backgroundBorder.noLayout = true;
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
		backgroundBorder.graphics.clear();
		background.graphics.clear();
		backgroundBorder.graphics.beginFill(backgroundBorderColor);
		background.graphics.beginFill(backgroundColor);
		
		var size:Int = 200;
		var width:Float = this.numChildren > 2 ? this.width : size;
		var height:Float = this.numChildren > 2 ? this.height : size;
		backgroundBorder.graphics.drawRect(0, 0, width, height);
		backgroundBorder.graphics.endFill();
		
		background.graphics.beginFill(backgroundColor);
		background.graphics.drawRect(0, 0, width - borderSize * 2, height - borderSize * 2);
		background.graphics.endFill();
		background.x = background.y = borderSize;		
		background.graphics.endFill();
		
		for(i in 0...this.numChildren)
		{
			if( Std.is( this.getChildAt(i), UIComponent ) )
			{
				if( ! cast( this.getChildAt(i), UIComponent ).includeInLayout )	continue;
			}
			if( hasField( this.getChildAt(i), "noLayout" ) ) continue;
			
			this.getChildAt(i).x += borderSize * 3;
			this.getChildAt(i).y += borderSize * 3;
		}
	}
	
	@:dox(hide)
	override public function dispose():Void
	{
		super.dispose();
	}
}