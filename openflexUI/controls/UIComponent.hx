/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.controls;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openflexUI.events.FlexEvent;
import openflexUI.layouts.HorizontalLayout;
import openflexUI.layouts.VerticalLayout;

/**
 * The UIComponent class is the base class for all visual components, both interactive and noninteractive.
 */
class UIComponent extends Sprite
{
	private var isCreating:Bool;
	/**
		 * Determines if the component has been initialized and validated for the first time.
		 */
	public var isCreated:Bool;
	
	private var _layout:Dynamic;
	/**
		 * Controls the way that the group's children are positioned and sized.
		 */
	public var layout(get, set):Dynamic;
	
	private function get_layout()
	{
		return _layout;
	}
	
	private function set_layout(value:Dynamic)
	{
		createChildren();
		return _layout = value;
	}
	
	//public var isUIComponent:Bool = true;
	
	private var _includeInLayout:Bool = true;
	/**
		 * Determines if the layout should use this object or ignore it.
		 */
	public var includeInLayout(get, set):Bool;
	
	private function get_includeInLayout()
	{
		return _includeInLayout;
	}
	
	private function set_includeInLayout(value:Bool)
	{
		createChildren();
		return _includeInLayout = value;
	}
	
	private var isEnd:Bool;
	private var previousContentSize:Rectangle = new Rectangle();
	
	/**
		 * The width of the viewport's content.
		 */
	public var contentWidth(get, never):Float;
	
	private function get_contentWidth()
	{
		var width:Float = 0;
		var childrens:Array<DisplayObject> = [];
		var childrenPosition:Array<Int> = [];
		var i:Int = this.numChildren - 1;
		while(i >= 0)
		{
			if( Reflect.hasField( this.getChildAt(i), "isUIComponent" ) )
			{
				if( ! cast( this.getChildAt(i), UIComponent ).includeInLayout )
				{
					childrens.push( this.getChildAt(i) );
					childrenPosition.push( this.getChildIndex( this.getChildAt(i) ) );
					this.removeChild( this.getChildAt(i) );
				}
			}
			i--;
		}
		childrens.reverse();
		childrenPosition.reverse();
		
		width = super.width;
		
		for(i in 0...childrens.length)
		{
			this.addChildAt( childrens[i], childrenPosition[i] );
		}
		return width;
	}
	
	/**
		 * The height of the viewport's content.
		 */
	public var contentHeight(get, never):Float;
	
	private function get_contentHeight()
	{
		var height:Float = 0;
		var childrens:Array<DisplayObject> = [];
		var childrenPosition:Array<Int> = [];
		var i:Int = this.numChildren - 1;
		while(i >= 0)
		{
			if( Reflect.hasField( this.getChildAt(i), "isUIComponent" ) )
			{
				if( ! cast( this.getChildAt(i), UIComponent ).includeInLayout )
				{
					childrens.push( this.getChildAt(i) );
					childrenPosition.push( this.getChildIndex( this.getChildAt(i) ) );
					this.removeChild( this.getChildAt(i) );
				}
			}
			i--;
		}
		childrens.reverse();
		childrenPosition.reverse();
		
		height = super.height;
		
		for(i in 0...childrens.length)
		{
			this.addChildAt( childrens[i], childrenPosition[i] );
		}
		return height;
	}
	
	@:dox(hide)
	public function new()
	{
		super();
		Reflect.setProperty(this, "isUIComponent", true);
		this.visible = false;
		style();
		this.addEventListener(Event.ADDED, addedHandler);
		this.addEventListener(Event.REMOVED, removedHandler);
		this.addEventListener(Event.RENDER, renderHandler);
		this.addEventListener(FlexEvent.VALUE_COMMIT, valueCommitHandler);
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
	
	/**
		 * Marks a component so that its commitProperties() method gets called during a later screen update.
		 */
	public function invalidateProperties():Void
	{
		commitProperties();
	}
	
	/**
		 * Marks a component so that its measure() method gets called during a later screen update.
		 */
	public function invalidateSize():Void
	{
		measure();
	}
	
	/**
		 * Marks a component so that its updateDisplayList() method gets called during a later screen update.
		 */
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
		//trace(this.name, this.width, this.height);
		var _width:Float = 0;
		var _height:Float = 0;
		var previous:Int = 0;
		
		for(i in 0...this.numChildren)
		{
			if( Reflect.hasField( this.getChildAt(i), "isUIComponent" ) )
			{
				if( ! cast( this.getChildAt(i), UIComponent ).includeInLayout )
				{
					cast( this.getChildAt(i), UIComponent ).x = cast( this.getChildAt(i), UIComponent ).y = 0;
					continue;
				}
			}
			if( Std.is( this.layout, VerticalLayout ) )
			{
				this.getChildAt(i).y = i == 0 ? 0 : this.getChildAt(previous).y + this.getChildAt(previous).height + this.layout.gap;
				previous = i;
				if( this.getChildAt(i).width > _width ) _width = this.getChildAt(i).width;
			}
			else if( Std.is( this.layout, HorizontalLayout ) )
			{
				this.getChildAt(i).x = i == 0 ? 0 : this.getChildAt(previous).x + this.getChildAt(previous).width + this.layout.gap;
				previous = i;
				if( this.getChildAt(i).height > _height ) _height = this.getChildAt(i).height;
			}
		}
		for(i in 0...this.numChildren)
		{
			if( Reflect.hasField( this.getChildAt(i), "isUIComponent" ) )
			{
				if( ! cast( this.getChildAt(i), UIComponent ).includeInLayout )	continue;
			}
			if( Std.is( this.layout, VerticalLayout ) )
			{
				if( this.layout.horizontalAlign == "left" )
				{
					this.getChildAt(i).x = 0;
				}
				else if( this.layout.horizontalAlign == "center" )
				{
					this.getChildAt(i).x = ( _width - this.getChildAt(i).width ) / 2;
				}
				else if( this.layout.horizontalAlign == "top" )
				{
					this.getChildAt(i).x = _width - this.getChildAt(i).width;
				}
			}
			else if( Std.is( this.layout, HorizontalLayout ) )
			{
				if( this.layout.verticalAlign == "top" )
				{
					this.getChildAt(i).y = 0;
				}
				else if( this.layout.verticalAlign == "middle" )
				{
					this.getChildAt(i).y = ( _height - this.getChildAt(i).height ) / 2;
				}
				else if( this.layout.verticalAlign == "top" )
				{
					this.getChildAt(i).y = _height - this.getChildAt(i).height;
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
		previousContentSize = new Rectangle( 0, 0, this.contentWidth, this.contentHeight );
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
			if( ! cast( event.target, UIComponent ).includeInLayout ) return;
			cast( event.target, UIComponent ).addEventListener( FlexEvent.COMPONENT_COMPLETE, creationCompleteHandler );
		}
		if( Reflect.hasField( event.target, "noLayout" ) ) return;
		createChildren();
	}
	
	private function removedHandler(event:Event):Void
	{
		if( event.target == this ) return;
		//if( Std.is( event.target, UIComponent ) )
		if( Reflect.hasField( event.target, "isUIComponent" ) )
		{
			if( ! cast( event.target, UIComponent ).includeInLayout ) return;
			cast( event.target, UIComponent ).removeEventListener( FlexEvent.COMPONENT_COMPLETE, creationCompleteHandler );
		}
		if( Reflect.hasField( event.target, "noLayout" ) ) return;
		createChildren();
	}
	
	private function renderHandler(event:Event):Void
	{
		var contentSize:Rectangle = new Rectangle( 0, 0, this.contentWidth, this.contentHeight );
		if( contentSize.equals( previousContentSize ) ) return;
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
	
	private function valueCommitHandler(event:FlexEvent):Void
	{
		createChildren();
	}
	
	/**
		 * Validate and update the properties and layout of this object and redraw it, if necessary.
		 */
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
	
	/**
		 * Disposes the resources of all children.
		 */
	public function dispose():Void
	{
		this.removeEventListener(Event.ADDED, addedHandler);
		this.removeEventListener(Event.REMOVED, removedHandler);
		this.removeEventListener(Event.RENDER, renderHandler);
		this.removeEventListener(FlexEvent.VALUE_COMMIT, valueCommitHandler);
	}
}