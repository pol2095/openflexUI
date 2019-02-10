/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.controls;

import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openflexUI.controls.UIComponent;

/**
 * The Button component represents a commonly used rectangular button. Button components display a text label.
 */
class Button extends UIComponent
{	
	private var background:Sprite = new Sprite();
	private var backgroundOver:Sprite = new Sprite();
	private var backgroundDown:Sprite = new Sprite();
	private var labelUI:Label = new Label();
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
		createChildren();
		return _label = value;
	}
	
	private var _enabled:Bool = true;
	/**
		 * Gets or sets a value that indicates whether the component can accept user input.
		 * 
		 * The default value is `true`
		 */
	public var enabled(get, set):Bool;
	
	private function get_enabled()
	{
		return _enabled;
	}
	
	private function set_enabled(value:Bool)
	{
		createChildren();
		return _enabled = value;
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
		backgroundOver.graphics.beginFill(0xafafaf);
        backgroundOver.graphics.drawRect(1, 1, 98, 98);
        backgroundOver.graphics.endFill();
		backgroundOver.scale9Grid = new Rectangle( 1, 1, 98, 98 );
		
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
		
		labelUI.x = labelUI.y = padding;
		this.addChild( labelUI );
		
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
	}
	
	private function mouseUpHandler(event:MouseEvent):Void
	{
		removeBackground();
		var rect:Rectangle = this.getBounds( stage );
		if( rect.contains( stage.mouseX, stage.mouseY ) )
		{
			state = "overState";
			this.addChild( backgroundOver );
			this.setChildIndex( backgroundOver, 0 );
		}
		else
		{
			state = "upState";
			this.addChild( background );
			this.setChildIndex( background, 0 );
		}
	}
	
	private function rollOverHandler(event:MouseEvent):Void
	{
		removeBackground();
		state = "overState";
		this.addChild( backgroundOver );
		this.setChildIndex( backgroundOver, 0 );
	}
	
	private function rollOutHandler(event:MouseEvent):Void
	{
		removeBackground();
		state = "upState";
		this.addChild( background );
		this.setChildIndex( background, 0 );
	}
	
	private function removeBackground():Void
	{
		if( state == "upState" )
		{
			this.removeChild( background );
		}
		else if( state == "overState" )
		{
			this.removeChild( backgroundOver );
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
		labelUI.text = this.label;
		labelUI.validate();
		background.width = backgroundOver.width = backgroundDown.width = labelUI.width + padding * 2;
		background.height = backgroundOver.height = backgroundDown.height = labelUI.height + padding * 2;
		if( this.enabled )
		{
			this.alpha = 1;
			this.mouseEnabled = this.mouseChildren = true;
		}
		else
		{
			this.alpha = 0.5;
			this.mouseEnabled = this.mouseChildren = false;
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