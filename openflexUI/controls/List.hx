/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.controls;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openflexUI.controls.Button;
import openflexUI.controls.Scroller;
import openflexUI.controls.UIComponent;
import openflexUI.data.ArrayCollection;
import openflexUI.events.ArrayCollectionEvent;
import openflexUI.events.FlexEvent;
import openflexUI.layouts.VerticalLayout;
import openflexUI.themes.Theme;

/**
 * A Label component displays one line of plain text. Label components do not have borders.
 */
class List extends UIComponent
{	
	private var scroller:Scroller = new Scroller();
	private var background:Sprite = new Sprite();
	private var backgroundColor:Int = 0xEEEEEE;
	
	private var _width:Float = Math.NaN;
	
	override private function set_width(value:Float)
	{
		_width = value;
		scroller.width = _width;
		return value;
	}
	
	private var _height:Float = Math.NaN;
	
	override private function set_height(value:Float)
	{
		_height = value;
		scroller.height = _height;
		createChildren();
		return value;
	}
	
	private var _dataProvider:ArrayCollection;
	/**
		 * Gets or sets the plain dataProvider to be displayed by the Label component.
		 */
	public var dataProvider(get, set):ArrayCollection;
	
	private function get_dataProvider()
	{
		return _dataProvider;
	}
	
	private function set_dataProvider(value:ArrayCollection)
	{
		_dataProvider = value;
		dataProvider.addEventListener( ArrayCollectionEvent.ADDED, onArrayCollectionAddedHandler );
		dataProvider.addEventListener( ArrayCollectionEvent.REMOVED, onArrayCollectionRemovedHandler );
		dataProvider.addEventListener( ArrayCollectionEvent.REMOVE_ALL, onArrayCollectionRemoveAllHandler );
		dataProvider.addEventListener( ArrayCollectionEvent.REPLACE, onArrayCollectionReplaceHandler );
		createChildren();
		return value;
	}
	
	/**
		 * The 0-based index of the selected item, or -1 if no item is selected.
		 */
	public var selectedIndex(get, set):Int;
	
	private function get_selectedIndex()
	{
		var selectedIndex:Int = -1;
		for(i in 0...dataProvider.length)
		{
			var item:Button = cast( scroller.getChildAt( i + 1 ), Button );
			if( item.selected )
			{
				selectedIndex = i;
				break;
			}
		}
		return selectedIndex;
	}
	
	private function set_selectedIndex(value:Int)
	{
		cast( scroller.getChildAt( value + 1 ), Button ).selected = true;
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
		
		/*background.graphics.beginFill(backgroundColor);
		background.graphics.drawRect(0, 0, 300, 300);
		background.graphics.endFill();
		Reflect.setProperty(background, "noAddedEvent", true);*/
		this.addChild( background );
		
		var verticalLayout:VerticalLayout = new VerticalLayout();
		/*verticalLayout.horizontalAlign = "contentJustify";
		this._layout = verticalLayout;
		verticalLayout = new VerticalLayout();*/
		scroller._layout = verticalLayout;
		
		this.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
	}
	
	private function addedToStageHandler(event:Event):Void
	{
		this.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
	}
	
	override private function style():Void
	{
		super.style();
		if( Theme.backgroundColor != null ) backgroundColor = Theme.backgroundColor;
	}
	
	override private function measure():Void
	{
		super.measure();
		createBackground();
	}
	
	private function createBackground():Void
	{
		background.graphics.clear();
		background.graphics.beginFill(backgroundColor);
		if( this.numChildren == 1 )
		{
			var width:Float = ! Math.isNaN( this._width ) ? this._width : 200;
			var height:Float = ! Math.isNaN( this._height ) ? this._height : 200;
			background.graphics.drawRect(0, 0, width, height);
			background.graphics.endFill();
			return;
		}
		if( scroller.contentWidth > scroller.viewPort.width && scroller.contentHeight > scroller.viewPort.height )
		{
			background.graphics.drawRect(0, 0, scroller.width, scroller.height - scroller.scrollerSize);
			background.graphics.drawRect(0, scroller.height - scroller.scrollerSize, scroller.width - scroller.scrollerSize, scroller.scrollerSize);
		}
		else
		{
			background.graphics.drawRect(0, 0, scroller.width, scroller.height);
		}
		background.graphics.endFill();
	}
	
	private function onArrayCollectionAddedHandler(event:ArrayCollectionEvent):Void
	{
		if( this.getChildIndex( scroller ) == -1 ) this.addChild(scroller);
		if( Std.is( this.layout, VerticalLayout ) )
		{
			if( this.layout.horizontalAlign != "contentJustify" && this.layout.horizontalAlign != "justify" ) this.layout.horizontalAlign = "contentJustify";
		}
		else
		{
			var verticalLayout:VerticalLayout = new VerticalLayout();
			verticalLayout.horizontalAlign = "contentJustify";
			this._layout = verticalLayout;
		}
		var item:Button = new Button( 0, true );
		if( itemRenderer != null ) item.itemRenderer = this.itemRenderer;
		if( event.item.label != null ) item.label = event.item.label;
		if( event.item.icon != null ) item.icon = event.item.icon;
		if( event.item.textFormat != null ) item.textFormat = event.item.textFormat;
		if( event.item.iconPlacement != null ) item.iconPlacement = event.item.iconPlacement;
		/*item.minWidth = this._width;
		item.maxWidth = this._width;*/
		item.toggle = true;
		item.addEventListener( MouseEvent.MOUSE_DOWN, onItemClick );
		item.validate();
		
		if( event.index == dataProvider.length - 1 )
		{
			scroller.addChild( item );
		}
		else
		{
			scroller.addChildAt( item, event.index + 1 );
		}
		
		if( ! Math.isNaN( this.layout.requestedRowCount ) )
		{
			this.height = item.height * this.layout.requestedRowCount;
			
			if( this.layout.horizontalAlign == "contentJustify" )
			{
				if( this.layout.requestedRowCount != dataProvider.length + 1 )
				{
					this.height = this._height + scroller.scrollerSize;
				}
				else
				{
					this.height = Math.NaN;
				}
			}
		}
		
		if( this.layout.horizontalAlign == "justify" && ! Math.isNaN( this._width ) )
		{
			justify();
		}
		else
		{
			contentJustify();
		}
		createChildren();
	}
	
	private function contentJustify():Void
	{
		var maxSize:Float = 0;
		for(i in 0...dataProvider.length + 1)
		{
			var item:Button = cast( scroller.getChildAt( i + 1 ), Button );
			if( item.width > maxSize ) maxSize = item.width;
		}
		for(i in 0...dataProvider.length + 1)
		{
			var item:Button = cast( scroller.getChildAt( i + 1 ), Button );
			if( item.width != maxSize )
			{
				item.minWidth = item.maxWidth = maxSize;
				item.validate();
			}
		}
	}
	
	private function justify():Void
	{
		var contentHeight:Float = 0;
		for(i in 0...dataProvider.length + 1) contentHeight += scroller.getChildAt( i + 1 ).height;
		
		var width:Float = contentHeight <= this._height ? this._width : this._width - scroller.scrollerSize;
		for(i in 0...dataProvider.length + 1)
		{
			var item:Button = cast( scroller.getChildAt( i + 1 ), Button );
			if( item.width != width )
			{
				item.minWidth = item.maxWidth = width;
				item.validate();
			}
		}
	}
	
	private function onArrayCollectionRemovedHandler(event:ArrayCollectionEvent):Void
	{
		scroller.removeChildAt( event.index + 1 );
		createChildren();
	}
	
	private function onArrayCollectionRemoveAllHandler(event:ArrayCollectionEvent):Void
	{
		scroller.removeChildren( 1, dataProvider.length );
		createChildren();
	}
	
	private function onArrayCollectionReplaceHandler(event:ArrayCollectionEvent):Void
	{
		var item:Button = cast( scroller.getChildAt( event.index + 1 ), Button );
		item.label = event.item.label;
		item.icon = event.item.icon;
		createChildren();
	}
	
	private function onItemClick(event:MouseEvent):Void
	{
		var selectedItem:Button = cast( event.currentTarget, Button );
		for(i in 0...dataProvider.length)
		{
			var item:Button = cast( scroller.getChildAt( i + 1 ), Button );
			if( selectedItem == item )
			{
				if( selectedItem.selected ) return;
				continue;
			}
			if( item.selected ) item.selected = false;
		}
		if( ! selectedItem.selected ) selectedItem.selected = true;
		this.dispatchEvent( new Event( Event.CHANGE ) );
	}
	
	/**
		 * A convenience method that handles scrolling a data item into view.
		 *  
		 * @index  The index of the data item. 
	**/
	public function ensureIndexIsVisible(index:Int):Void
    {
        if( Math.isNaN( this._height ) ) return;
		if( scroller.contentHeight <= scroller.height ) return;
		
		var item:Button = cast( scroller.getChildAt( index + 1 ), Button );
			
		if( item.height > scroller.height ) //item height > scroller height
		{
			scroller.verticalScrollPosition = item.y; //item begin
		}
		else if(item.y < scroller.verticalScrollPosition) //item begin < scroller begin
		{
			scroller.verticalScrollPosition = item.y; //item begin
		}
		else if(item.y + item.height > scroller.verticalScrollPosition + scroller.viewPort.height) //item end > scroller end
		{
			scroller.verticalScrollPosition = item.y + item.height - scroller.viewPort.height; //item end - scroller height
		}
    }
	
	@:dox(hide)
	override public function dispose():Void
	{
		super.dispose();
		
		if( dataProvider != null )
		{
			for(i in 0...dataProvider.length)
			{
				var item:Button = cast( scroller.getChildAt( i + 1 ), Button );
				item.removeEventListener( MouseEvent.MOUSE_DOWN, onItemClick );
			}
			dataProvider.removeEventListener( ArrayCollectionEvent.ADDED, onArrayCollectionAddedHandler );
			dataProvider.removeEventListener( ArrayCollectionEvent.REMOVED, onArrayCollectionRemovedHandler );
			dataProvider.removeEventListener( ArrayCollectionEvent.REMOVE_ALL, onArrayCollectionRemoveAllHandler );
			dataProvider.removeEventListener( ArrayCollectionEvent.REPLACE, onArrayCollectionReplaceHandler );
		}
		scroller.dispose();
	}
}