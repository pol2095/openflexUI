/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.controls;

import openfl.display.Sprite;
import openfl.events.FocusEvent;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;
import openflexUI.controls.UIComponent;

/**
 * TextArea is a text-entry control that lets users enter and edit multiple lines of formatted text.
 */
class TextInput extends UIComponent
{	
	private var textField:TextField = new TextField();
	private var backgroundFocusIn:Sprite = new Sprite();
	private var backgroundFocusOut:Sprite = new Sprite();
	private var backgroundBorder:Sprite = new Sprite();
	private var padding:Int = 4;
	private var borderSize:Int = 1;
	//private var cornerRadius:Int;
	private var backgroundFocusOutColor:Int = 0xFFFFFF;
	private var backgroundFocusInColor:Int = 0x00BFFF;
	private var backgroundBorderColor:Int = 0x000000;
	private var hasFocus:Bool = false;
	
	private var _text:String = "";
	/**
		 * Gets or sets the plain text to be displayed by the Label component.
		 */
	public var text(get, set):String;
	
	private function get_text()
	{
		return _text;
	}
	
	private function set_text(value:String)
	{
		_text = value;
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
	
	private var _selectable:Bool;
	/**
		 * A flag indicating whether the content is selectable.
		 */
	public var selectable(get, set):Bool;
	
	private function get_selectable()
	{
		return _selectable;
	}
	
	private function set_selectable(value:Bool)
	{
		_selectable = value;
		textField.selectable = _selectable;
		return value;
	}
	
	private var _editable:Bool;
	/**
		 * Specifies whether the text is editable.
		 */
	public var editable(get, set):Bool;
	
	private function get_editable()
	{
		return _editable;
	}
	
	private function set_editable(value:Bool)
	{
		_editable = value;
		textField.type = _editable ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
		return value;
	}
		
	@:dox(hide)
	public function new()
	{
		super();
		
		Reflect.setProperty(textField, "noAddedEvent", true);
		textField.type = TextFieldType.INPUT;
		//textField.border = true;
		textField.width = 300;
		
		//cornerRadius = borderSize * 4;
				
		var size:Float = 100;
		backgroundFocusOut.graphics.beginFill(backgroundFocusOutColor);
        //backgroundFocusOut.graphics.drawRoundRect(0, 0, size, size, cornerRadius);
		backgroundFocusOut.graphics.drawRect(0, 0, size, size);
        backgroundFocusOut.graphics.endFill();
		backgroundFocusOut.x = backgroundFocusOut.y = borderSize;
		Reflect.setProperty(backgroundFocusOut, "noAddedEvent", true);
		
		backgroundFocusIn.graphics.beginFill(backgroundFocusInColor);
        //backgroundFocusIn.graphics.drawRoundRect(0, 0, size, size, cornerRadius);
		backgroundFocusIn.graphics.drawRect(0, 0, size, size);
        backgroundFocusIn.graphics.endFill();
		backgroundFocusIn.x = backgroundFocusIn.y = - borderSize;
		Reflect.setProperty(backgroundFocusIn, "noAddedEvent", true);
		
		backgroundBorder.graphics.beginFill(backgroundBorderColor);
        //backgroundBorder.graphics.drawRoundRect(0, 0, size, size, cornerRadius);
		backgroundBorder.graphics.drawRect(0, 0, size, size);
        backgroundBorder.graphics.endFill();
		Reflect.setProperty(backgroundBorder, "noAddedEvent", true);
				
		this.addEventListener( FocusEvent.FOCUS_IN, focusInHandler );
		this.addEventListener( FocusEvent.FOCUS_OUT, focusOutHandler );
		
		this.addChild( backgroundBorder );
		this.addChild( backgroundFocusOut );
		textField.x = textField.y = padding;
		this.addChild( textField );
		
		this.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
	}
	
	private function addedToStageHandler(event:Event):Void
	{
		this.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
	}
	
	private function focusInHandler(event:FocusEvent = null):Void
	{
		hasFocus = true;
		if( this.getChildIndex( backgroundFocusIn ) == -1 ) 
		{
			this.addChildAt( backgroundFocusIn, 0 );
		}
		drawRoundRect( backgroundBorder, textField.width + padding * 2, textField.height + padding * 2, backgroundBorderColor );
		drawRoundRect( backgroundFocusIn, backgroundBorder.width + borderSize * 2, backgroundBorder.height + borderSize * 2, backgroundFocusInColor );
		drawRoundRect( backgroundFocusOut, backgroundBorder.width - borderSize * 2, backgroundBorder.height - borderSize * 2, backgroundFocusOutColor );
	}
	
	private function focusOutHandler(event:FocusEvent = null):Void
	{
		hasFocus = false;
		if( this.getChildIndex( backgroundFocusIn ) != -1 ) this.removeChild( backgroundFocusIn );
		drawRoundRect( backgroundBorder, textField.width + padding * 2, textField.height + padding * 2, backgroundBorderColor );
		drawRoundRect( backgroundFocusOut, backgroundBorder.width - borderSize * 2, backgroundBorder.height - borderSize * 2, backgroundFocusOutColor );
	}
	
	private function drawRoundRect(sprite:Sprite, width:Float, height:Float, color:Int):Void
	{
		sprite.graphics.clear();
		sprite.graphics.beginFill(color);
        //sprite.graphics.drawRoundRect(0, 0, width, height, cornerRadius);
		sprite.graphics.drawRect(0, 0, width, height);
        sprite.graphics.endFill();
	}
	
	//override private function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void
	override private function measure():Void
	{
		createLabel();
		super.measure();
		//super.updateDisplayList(unscaledWidth, unscaledHeight);
	}
	
	private function createLabel():Void
	{
		//this.textField.width = Math.isNaN( this.width ) ? 300 : this.width - padding * 2;
		
		var textField:TextField = new TextField();
		if( this.textFormat != null ) textField.defaultTextFormat = this.textFormat;
		textField.text = "A";
		textField.autoSize = TextFieldAutoSize.LEFT;
		this.textField.height = textField.height;
		
		if( this.textFormat != null ) this.textField.defaultTextFormat = this.textFormat;
		this.textField.text = this.text;
		
		if( hasFocus )
		{
			focusInHandler();
		}
		else
		{
			focusOutHandler();
		}
	}
	
	@:dox(hide)
	override public function dispose():Void
	{
		super.dispose();
		
		this.removeEventListener( FocusEvent.FOCUS_IN, focusInHandler );
		this.removeEventListener( FocusEvent.FOCUS_OUT, focusOutHandler );
	}
}