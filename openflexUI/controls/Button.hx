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
class Button extends UIComponent
{	
	/**
		 * The left icon placement.
		 */
	public static var LEFT_ICON_PLACEMENT:String = "left";
	/**
		 * The right icon placement.
		 */
	public static var RIGHT_ICON_PLACEMENT:String = "right";
	
	private var background:Sprite = new Sprite();
	private var backgroundOver:Sprite = new Sprite();
	private var backgroundDown:Sprite = new Sprite();
	private var backgroundBorder:Sprite = new Sprite();
	private var padding:Int = 4;
	private var state:String = "upState";
	private var labelItemRenderer:LabelItemRenderer;
	private var borderSize:Int = 1;
	private var cornerRadius:Int;
	private var backgroundColor:Int = 0xCCCCCC;
	private var backgroundOverColor:Int = 0x727272;
	private var backgroundDownColor:Int = 0xa3a3a3;
	private var backgroundBorderColor:Int = 0x000000;
	
	private var _label:String = "";
	/**
		 * Gets or sets the plain text to be displayed by the Button component.
		 */
	public var label(get, set):String;
	
	private function get_label()
	{
		return _label;
	}
	
	private function set_label(value:String)
	{
		_label = value;
		createChildren();
		return value;
	}
	
	private var _textFormat:TextFormat;
	/**
		 * Use textFormat to create specific text formatting for text fields.
		 */
	public var textFormat(get, set):TextFormat;
	
	private function get_textFormat()
	{
		return _textFormat;
	}
	
	private function set_textFormat(value:TextFormat)
	{
		_textFormat = value;
		createChildren();
		return value;
	}
	
	private var _icon:BitmapData;
	/**
		 * BitmapData to use as the default icon.
		 */
	public var icon(get, set):BitmapData;
	
	private function get_icon()
	{
		return _icon;
	}
	
	private function set_icon(value:BitmapData)
	{
		_icon = value;
		createChildren();
		return value;
	}
	
	private var _iconPlacement:String = "left";
	/**
		 * The placement of the icon, possible value are `left` or `right`.
		 *
		 * The default value is `left`
		 */
	public var iconPlacement(get, set):String;
	
	private function get_iconPlacement()
	{
		return _iconPlacement;
	}
	
	private function set_iconPlacement(value:String)
	{
		_iconPlacement = value;
		createChildren();
		return value;
	}
	
	private var _toggle:Bool;
	/**
		 * A button that may be selected and deselected when triggered.
		 *
		 * The default value is `false`
		 */
	public var toggle(get, set):Bool;
	
	private function get_toggle()
	{
		return _toggle;
	}
	
	private function set_toggle(value:Bool)
	{
		if( value == toggle ) return value;
		_toggle = value;
		if( isSelected && ! toggle )
		{
			removeBackground();
			state = "upState";
			this.addChild( background );
			this.setChildIndex( background, 1 );
			_isSelected = false;
		}
		return value;
	}
	
	private var _isSelected:Bool;
	/**
		 * Indicates if the button is selected or not.
		 */
	public var isSelected(get, set):Bool;
	
	private function get_isSelected()
	{
		return _isSelected;
	}
	
	private function set_isSelected(value:Bool)
	{
		if( ! toggle ) return value;
		if( value == isSelected ) return value;
		_isSelected = value;
		removeBackground();
		if( ! isSelected )
		{
			state = "upState";
			this.addChild( background );
			this.setChildIndex( background, 1 );
		}
		else
		{
			state = "downState";
			this.addChild( backgroundDown );
			this.setChildIndex( backgroundDown, 1 );
		}
		return value;
	}
	
	private var _itemRenderer:UIComponent;
	/**
		 * Use itemRenderer to create specific text formatting for text fields.
		 */
	public var itemRenderer(get, set):UIComponent;
	
	private function get_itemRenderer()
	{
		return _itemRenderer;
	}
	
	private function set_itemRenderer(value:UIComponent)
	{
		_itemRenderer = value;
		createChildren();
		return value;
	}
	
	@:dox(hide)
	public function new()
	{
		super();
		
		cornerRadius = borderSize * 4;
				
		var size:Float = 100;
		backgroundBorder.graphics.beginFill(backgroundBorderColor);
        backgroundBorder.graphics.drawRoundRect(0, 0, size, size, cornerRadius);
        backgroundBorder.graphics.endFill();
		
		backgroundBorder.scale9Grid = new Rectangle( borderSize * 2, borderSize * 2, size - borderSize * 4, size - borderSize * 4 );
		Reflect.setProperty(backgroundBorder, "noLayout", true);
		this.addChild( backgroundBorder );
		
		size = 100 - borderSize * 2;
		background.graphics.beginFill(backgroundColor);
        background.graphics.drawRoundRect(0, 0, size, size, cornerRadius);
        background.graphics.endFill();
		background.x = background.y = borderSize;
		background.scale9Grid = new Rectangle( borderSize * 2, borderSize * 2, size - borderSize * 4, size - borderSize * 4 );
		
		/*var bitmapData:BitmapData = new BitmapData( Std.int(background.width), Std.int(background.height), true, 0);
		bitmapData.draw(background);
		background.graphics.clear();
		
		var rect:Rectangle = new Rectangle( 1, 1, 98, 98 );
		var gridX:Array<Float> = [rect.left, rect.right, bitmapData.width];
		var gridY:Array<Float> = [rect.top, rect.bottom, bitmapData.height];
		
		var left:Float = 0;
		for(i in 0...3) {
			var top:Float = 0;
			for(j in 0...3) {
				background.graphics.beginBitmapFill(bitmapData);
				background.graphics.drawRect(left, top, gridX[i] - left, gridY[j] - top);
				background.graphics.endFill();
				top = gridY[j];
			}
			left = gridX[i];
		}
		
		background.scale9Grid = rect;*/
		Reflect.setProperty(background, "noLayout", true);
		this.addChild( background );
		
		backgroundOver.graphics.beginFill(backgroundOverColor);
        backgroundOver.graphics.drawRoundRect(0, 0, size, size, cornerRadius);
        backgroundOver.graphics.endFill();
		backgroundOver.x = backgroundOver.y = borderSize;
		backgroundOver.scale9Grid = new Rectangle( borderSize * 2, borderSize * 2, size - borderSize * 4, size - borderSize * 4 );
		Reflect.setProperty(backgroundOver, "noLayout", true);
		backgroundOver.alpha = 0.1;
		
		size = 100 - borderSize * 3;
		backgroundDown.graphics.beginFill(backgroundDownColor);
        backgroundDown.graphics.drawRoundRect(0, 0, size, size, cornerRadius);
        backgroundDown.graphics.endFill();
		backgroundDown.x = backgroundDown.y = borderSize * 2;
		backgroundDown.scale9Grid = new Rectangle( borderSize * 2, borderSize * 2, size - borderSize * 4, size - borderSize * 4 );
		Reflect.setProperty(backgroundDown, "noLayout", true);
		
		this.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
	}
	
	private function addedToStageHandler(event:Event):Void
	{
		this.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		
		this.addEventListener( MouseEvent.MOUSE_DOWN, mouseDownHandler );
		this.addEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
		this.addEventListener( MouseEvent.ROLL_OVER, rollOverHandler );
		this.addEventListener( MouseEvent.ROLL_OUT, rollOutHandler );
	}
	
	private function mouseDownHandler(event:MouseEvent):Void
	{
		removeBackground();
		state = "downState";
		this.addChild( backgroundDown );
		this.setChildIndex( backgroundDown, 1 );
		if( toggle ) _isSelected = ! _isSelected;
		if( this.getChildIndex( backgroundOver ) != -1 ) this.removeChild( backgroundOver );
	}
	
	private function mouseUpHandler(event:MouseEvent):Void
	{
		var rect:Rectangle = this.getBounds( stage );
		if( ! rect.contains( stage.mouseX, stage.mouseY ) )
		{
			if( this.getChildIndex( backgroundOver ) != -1 ) this.removeChild( backgroundOver );
		}
		else if( this.getChildIndex( backgroundOver ) == -1 )
		{
			this.addChild( backgroundOver );
			this.setChildIndex( backgroundOver, 2 );
		}
		if( toggle && isSelected ) return;
		removeBackground();
		state = "upState";
		this.addChild( background );
		this.setChildIndex( background, 1 );
	}
	
	private function rollOverHandler(event:MouseEvent):Void
	{
		//removeBackground();
		//state = "overState";
		if( this.getChildIndex( backgroundOver ) != -1 ) return;
		this.addChild( backgroundOver );
		this.setChildIndex( backgroundOver, 2 );
	}
	
	private function rollOutHandler(event:MouseEvent):Void
	{
		//removeBackground();
		if( this.getChildIndex( backgroundOver ) == -1 ) return;
		this.removeChild( backgroundOver );
	}
	
	private function removeBackground():Void
	{
		if( state == "upState" )
		{
			this.removeChild( background );
		}
		else if( state == "downState" )
		{
			this.removeChild( backgroundDown );
		}
	}
	
	override private function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void
	{
		createButton();
		super.updateDisplayList(unscaledWidth, unscaledHeight);
	}
	
	private function createButton():Void
	{
		if( labelItemRenderer != null )
		{
			if( this.getChildIndex( labelItemRenderer ) != -1 ) this.removeChild( labelItemRenderer );
		}
		if( itemRenderer != null )
		{
			if( this.getChildIndex( itemRenderer ) != -1 ) this.removeChild( itemRenderer );
			cast(itemRenderer, LabelItemRenderer).init( padding, background, backgroundOver, backgroundDown, backgroundBorder, label, textFormat, icon, minWidth, maxWidth, iconPlacement, borderSize, cornerRadius, backgroundColor, backgroundOverColor, backgroundDownColor, backgroundBorderColor );
			this.addChild( itemRenderer );
			itemRenderer.validate();
			if( ! Reflect.hasField( itemRenderer, "noLayout" ) ) Reflect.setProperty(itemRenderer, "noLayout", true);
		}
		else
		{
			labelItemRenderer = new LabelItemRenderer();
			labelItemRenderer.init( padding, background, backgroundOver, backgroundDown, backgroundBorder, label, textFormat, icon, minWidth, maxWidth, iconPlacement, borderSize, cornerRadius, backgroundColor, backgroundOverColor, backgroundDownColor, backgroundBorderColor );
			this.addChild( labelItemRenderer );
			labelItemRenderer.validate();
			if( ! Reflect.hasField( labelItemRenderer, "noLayout" ) ) Reflect.setProperty(labelItemRenderer, "noLayout", true);
		}
	}
	
	@:dox(hide)
	override public function dispose():Void
	{
		super.dispose();
		this.removeEventListener( MouseEvent.MOUSE_DOWN, mouseDownHandler );
		this.removeEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
		this.removeEventListener( MouseEvent.ROLL_OVER, rollOverHandler );
		this.removeEventListener( MouseEvent.ROLL_OUT, rollOutHandler );
	}
}