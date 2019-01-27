/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.controls;

import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openflexUI.events.FlexEvent;
import openflexUI.layout.HorizontalLayout;
import openflexUI.layout.VerticalLayout;

class UIComponent extends Sprite
{
	private var isCreating:Bool;
	public var isCreated:Bool;
	public var layout:Dynamic;
	//public var isUIComponent:Bool = true;
	public var includeInLayout:Bool = true;
	private var isEnd:Bool;
	private var previousBounds:Rectangle = new Rectangle();
	
	public function new()
	{
		super();
		Reflect.setProperty(this, "isUIComponent", true);
		this.visible = false;
		style();
		this.addEventListener(Event.ADDED, addedHandler);
		this.addEventListener(Event.REMOVED, removedHandler);
		this.addEventListener(Event.RENDER, renderHandler);
	}
	
	private function style():Void
	{
		//trace("STYLE");
		this.dispatchEvent( new FlexEvent( FlexEvent.PREINITIALIZE ) );
	}
	
	private function createChildren():Void
	{
		//trace("CREATE CHILDREN");
		//this.addChild();
		if( ! isCreating )
		{
			this.addEventListener( Event.ENTER_FRAME, enterFrameCreationHandler );
			isCreating = true;
		}
	}
	
	private function enterFrameCreationHandler(event:Event = null):Void
	{
		isCreating = false;
		this.removeEventListener( Event.ENTER_FRAME, enterFrameCreationHandler );
		invalidateProperties();
		invalidateSize();
		invalidateDisplayList();
	}
	
	public function invalidateProperties():Void
	{
		commitProperties();
	}
	
	public function invalidateSize():Void
	{
		measure();
	}
	
	public function invalidateDisplayList():Void
	{
		updateDisplayList(Math.NaN, Math.NaN);
	}
	
	private function commitProperties():Void
	{
		//trace("COMMIT PROPERTIES");
	}
	
	private function measure():Void
	{
		//trace("MEASURE");
		this.dispatchEvent( new FlexEvent( FlexEvent.INITIALIZE ) );
	}
	
	private function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void
	{
		//trace("UPDATELIST");
		//trace(this.width, this.height);
		//trace( this.name );
		for(i in 0...this.numChildren)
		{
			if( Reflect.hasField( this.getChildAt(i), "isUIComponent" ) )
			{
				if( ! cast( this.getChildAt(i), UIComponent ).includeInLayout ) continue;
			}
			if( Std.is( this.layout, VerticalLayout ) )
			{
				if( i > 0 )
				{
					this.getChildAt(i).y = this.getChildAt(i-1).y + this.getChildAt(i-1).height + this.layout.gap;
				}
			}
			else if( Std.is( this.layout, HorizontalLayout ) )
			{
				if( i > 0 )
				{
					this.getChildAt(i).x = this.getChildAt(i-1).x + this.getChildAt(i-1).width + this.layout.gap;
				}
			}
		}
		this.visible = true;
		//trace( this.name );
		this.dispatchEvent( new FlexEvent( FlexEvent.COMPONENT_COMPLETE ) );
		isEnd = true;
		checkIsEnd( this );
		if( ! isEnd ) return;
		if( ! isCreated )
		{
			isCreated = true;
			this.dispatchEvent( new FlexEvent( FlexEvent.CREATION_COMPLETE ) );
		}
		else
		{
			this.dispatchEvent( new Event( Event.RESIZE ) );
		}
		previousBounds = this.getBounds( this.parent );
		this.removeEventListener( FlexEvent.COMPONENT_COMPLETE, creationCompleteHandler );
	}
	
	private function checkIsEnd(component:UIComponent):Void
	{
		if( ! isEnd ) return;
		for(i in 0...component.numChildren)
		{
			if( Reflect.hasField( component.getChildAt(i), "isUIComponent" ) )
			{
				var subComponent:UIComponent = cast( component.getChildAt(i), UIComponent );
				if( subComponent.isCreating )
				{
					isEnd = false;
					return;
				}
				if( subComponent.numChildren > 0 )
				{
					checkIsEnd( subComponent );
				}
			}
		}
	}
	
	private function addedHandler(event:Event):Void
	{
		if( event.target == this ) return;
		//trace( cast( event.target, Sprite ).name );
		//if( Std.is( event.target, UIComponent ) )
		if( Reflect.hasField( event.target, "isUIComponent" ) )
		{
			cast( event.target, UIComponent ).addEventListener( FlexEvent.COMPONENT_COMPLETE, creationCompleteHandler );
		}
		createChildren();
	}
	
	private function removedHandler(event:Event):Void
	{
		if( event.target == this ) return;
		//if( Std.is( event.target, UIComponent ) )
		if( Reflect.hasField( event.target, "isUIComponent" ) )
		{
			cast( event.target, UIComponent ).removeEventListener( FlexEvent.COMPONENT_COMPLETE, creationCompleteHandler );
		}
		createChildren();
	}
	
	private function renderHandler(event:Event):Void
	{
		if( this.getBounds( this.parent ).equals( this.previousBounds ) ) return;
		//if( Std.is( event.target, UIComponent ) )
		if( Reflect.hasField( event.target, "isUIComponent" ) )
		{
			cast( event.target, UIComponent ).addEventListener( FlexEvent.COMPONENT_COMPLETE, creationCompleteHandler );
		}
		createChildren();
	}
	
	private function creationCompleteHandler(event:FlexEvent):Void
	{
		//cast( event.target, UIComponent ).removeEventListener( FlexEvent.COMPONENT_COMPLETE, creationCompleteHandler );
		//trace( "creationCompleteHandler" + this.name );
		invalidateProperties();
		invalidateSize();
		invalidateDisplayList();
	}
	
	public function validate():Void
	{
		if( isCreating )
		{
			enterFrameCreationHandler();
			for(i in 0...this.numChildren)
			{
				if( Reflect.hasField( this.getChildAt(i), "isUIComponent" ) )
				{
					cast( this.getChildAt(i), UIComponent ).validate();
				}
			}
		}
	}
	
	public function dispose():Void
	{
		this.removeEventListener(Event.ADDED, addedHandler);
		this.removeEventListener(Event.REMOVED, removedHandler);
		this.removeEventListener(Event.RENDER, renderHandler);
	}
}