/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.controls;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
//import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openflexUI.events.FlexEvent;
import openflexUI.layouts.HorizontalLayout;
import openflexUI.layouts.VerticalLayout;

/**
 * The UIComponent class is the base class for all visual components, both interactive and noninteractive.
 */
class UIComponent extends SpriteUI
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
	
	private function get_layout():Dynamic
	{
		return _layout;
	}
	
	private function set_layout(value:Dynamic)
	{
		_layout = value;
		createChildren();
		return value;
	}
	
	//public var isUIComponent:Bool = true;
	
	private var _includeInLayout:Bool = true;
	/**
		 * Determines if the layout should use this object or ignore it.
		 *
		 * The default value is `true`
		 */
	public var includeInLayout(get, set):Bool;
	
	private function get_includeInLayout():Bool
	{
		return _includeInLayout;
	}
	
	private function set_includeInLayout(value:Bool)
	{
		_includeInLayout = value;
		createChildren();
		return value;
	}
	
	private var isEnd:Bool;
	//private var previousContentSize:Rectangle = new Rectangle();
	
	@:dox(hide)
	#if flash @:getter(width) public #else override public #end function get_width():Float
	{
		if( this.mask == null ) return getWidth();
		return this.mask.width;
	}
	
	@:dox(hide)
	#if flash @:setter(width) public #else override public #end function set_width(value:Float)
	{
		if( isCreating ) invalidateSize();
		super.width = value;
		createChildren();
		#if !flash return value; #end
	}
	
	@:dox(hide)
	#if flash @:getter(height) public #else override public #end function get_height():Float
	{
		if( this.mask == null ) return getHeight();
		return this.mask.height;
	}
	
	@:dox(hide)
	#if flash @:setter(height) public #else override public #end function set_height(value:Float)
	{
		if( isCreating ) invalidateSize();
		super.height = value;
		createChildren();
		#if !flash return value; #end
	}
	
	private function getWidth():Float
	{
		var width:Float = 0;
		var childrens:Array<DisplayObject> = [];
		var childrenPosition:Array<Int> = [];
		var i:Int = this.numChildren - 1;
		while(i >= 0)
		{
			if( Std.is( this.getChildAt(i), UIComponent ) )
			{
				if( ! cast( this.getChildAt(i), UIComponent ).includeInLayout )
				{
					childrens.push( this.getChildAt(i) );
					childrenPosition.push( this.getChildIndex( this.getChildAt(i) ) );
					this.removeChild( this.getChildAt(i) );
				}
			}
			if( hasField( this.getChildAt(i), "noLayout" ) )
			{
				childrens.push( this.getChildAt(i) );
				childrenPosition.push( this.getChildIndex( this.getChildAt(i) ) );
				this.removeChild( this.getChildAt(i) );
			}
			i--;
		}
		childrens.reverse();
		childrenPosition.reverse();
		
		//width = super.width;
		width = measureSize( this ).width;
		
		for(i in 0...childrens.length)
		{
			this.addChildAt( childrens[i], childrenPosition[i] );
		}
		return width;
	}
	
	/**
		 * The width of the viewport's content.
		 */
	public var contentWidth(get, never):Float;
	
	private function get_contentWidth():Float
	{
		return getWidth();
	}
	
	private function getHeight():Float
	{
		var height:Float = 0;
		var childrens:Array<DisplayObject> = [];
		var childrenPosition:Array<Int> = [];
		var i:Int = this.numChildren - 1;
		while(i >= 0)
		{
			if( Std.is( this.getChildAt(i), UIComponent ) )
			{
				if( ! cast( this.getChildAt(i), UIComponent ).includeInLayout )
				{
					childrens.push( this.getChildAt(i) );
					childrenPosition.push( this.getChildIndex( this.getChildAt(i) ) );
					this.removeChild( this.getChildAt(i) );
				}
			}
			if( hasField( this.getChildAt(i), "noLayout" ) )
			{
				childrens.push( this.getChildAt(i) );
				childrenPosition.push( this.getChildIndex( this.getChildAt(i) ) );
				this.removeChild( this.getChildAt(i) );
			}
			i--;
		}
		childrens.reverse();
		childrenPosition.reverse();
		
		//height = super.height;
		height = measureSize( this ).height;
		
		for(i in 0...childrens.length)
		{
			this.addChildAt( childrens[i], childrenPosition[i] );
		}
		return height;
	}
	
	/**
		 * The height of the viewport's content.
		 */
	public var contentHeight(get, never):Float;
	
	private function get_contentHeight():Float
	{
		return getHeight();
	}
	
	private var rect:Rectangle;
	private function measureSize(container:DisplayObjectContainer):Rectangle
	{
		if( container == this ) this.rect = new Rectangle();
		if( container.numChildren == 0 ) return this.rect;
		for(i in 0...container.numChildren)
		{
			var displayObject:DisplayObject = container.getChildAt(i);
			var rect:Rectangle = bounds( displayObject );
			this.rect = this.rect.union( rect );
			if( displayObject.mask != null ) continue;
			if( ! Std.is( displayObject, DisplayObjectContainer ) ) continue;
			measureSize( cast( displayObject, DisplayObjectContainer ) );
		}
		if( container == this )
		{
			this.rect.width *= this.scaleX;
			this.rect.height *= this.scaleY;
		}
		return this.rect;
	}
	
	private function bounds(displayObject:DisplayObject):Rectangle
	{
		var rect:Rectangle= new Rectangle();
		var point:Point = new Point( displayObject.x, displayObject.y );
		point = displayObject.parent.localToGlobal( point );
		point = this.globalToLocal( point );
		rect.x = point.x;
		rect.y = point.y;
		point = new Point( displayObject.x + displayObject.width, displayObject.y + displayObject.height );
		point = displayObject.parent.localToGlobal( point );
		point = this.globalToLocal( point );
		rect.width = point.x - rect.x;
		rect.height = point.y - rect.y;
		return rect;
	}
	
	private var _enabled:Bool = true;
	/**
		 * Gets or sets a value that indicates whether the component can accept user input.
		 * 
		 * The default value is `true`
		 */
	public var enabled(get, set):Bool;
	
	private function get_enabled():Bool
	{
		return _enabled;
	}
	
	private function set_enabled(value:Bool)
	{
		_enabled = value;
		createChildren();
		return value;
	}
	
	private var _maxWidth:Float = Math.NaN;
	/**
		 * The maximum recommended width of the component to be considered by the parent during layout.
		 */
	public var maxWidth(get, set):Float;
	
	private function get_maxWidth():Float
	{
		return _maxWidth;
	}
	
	private function set_maxWidth(value:Float)
	{
		_maxWidth = value;
		createChildren();
		return value;
	}
	
	private var _maxHeight:Float = Math.NaN;
	/**
		 * The maximum recommended height of the component to be considered by the parent during layout.
		 */
	public var maxHeight(get, set):Float;
	
	private function get_maxHeight():Float
	{
		return _maxHeight;
	}
	
	private function set_maxHeight(value:Float)
	{
		_maxHeight = value;
		createChildren();
		return value;
	}
	
	private var _minWidth:Float = Math.NaN;
	/**
		 * The minimum recommended width of the component to be considered by the parent during layout.
		 */
	public var minWidth(get, set):Float;
	
	private function get_minWidth():Float
	{
		return _minWidth;
	}
	
	private function set_minWidth(value:Float)
	{
		_minWidth = value;
		createChildren();
		return value;
	}
	
	private var _minHeight:Float = Math.NaN;
	/**
		 * The minimum recommended height of the component to be considered by the parent during layout.
		 */
	public var minHeight(get, set):Float;
	
	private function get_minHeight():Float
	{
		return _minHeight;
	}
	
	private function set_minHeight(value:Float)
	{
		_minHeight = value;
		createChildren();
		return value;
	}
	
	@:dox(hide)
	public function new()
	{
		super();
		//Reflect.setProperty(this, "isUIComponent", true);
		this.visible = false;
		style();
		this.addEventListener(Event.ADDED, addedHandler);
		this.addEventListener(Event.REMOVED, removedHandler);
		//this.addEventListener(Event.RENDER, renderHandler);
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
		if( ! isCreating )
		{
			this.addEventListener( Event.ENTER_FRAME, enterFrameCreationHandler );
			isCreating = true;
		}
	}
	
	private function enterFrameCreationHandler(event:Event = null):Void
	{
		//isCreating = false;
		this.removeEventListener( Event.ENTER_FRAME, enterFrameCreationHandler );
		
		isEnd = true;
		checkIsEnd( this );
		if( ! isEnd ) return;
		
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
		var _width:Float = 0;
		var _height:Float = 0;
		var previous:Int = -1;
		
		for(i in 0...this.numChildren)
		{
			if( Std.is( this.getChildAt(i), UIComponent ) )
			{
				if( ! cast( this.getChildAt(i), UIComponent ).includeInLayout )
				{
					cast( this.getChildAt(i), UIComponent ).x = cast( this.getChildAt(i), UIComponent ).y = 0;
					continue;
				}
				if( Std.is( this.layout, VerticalLayout ) )
				{
					if( this.layout.horizontalAlign == "contentJustify" || this.layout.horizontalAlign == "justify" ) continue;
				}
			}
			if( hasField( this.getChildAt(i), "noLayout" ) ) continue;
			if( Std.is( this.layout, VerticalLayout ) )
			{
				this.getChildAt(i).y = previous == -1 ? 0 : this.getChildAt(previous).y + this.getChildAt(previous).height + this.layout.gap;
				previous = i;
				if( this.getChildAt(i).width > _width ) _width = this.getChildAt(i).width;
			}
			else if( Std.is( this.layout, HorizontalLayout ) )
			{
				this.getChildAt(i).x = previous == -1 ? 0 : this.getChildAt(previous).x + this.getChildAt(previous).width + this.layout.gap;
				previous = i;
				if( this.getChildAt(i).height > _height ) _height = this.getChildAt(i).height;
			}
		}
		for(i in 0...this.numChildren)
		{
			if( Std.is( this.getChildAt(i), UIComponent ) )
			{
				if( ! cast( this.getChildAt(i), UIComponent ).includeInLayout )	continue;
			}
			if( hasField( this.getChildAt(i), "noLayout" ) ) continue;
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
		this.dispatchEvent( new FlexEvent( FlexEvent.INITIALIZE ) );
	}
	
	private function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void
	{
		//trace("UPDATELIST");
		/*var contentWidth:Float = this.contentWidth;
		var contentHeight:Float = this.contentHeight;*/
		//this.visible = true;
		/*isEnd = true;
		checkIsEnd( this );
		if( ! isEnd ) return;*/
		isCreating = false;
		if( ! isCreated )
		{
			isCreated = true;
			this.dispatchEvent( new FlexEvent( FlexEvent.CREATION_COMPLETE ) );
		}
		else
		{
			this.dispatchEvent( new Event( Event.RESIZE ) );
		}
		this.dispatchEvent( new FlexEvent( FlexEvent.COMPONENT_COMPLETE ) );
		this.visible = true;
		//previousContentSize = new Rectangle( 0, 0, contentWidth, contentHeight );
		//this.removeEventListener( FlexEvent.COMPONENT_COMPLETE, creationCompleteHandler );
		
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
	
	private function checkIsEnd(component:UIComponent):Void
	{
		if( ! isEnd ) return;
		for(i in 0...component.numChildren)
		{
			if( Std.is( component.getChildAt(i), UIComponent ) )
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
		if( Std.is( event.target, UIComponent ) )
		{
			if( event.target == this ) return;
		}
		//if( Std.is( event.target, UIComponent ) )
		if( this.getChildIndex( event.target ) == -1 ) return;
		if( hasField( event.target, "noAddedEvent" ) ) return;
		if( hasField( event.target, "noLayout" ) ) return;
		if( Std.is( event.target, UIComponent ) )
		{
			if( ! cast( event.target, UIComponent ).includeInLayout ) return;
			cast( event.target, UIComponent ).addEventListener( FlexEvent.COMPONENT_COMPLETE, creationCompleteHandler );
		}
		createChildren();
	}
	
	private function removedHandler(event:Event):Void
	{
		if( Std.is( event.target, UIComponent ) )
		{
			if( event.target == this ) return;
		}
		//if( Std.is( event.target, UIComponent ) )
		if( this.getChildIndex( event.target ) == -1 ) return;
		if( hasField( event.target, "noAddedEvent" ) ) return;
		if( hasField( event.target, "noLayout" ) ) return;
		if( Std.is( event.target, UIComponent ) )
		{
			if( ! cast( event.target, UIComponent ).includeInLayout ) return;
			//cast( event.target, UIComponent ).removeEventListener( FlexEvent.COMPONENT_COMPLETE, creationCompleteHandler );
		}
		createChildren();
	}
	
	/*private function renderHandler(event:Event):Void
	{
		var contentSize:Rectangle = new Rectangle( 0, 0, this.contentWidth, this.contentHeight );
		if( contentSize.equals( previousContentSize ) ) return;
		//if( Std.is( event.target, UIComponent ) )
		if( Std.is( event.target, UIComponent ) )
		{
			cast( event.target, UIComponent ).addEventListener( FlexEvent.COMPONENT_COMPLETE, creationCompleteHandler );
		}
		createChildren();
	}*/
	
	private function creationCompleteHandler(event:FlexEvent):Void
	{
		isEnd = true;
		checkIsEnd( cast( event.currentTarget, UIComponent ) );
		if( isEnd )
		{
			//cast( event.currentTarget, UIComponent ).removeEventListener( FlexEvent.COMPONENT_COMPLETE, creationCompleteHandler );
			/*invalidateProperties();
			invalidateSize();
			invalidateDisplayList();*/
			//createChildren();
			if( ! isCreating ) isCreating = true;
			enterFrameCreationHandler();
		}
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
			for(i in 0...this.numChildren)
			{
				if( Std.is( this.getChildAt(i), UIComponent ) )
				{
					cast( this.getChildAt(i), UIComponent ).validate();
				}
			}
			if( isCreating ) enterFrameCreationHandler();
		}
	}
	
	private function hasField(target:Dynamic, field:String):Bool
	{
		if( Reflect.hasField( target, field ) ) return Reflect.getProperty(target, field);
		return false;
	}
	
	@:dox(hide)
	override public function getChildIndex(child:DisplayObject):Int
	{
		if( child.parent != this ) return -1;
		return super.getChildIndex(child);
	}
	
	@:dox(hide)
	override public function dispose():Void
	{
		this.removeEventListener( Event.ADDED, addedHandler );
		this.removeEventListener( Event.REMOVED, removedHandler );
		//this.removeEventListener( Event.RENDER, renderHandler );
		this.removeEventListener( FlexEvent.COMPONENT_COMPLETE, creationCompleteHandler );
		this.removeEventListener( FlexEvent.VALUE_COMMIT, valueCommitHandler );
		for(i in 0...this.numChildren)
		{
			if( Std.is( this.getChildAt(i), UIComponent ) )
			{
				cast( this.getChildAt(i), UIComponent ).dispose();
			}
		}
	}
}