/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.controls;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openflexUI.controls.UIComponent;

/**
 * A Label component displays one line of plain text. Label components do not have borders.
 */
class Label extends UIComponent
{	
	private var textField:TextField = new TextField();
	
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
		createChildren();
		return _text = value;
	}
	
	@:dox(hide)
	public function new()
	{
		super();
		var sprite:Sprite = new Sprite();
		textField.selectable = false;
		sprite.addChild( textField );
		this.addChild(sprite);
		this.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
	}
	
	private function addedToStageHandler(event:Event):Void
	{
		this.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
	}
	
	override private function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void
	{
		createLabel();
		super.updateDisplayList(unscaledWidth, unscaledHeight);
	}
	
	private function createLabel():Void
	{
		textField.text = this.text;
		textField.autoSize = TextFieldAutoSize.LEFT;
	}
	
	@:dox(hide)
	override public function dispose():Void
	{
		super.dispose();
	}
}