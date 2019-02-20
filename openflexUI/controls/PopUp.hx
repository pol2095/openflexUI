/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.controls;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;
import openflexUI.events.CloseEvent;
import openflexUI.events.FlexEvent;

/**
 * Adds a display object as a pop-up above all content.
 */
class PopUp extends Sprite
{
	private var _isOpen:Bool = false;
	/**
		 * Indicates is the pop-up is open.
		 */
	public var isOpen(get, never):Bool;
	
	private function get_isOpen()
	{
		return _isOpen;
	}
	
	private var isCreated:Bool = false;
	
	private var background:Sprite;
	private var container:UIComponent;
	private var popUp:UIComponent;
	
	private var _isCentered:Bool = false;
	/**
		 * Indicates is the pop-up is centered on the stage.
		 *
		 * The default value is `false`
		 */
	public var isCentered(get, set):Bool;
	
	private function get_isCentered()
	{
		return _isCentered;
	}
	
	private function set_isCentered(value:Bool)
	{
		_isCentered = value;
		resizeHandler();
		return _isCentered;
	}
	
	private var _isModal:Bool = false;
	/**
		 * Indicates if the pop-up is modal, meaning that an overlay will be displayed between the pop-up and everything under the pop-up manager, and the overlay will block touches..
		 *
		 * The default value is `false`
		 */
	public var isModal(get, set):Bool;
	
	private function get_isModal()
	{
		return _isModal;
	}
	
	private function set_isModal(value:Bool)
	{
		if( value == _isModal ) return _isModal;
		_isModal = value;
		if( ! isCreated ) return _isModal;
		if( ! value )
		{
			this.removeChild(background);
		}
		else
		{
			this.addChildAt(background, 0);
		}
		return _isModal;
	}
	
	@:dox(hide)
	public function new()
	{
		super();
		this.visible = false;
		
		this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}
	
	private function addedToStageHandler(event:Event):Void
	{
		this.removeEventListener(Event.ADDED, addedToStageHandler);
		stage.addEventListener(Event.RESIZE, resizeHandler);
		if( isCreated )
		{
			this.setChildIndex( parent, this.numChildren - 1 );
			resizeHandler();
			this.visible = true;
			this.dispatchEvent( new Event( Event.OPEN ) );
		}
	}
	
	/**
		 * Adds a pop-up to the stage.
		 *  
		 * @param  popUp The displayObject popUp
		 * @param  stage The stage  
	**/
	public function open(popUp:DisplayObject, stage:Stage):Void
	{
		if( isOpen ) return;
		_isOpen = true;
		if( ! isCreated )
		{
			cast(stage, DisplayObjectContainer).addChild( this );
			background = new Sprite();
			background.graphics.beginFill(0x000000);
			background.graphics.drawRect(0, 0, 100, 100);
			background.graphics.endFill();
			background.alpha = 0.6;
			if( isModal ) this.addChild(background);
			container = new UIComponent();
			container.addChild(popUp);
			this.addChild(container);
			if( Reflect.hasField( popUp, "isUIComponent" ) )
			{
				this.popUp = cast( popUp, UIComponent );
				if( ! cast( popUp, UIComponent ).isCreated )
				{
					popUp.addEventListener( FlexEvent.CREATION_COMPLETE, creationCompleteHandler );
				}
				else
				{
					creationCompleteHandler();
				}
				popUp.addEventListener( Event.RESIZE, creationCompleteHandler );
			}
			else
			{
				creationCompleteHandler();
			}
		}
	}
	
	private function creationCompleteHandler(event:FlexEvent = null):Void
	{
		isCreated = true;
		if( stage != null )
		{
			this.setChildIndex( parent, this.numChildren - 1 );
			resizeHandler();
			if( ! this.visible ) this.visible = true;
			this.dispatchEvent( new Event( Event.OPEN ) );
		}
	}
	
	/**
		 * Removes a pop-up from the stage.
		 * 
		 * @see <http://pol2095.free.fr/openflexUI/docs/openflexUI/events/CloseEvent.html>
		 * 
		 * @param detail Identifies the button in the popped up control that was clicked. The default value is `-1`.
		 * @param dispose Disposes the resources of all children. The default value is `false`. 
	**/
	public function close(detail:Int = -1, dispose:Bool = false):Void
	{
		if( ! isOpen ) return;
		_isOpen = false;
		this.removeChild(container);
		this.removeChild(background);
		this.dispatchEvent( new CloseEvent( Event.CLOSE, false, false, detail ) );
		if( dispose ) this.dispose();
	}
	
	private function resizeHandler(event:Event = null):Void
	{
		if( ! isCreated ) return;
		if( isModal )
		{
			background.width = stage.stageWidth;
			background.height = stage.stageHeight;
		}
		if( isCentered )
		{
			container.x = ( stage.stageWidth - container.width ) / 2;
			trace( stage.stageHeight, container.height );
			container.y = ( stage.stageHeight - container.height ) / 2;
		}
	}
	
	/**
		 * Disposes the resources of all children.
		 */
	public function dispose():Void
	{
		if( isOpen ) this.close();
		isCreated = false;
		if( popUp != null )
		{
			popUp.removeEventListener( FlexEvent.CREATION_COMPLETE, creationCompleteHandler );
			popUp.removeEventListener( Event.RESIZE, creationCompleteHandler );
			popUp.dispose();
		}
		if( stage != null ) stage.removeEventListener(Event.RESIZE, resizeHandler);
	}
}