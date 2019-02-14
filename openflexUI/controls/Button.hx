/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.controls;

import openfl.display.BitmapData;
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
	private var labelUI:Label = new Label();
	private var image:Image = new Image();
	private var padding:Int = 4;
	private var state:String = "upState";
	
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
			this.setChildIndex( background, 0 );
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
			this.setChildIndex( background, 0 );
		}
		else
		{
			state = "downState";
			this.addChild( backgroundDown );
			this.setChildIndex( backgroundDown, 0 );
		}
		return value;
	}
	
	@:dox(hide)
	public function new()
	{
		super();
		
		background.graphics.beginFill(0x000000);
		background.graphics.drawRect(0, 0, 100, 1);
        background.graphics.endFill();
		background.graphics.beginFill(0x000000);
		background.graphics.drawRect(0, 1, 1, 98);
        background.graphics.endFill();
		background.graphics.beginFill(0x000000);
		background.graphics.drawRect(99, 1, 1, 98);
        background.graphics.endFill();
		background.graphics.beginFill(0x000000);
		background.graphics.drawRect(0, 99, 100, 1);
        background.graphics.endFill();
		background.graphics.beginFill(0xCCCCCC);
        background.graphics.drawRect(1, 1, 98, 98);
        background.graphics.endFill();
		background.scale9Grid = new Rectangle( 1, 1, 98, 98 );
		
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
		
		backgroundOver.graphics.beginFill(0x000000);
		backgroundOver.graphics.drawRect(0, 0, 100, 1);
        backgroundOver.graphics.endFill();
		backgroundOver.graphics.beginFill(0x000000);
		backgroundOver.graphics.drawRect(0, 1, 1, 98);
        backgroundOver.graphics.endFill();
		backgroundOver.graphics.beginFill(0x000000);
		backgroundOver.graphics.drawRect(99, 1, 1, 98);
        backgroundOver.graphics.endFill();
		backgroundOver.graphics.beginFill(0x000000);
		backgroundOver.graphics.drawRect(0, 99, 100, 1);
        backgroundOver.graphics.endFill();
		backgroundOver.graphics.beginFill(0x727272);
        backgroundOver.graphics.drawRect(1, 1, 98, 98);
        backgroundOver.graphics.endFill();
		backgroundOver.scale9Grid = new Rectangle( 1, 1, 98, 98 );
		Reflect.setProperty(backgroundOver, "noLayout", true);
		backgroundOver.alpha = 0.1;
		
		backgroundDown.graphics.beginFill(0x000000);
		backgroundDown.graphics.drawRect(0, 0, 100, 2);
        backgroundDown.graphics.endFill();
		backgroundDown.graphics.beginFill(0x000000);
		backgroundDown.graphics.drawRect(0, 2, 2, 96);
        backgroundDown.graphics.endFill();
		backgroundDown.graphics.beginFill(0x000000);
		backgroundDown.graphics.drawRect(98, 2, 2, 96);
        backgroundDown.graphics.endFill();
		backgroundDown.graphics.beginFill(0x000000);
		backgroundDown.graphics.drawRect(0, 98, 100, 2);
        backgroundDown.graphics.endFill();
		backgroundDown.graphics.beginFill(0xa3a3a3);
        backgroundDown.graphics.drawRect(2, 2, 96, 96);
        backgroundDown.graphics.endFill();
		backgroundDown.scale9Grid = new Rectangle( 2, 2, 96, 96 );
		Reflect.setProperty(backgroundDown, "noLayout", true);
		
		Reflect.setProperty(labelUI, "noLayout", true);
		labelUI.y = padding;
		//this.addChild( labelUI );
		Reflect.setProperty(image, "noLayout", true);
		image.y = padding;
		//this.addChild( image );
		
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
		this.setChildIndex( backgroundDown, 0 );
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
			this.setChildIndex( backgroundOver, 1 );
		}
		if( toggle && isSelected ) return;
		removeBackground();
		state = "upState";
		this.addChild( background );
		this.setChildIndex( background, 0 );
	}
	
	private function rollOverHandler(event:MouseEvent):Void
	{
		//removeBackground();
		//state = "overState";
		if( this.getChildIndex( backgroundOver ) != -1 ) return;
		this.addChild( backgroundOver );
		this.setChildIndex( backgroundOver, 1 );
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
	
	override private function createChildren():Void
	{		
		super.createChildren();
	}
	
	override private function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void
	{
		createButton();
		super.updateDisplayList(unscaledWidth, unscaledHeight);
	}
	
	private function createButton():Void
	{
		if( this.getChildIndex( labelUI ) != -1 ) this.removeChild( labelUI );
		if( this.getChildIndex( image ) != -1 ) this.removeChild( image );
		
		if( icon != null )
		{
			image.source = icon;
			this.addChild( image );
			image.validate();
		}
		
		if( icon == null || ( icon != null && this.label != "" ) )
		{
			labelUI.text = this.label;
			if( this.textFormat != null ) labelUI.textFormat = this.textFormat;
			labelUI.text = Math.isNaN( maxWidth ) || icon != null ? this.label : labelUI.truncateLabel(this.label, padding * 2, this.maxWidth);
			this.addChild( labelUI );
			labelUI.validate();
		}
		
		if( icon == null )
		{			
			labelUI.x = padding;
			
			background.width = backgroundOver.width = backgroundDown.width = Math.isNaN( minWidth ) ? labelUI.width + padding * 2 : minWidth;
			background.height = backgroundOver.height = backgroundDown.height = labelUI.height + padding * 2;
		}
		else if( this.label != "" )
		{
			image.height = labelUI.height;
			image.scaleX = image.scaleY;
			
			if( ! Math.isNaN( maxWidth ) )
			{
				labelUI.text =  labelUI.truncateLabel(this.label, image.width + padding * 3, this.maxWidth);
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
			
			background.width = backgroundOver.width = backgroundDown.width = Math.isNaN( minWidth ) ? labelUI.width + image.width + padding * 3 : minWidth;
			background.height = backgroundOver.height = backgroundDown.height = image.height + padding * 2;
		}
		else if( this.label == "" )
		{			
			image.x = padding;
			
			background.width = backgroundOver.width = backgroundDown.width = image.width + padding * 2;
			background.height = backgroundOver.height = backgroundDown.height = image.height + padding * 2;
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