/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.controls;

import openfl.display.Sprite;
import openfl.events.Event;
//import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;
import openflexUI.controls.UIComponent;

/**
 * A Label component displays one line of plain text. Label components do not have borders.
 */
class Label extends UIComponent
{	
	private var textField:TextFieldUI = new TextFieldUI();
	
	private var _text:String = "";
	/**
		 * Gets or sets the plain text to be displayed by the Label component.
		 */
	public var text(get, set):String;
	
	private function get_text():String
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
	
	private function get_textFormat():TextFormat
	{
		return _textFormat;
	}
	
	private function set_textFormat(value:TextFormat)
	{
		_textFormat = value;
		createChildren();
		return value;
	}
		
	@:dox(hide)
	public function new()
	{
		super();
		textField.noAddedEvent = true;
		textField.selectable = false;
		this.addChild( textField );
		this.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
	}
	
	private function addedToStageHandler(event:Event):Void
	{
		this.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
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
		if( this.textFormat != null ) textField.defaultTextFormat = this.textFormat;
		textField.text = Math.isNaN( maxWidth ) ? this.text : truncateLabel( this.text );
		textField.autoSize = TextFieldAutoSize.LEFT;
	}
	
	@:dox(hide)
	public function truncateLabel(text:String, padding:Float = 0, maxWidth:Float = null):String
	{
		if( maxWidth == null ) maxWidth = this.maxWidth;
		var textField:TextFieldUI = new TextFieldUI();
		if( this.textFormat != null ) textField.defaultTextFormat = this.textFormat;
		textField.text = text;
		textField.autoSize = TextFieldAutoSize.LEFT;
		if( textField.width + padding > maxWidth )
		{
			var originalText:String = textField.text;
			for(i in 0...originalText.length)
			{
				textField.text = originalText.substring(0, i) + "...";
				if (textField.width + padding > maxWidth)
				{
					return originalText.substring(0, i - 1) + "...";
				}
			}
		}
		return text;
	}
	
	@:dox(hide)
	override public function dispose():Void
	{
		super.dispose();
	}
}