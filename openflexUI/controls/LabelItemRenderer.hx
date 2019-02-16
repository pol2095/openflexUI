/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.controls;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.text.TextFormat;
import openflexUI.controls.UIComponent;

/**
 * The Button component represents a commonly used rectangular button. Button components display a text label.
 */
class LabelItemRenderer extends UIComponent
{	
	private var labelUI:Label = new Label();
	private var image:Image = new Image();
	
	private var padding:Int;
	private var background:Sprite;
	private var backgroundOver:Sprite;
	private var backgroundDown:Sprite;
	private var backgroundBorder:Sprite;
	private var label:String;
	private var textFormat:TextFormat;
	private var icon:BitmapData;
	private var iconPlacement:String;
	private var borderSize:Int;
	private var cornerRadius:Int;
	private var backgroundColor:Int;
	private var backgroundOverColor:Int;
	private var backgroundDownColor:Int;
	private var backgroundBorderColor:Int;
	
	@:dox(hide)
	public function new()
	{
		super();
		
		Reflect.setProperty(labelUI, "noLayout", true);
		Reflect.setProperty(image, "noLayout", true);
	}
	
	@:dox(hide)
	public function init(padding:Int, background:Sprite, backgroundOver:Sprite, backgroundDown:Sprite, backgroundBorder:Sprite, label:String, textFormat:TextFormat, icon:BitmapData, minWidth:Float, maxWidth:Float, iconPlacement:String, borderSize:Int, cornerRadius:Int, backgroundColor:Int, backgroundOverColor:Int, backgroundDownColor:Int, backgroundBorderColor:Int):Void
	{
		this.padding = padding;
		this.background = background;
		this.backgroundOver = backgroundOver;
		this.backgroundDown = backgroundDown;
		this.backgroundBorder = backgroundBorder;
		this.label = label;
		this.textFormat = textFormat;
		this.icon = icon;
		this.label = label;
		this.minWidth = minWidth;
		this.maxWidth = maxWidth;
		this.iconPlacement = iconPlacement;
		this.borderSize = borderSize;
		this.cornerRadius = cornerRadius;
		this.backgroundColor = backgroundColor;
		this.backgroundOverColor = backgroundOverColor;
		this.backgroundDownColor = backgroundDownColor;
		this.backgroundBorderColor = backgroundBorderColor;
	}
	
	override private function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void
	{
		createLabel();
		super.updateDisplayList(unscaledWidth, unscaledHeight);
	}
	
	private function createLabel():Void
	{
		labelUI.y = padding;
		image.y = padding;
		
		if( icon == null || ( icon != null && label != "" ) )
		{
			labelUI.text = label;
			if( textFormat != null ) labelUI.textFormat = textFormat;
			labelUI.text = Math.isNaN( maxWidth ) || icon != null ? label : labelUI.truncateLabel(label, padding * 2, maxWidth);
			this.addChild( labelUI );
			labelUI.validate();
		}
		
		if( icon != null )
		{
			image.source = icon;
			this.addChild( image );
			image.validate();
		}
		
		if( icon == null )
		{			
			labelUI.x = padding;
			
			/*backgroundBorder.width = Math.isNaN( minWidth ) ? labelUI.width + padding * 2 : minWidth;
			backgroundBorder.height = labelUI.height + padding * 2;*/
			_drawRoundRect( backgroundBorder, Math.isNaN( minWidth ) ? labelUI.width + padding * 2 : minWidth, labelUI.height + padding * 2, backgroundBorderColor );
		}
		else if( this.label != "" )
		{
			image.height = labelUI.height;
			image.scaleX = image.scaleY;
			
			if( ! Math.isNaN( maxWidth ) )
			{
				labelUI.text =  labelUI.truncateLabel(label, image.width + padding * 3, maxWidth);
				labelUI.validate();
			}
			
			if( iconPlacement == "left" )
			{
				image.x = padding;
				labelUI.x = image.width + padding;
			}
			else
			{
				labelUI.x = padding;
				image.x = labelUI.width + padding;
			}
			
			/*backgroundBorder.width = Math.isNaN( minWidth ) ? labelUI.width + image.width + padding * 3 : minWidth;
			backgroundBorder.height = image.height + padding * 2;*/
			_drawRoundRect( backgroundBorder, Math.isNaN( minWidth ) ? labelUI.width + image.width + padding * 3 : minWidth, image.height + padding * 2, backgroundBorderColor );
		}
		else if( this.label == "" )
		{			
			image.x = padding;
			
			/*backgroundBorder.width = image.width + padding * 2;
			backgroundBorder.height = image.height + padding * 2;*/
			_drawRoundRect( backgroundBorder, image.width + padding * 2, image.height + padding * 2, backgroundBorderColor );
		}
		/*background.width = backgroundOver.width = backgroundBorder.width - borderSize * 2;
		backgroundDown.width = backgroundBorder.width - borderSize * 4;
		background.height = backgroundOver.height = backgroundBorder.height - borderSize * 2;
		backgroundDown.height = backgroundBorder.height - borderSize * 4;*/
		_drawRoundRect( backgroundOver, backgroundBorder.width - borderSize * 2, backgroundBorder.height - borderSize * 2, backgroundOverColor );
		_drawRoundRect( background, backgroundBorder.width - borderSize * 2, backgroundBorder.height - borderSize * 2, backgroundColor );
		_drawRoundRect( backgroundDown, backgroundBorder.width - borderSize * 4, backgroundBorder.height - borderSize * 4, backgroundDownColor );
	}
	
	private function _drawRoundRect(sprite:Sprite, width:Float, height:Float, color:Int):Void
	{
		sprite.graphics.clear();
		sprite.graphics.beginFill(color);
        sprite.graphics.drawRoundRect(0, 0, width, height, cornerRadius);
        sprite.graphics.endFill();
	}
	
	@:dox(hide)
	override public function dispose():Void
	{
		super.dispose();
	}
}