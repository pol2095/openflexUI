/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.controls;

import openfl.display.BlendMode;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openflexUI.controls.UIComponent;

/**
 * The Scroller control displays a single scrollable component, called a viewport, and horizontal and vertical scroll bars.
 */
class Scroller extends UIComponent
{
	private var viewPort:Sprite = new Sprite();
	/**
		 * Indicates under what conditions the horizontal scroll bar is displayed. The acceptable values are "auto" or "off".
		 *
		 * The default value is "auto"
		 */
	public var horizontalScrollPolicy:String = "auto";
	/**
		 * Indicates under what conditions the vertical scroll bar is displayed. The acceptable values are "auto" or "off".
		 *
		 * The default value is "auto"
		 */
	public var verticalScrollPolicy:String = "auto";
	private var horizontalScrollBar:Sprite;
	private var horizontalScrollBarBG:Sprite = new Sprite();
	private var horizontalScrollBarLeft:Sprite = new Sprite();
	private var horizontalScrollBarCursor:Sprite = new Sprite();
	private var horizontalScrollBarRight:Sprite = new Sprite();
	private var verticalScrollBar:Sprite;
	private var verticalScrollBarBG:Sprite = new Sprite();
	private var verticalScrollBarUp:Sprite = new Sprite();
	private var verticalScrollBarCursor:Sprite = new Sprite();
	private var verticalScrollBarDown:Sprite = new Sprite();
	private var scrollerSize:Int = 10;
	private var startMove:Point;
	private var swipeLatencyToStart:Int = 5;
	private var swipeSpeed:Float = 2;
	private var previousMove:Point;
	private var previousGlobalMove:Point;
	private var previousViewPort:Rectangle;
	/**
		 * Swipe to scroll the viewport.
		 *
		 * The default value is true
		 */
	public var swipe:Bool = true;
	private var previousIsPositiveSwipeX:Bool;
	private var previousIsPositiveSwipeY:Bool;
	
	private var _width:Float = Math.NaN;
	
	override private function get_width()
	{
		if( Math.isNaN( _width ) || _width > super.width ) return super.width;
		return _width;
	}
	
	override private function set_width(value:Float)
	{
		createChildren();
		return _width = value;
	}
	
	private var _height:Float = Math.NaN;
	
	override private function get_height()
	{
		if( Math.isNaN( _height ) || _height > super.height ) return super.height;
		return _height;
	}
	
	override private function set_height(value:Float)
	{
		createChildren();
		return _height = value;
	}
	
	private var horizontalScrollBarVisible(get, never):Bool;
	
	private function get_horizontalScrollBarVisible()
	{
		if( horizontalScrollBar == null ) return false;
		return horizontalScrollBar.visible;
	}
	
	private var verticalScrollBarVisible(get, never):Bool;
	
	private function get_verticalScrollBarVisible()
	{
		if( verticalScrollBar == null ) return false;
		return verticalScrollBar.visible;
	}
	
	/**
		 * Get a number that represents the maximum horizontal scroll position.
		 */
	public var maxHorizontalScrollBarPosition(get, never):Float;
	
	private function get_maxHorizontalScrollBarPosition()
	{
		var width:Float = verticalScrollBarVisible ? this.width - scrollerSize : this.width;
		var contentWidth:Float = this.contentWidth;
		/*var widthSB:Float = horizontalScrollBarCursor.width;
		var contentWidthSB:Float = horizontalScrollBarRight.x - scrollerSize - 2;
		return contentWidthSB - widthSB;*/
		return contentWidth - width;
	}
	
	/**
		 * Get a number that represents the maximum vertical scroll position.
		 */
	public var maxVerticalScrollBarPosition(get, never):Float;
	
	private function get_maxVerticalScrollBarPosition()
	{
		var height:Float = horizontalScrollBarVisible ? this.height - scrollerSize : this.height;
		var contentHeight:Float = this.contentHeight;
		/*var heightSB:Float = verticalScrollBarCursor.height;
		var contentHeightSB:Float = verticalScrollBarDown.y - scrollerSize - 2;
		return contentHeightSB - heightSB;*/
		return contentHeight - height;
	}
	
	/**
		 * The x coordinate of the origin of the viewport in the component's coordinate system, where the default value is (0,0) corresponding to the upper-left corner of the component.
		 */
	public var horizontalScrollBarPosition(get, set):Float;
	
	private function get_horizontalScrollBarPosition()
	{
		var x:Float = 0;
		if( ! horizontalScrollBarVisible ) return x;
		var contentWidth:Float = this.contentWidth;
		var contentWidthSB:Float = horizontalScrollBarRight.x - scrollerSize - 2;
		x = horizontalScrollBarCursor.x - scrollerSize - 1;
		//return horizontalScrollBarCursor.x - scrollerSize - 1;
		return x * contentWidth / contentWidthSB;
	}
	
	private function set_horizontalScrollBarPosition(x:Float)
	{
		if( ! horizontalScrollBarVisible ) return x;
		var contentWidth:Float = this.contentWidth;
		var contentWidthSB:Float = horizontalScrollBarRight.x - scrollerSize - 2;
		x *= contentWidthSB / contentWidth;
		if( x < 0 ) x = 0;
		if( x > maxHorizontalScrollBarPosition ) x = maxHorizontalScrollBarPosition;
		horizontalScrollBarCursor.x = scrollerSize + 1 + x;
		horizontalScrollBarCursorClickHandler();
		return null;
	}
	
	/**
		 * The y coordinate of the origin of the viewport in the component's coordinate system, where the default value is (0,0) corresponding to the upper-left corner of the component.
		 */
	public var verticalScrollBarPosition(get, set):Float;
	
	private function get_verticalScrollBarPosition()
	{
		var y:Float = 0;
		if( ! verticalScrollBarVisible ) return y;
		var contentHeight:Float = this.contentHeight;
		var contentHeightSB:Float = verticalScrollBarDown.y - scrollerSize - 2;
		y = verticalScrollBarCursor.y - scrollerSize - 1;
		//return verticalScrollBarCursor.y - ( scrollerSize + 1 );
		return y * contentHeight / contentHeightSB;
	}
	
	private function set_verticalScrollBarPosition(y:Float)
	{
		if( ! verticalScrollBarVisible ) return y;
		var contentHeight:Float = this.contentHeight;
		var contentHeightSB:Float = verticalScrollBarDown.y - scrollerSize - 2;
		y *= contentHeightSB / contentHeight;
		if( y < 0 ) y = 0;
		if( y > maxVerticalScrollBarPosition ) y = maxVerticalScrollBarPosition;
		verticalScrollBarCursor.y = scrollerSize + 1 + y;
		verticalScrollBarCursorClickHandler();
		return null;
	}
	
	/**
		 * The width of the viewport's contents.
		 */
	public var contentWidth(get, never):Float;
	
	private function get_contentWidth()
	{
		if( verticalScrollBarVisible ) verticalScrollBar.width = 0;
		var contentWidth:Float = super.width;
		if( verticalScrollBarVisible ) verticalScrollBar.width = scrollerSize;
		return contentWidth;
	}
	
	/**
		 * The height of the viewport's content.
		 */
	public var contentHeight(get, never):Float;
	
	private function get_contentHeight()
	{
		if( horizontalScrollBarVisible ) horizontalScrollBar.height = 0;
		var contentHeight:Float = super.height;
		if( horizontalScrollBarVisible ) horizontalScrollBar.height = scrollerSize;
		return contentHeight;
	}
	
	@:dox(hide)
	public function new()
	{
		super();
		this.visible = false;
		viewPort.graphics.beginFill(0x000000);
        viewPort.graphics.drawRect(0, 0, 0, 0);
        viewPort.graphics.endFill();
		previousViewPort = viewPort.getRect(this);
		this.mask = viewPort;
		this.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
	}
	
	private function addedToStageHandler(event:Event):Void
	{
		this.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		stage.addEventListener( MouseEvent.MOUSE_DOWN, swipeMouseDownHandler );
	}
	
	override private function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		createViewPort();
	}
	
	private function createViewPort():Void
	{
		var previousHorizontalScrollPosition:Float = 0;
		var previousVerticalScrollPosition:Float = 0;
		if( horizontalScrollBarVisible ) previousHorizontalScrollPosition = horizontalScrollBarPosition;
		if( verticalScrollBarVisible ) previousVerticalScrollPosition = verticalScrollBarPosition;
		//trace("CREATE VIEWPORT");
		//trace( this.width, this.height );
		var rect:Rectangle = new Rectangle( 0, 0, this.width, this.height );
		if( ! rect.equals( previousViewPort ) )
		{
			viewPort.graphics.clear();
			viewPort.graphics.beginFill(0x000000);
			viewPort.graphics.drawRect(0, 0, this.width, this.height);
			viewPort.graphics.endFill();
			previousViewPort = viewPort.getRect(this);
		}
		/*viewPort.width = this.width;
		viewPort.height = this.height;*/
		
		var horizontalScrollBarHeight:Int = scrollerSize;
		var verticalScrollBarWidth:Int = scrollerSize;
		
		if( Math.isNaN( width ) || width == super.width || horizontalScrollPolicy == "off" )
		{
			if( horizontalScrollBar != null ) horizontalScrollBar.visible = false;
			horizontalScrollBarHeight = 0;
		}
		
		if( Math.isNaN( height ) || height == super.height || verticalScrollPolicy == "off" )
		{
			if( verticalScrollBar != null ) verticalScrollBar.visible = false;
			verticalScrollBarWidth = 0;
		}
		
		if( horizontalScrollBarHeight != 0 )
		{
			if( horizontalScrollBar == null ) createHorizontalScrollBar();
			horizontalScrollBar.visible = true;
			horizontalScrollBar.y = -this.y + viewPort.height - horizontalScrollBarHeight;
			horizontalScrollBarBG.width = viewPort.width - verticalScrollBarWidth;
			horizontalScrollBarCursor.x = scrollerSize + 1;
			horizontalScrollBarCursor.width = viewPort.width - verticalScrollBarWidth - scrollerSize * 2 - 2;
			horizontalScrollBarCursor.width *= width / super.width;
			horizontalScrollBarRight.x = viewPort.width - verticalScrollBarWidth - scrollerSize;
		}
		
		if( verticalScrollBarWidth != 0 )
		{
			if( verticalScrollBar == null ) createVerticalScrollBar();
			verticalScrollBar.visible = true;
			verticalScrollBar.x = -this.x + viewPort.width - verticalScrollBarWidth;
			verticalScrollBarBG.height = viewPort.height - horizontalScrollBarHeight;
			verticalScrollBarCursor.y = scrollerSize + 1;
			verticalScrollBarCursor.height = viewPort.height - horizontalScrollBarHeight - scrollerSize * 2 - 2;
			verticalScrollBarCursor.height *= height / super.height;
			verticalScrollBarDown.y = viewPort.height - horizontalScrollBarHeight - scrollerSize;
		}
		
		if( horizontalScrollBarHeight != 0 && verticalScrollBarWidth != 0 )
		{
			viewPort.graphics.clear();
			viewPort.graphics.beginFill(0x000000);
			viewPort.graphics.drawRect(0, 0, this.width, this.height - scrollerSize);
			viewPort.graphics.drawRect(0, this.height - scrollerSize, this.width - scrollerSize, scrollerSize);
			viewPort.graphics.endFill();
		}
		
		if( horizontalScrollBarVisible )
		{
			this.setChildIndex( horizontalScrollBar, this.numChildren - 1 );
			
			if( previousHorizontalScrollPosition != 0 )
			{
				var horizontalScrollBarPosition:Float = previousHorizontalScrollPosition > maxHorizontalScrollBarPosition ? maxHorizontalScrollBarPosition : previousHorizontalScrollPosition;
				this.horizontalScrollBarPosition = horizontalScrollBarPosition;
			}
		}
		if( verticalScrollBarVisible )
		{
			this.setChildIndex( verticalScrollBar, this.numChildren - 1 );
			
			if( previousVerticalScrollPosition != 0 )
			{
				var verticalScrollBarPosition:Float = previousVerticalScrollPosition > maxVerticalScrollBarPosition ? maxVerticalScrollBarPosition : previousVerticalScrollPosition;
				this.verticalScrollBarPosition = verticalScrollBarPosition;
			}
		}
	}
	
	private function createHorizontalScrollBar():Void
	{
		horizontalScrollBar = new Sprite();
		this.addChild( horizontalScrollBar );
		
		horizontalScrollBarBG.graphics.beginFill(0xCCCCCC);
        horizontalScrollBarBG.graphics.drawRect(0, 0, 40, scrollerSize);
        horizontalScrollBarBG.graphics.endFill();
		//horizontalScrollBarBG.alpha = 0.4;
		horizontalScrollBar.addChild( horizontalScrollBarBG );
		
		horizontalScrollBarLeft.graphics.beginFill(0xFFA500);
        horizontalScrollBarLeft.graphics.drawRect(0, 0, scrollerSize, scrollerSize);
        horizontalScrollBarLeft.graphics.endFill();
		horizontalScrollBarLeft.graphics.beginFill(0xFFFFFF);
		horizontalScrollBarLeft.graphics.moveTo(2,5);
		horizontalScrollBarLeft.graphics.lineTo(8,2);
		horizontalScrollBarLeft.graphics.lineTo(8,8);
		horizontalScrollBarLeft.graphics.lineTo(2,5);
		horizontalScrollBarLeft.graphics.endFill();
		horizontalScrollBarLeft.addEventListener( MouseEvent.MOUSE_DOWN, horizontalScrollBarLeftMouseDownHandler );
		horizontalScrollBar.addChild( horizontalScrollBarLeft );
		
		horizontalScrollBarCursor.graphics.beginFill(0xFFA500);
        horizontalScrollBarCursor.graphics.drawRect(0, 0, 40, scrollerSize);
        horizontalScrollBarCursor.graphics.endFill();
		horizontalScrollBarCursor.addEventListener( MouseEvent.MOUSE_DOWN, horizontalScrollBarCursorMouseDownHandler );
		horizontalScrollBar.addChild( horizontalScrollBarCursor );
		
		horizontalScrollBarRight.graphics.beginFill(0xFFA500);
        horizontalScrollBarRight.graphics.drawRect(0, 0, scrollerSize, scrollerSize);
        horizontalScrollBarRight.graphics.endFill();
		horizontalScrollBarRight.graphics.beginFill(0xFFFFFF);
		horizontalScrollBarRight.graphics.moveTo(2,2);
		horizontalScrollBarRight.graphics.lineTo(8,5);
		horizontalScrollBarRight.graphics.lineTo(2,8);
		horizontalScrollBarRight.graphics.lineTo(2,2);
		horizontalScrollBarRight.graphics.endFill();
		horizontalScrollBarRight.addEventListener( MouseEvent.MOUSE_DOWN, horizontalScrollBarRightMouseDownHandler );
		horizontalScrollBar.addChild( horizontalScrollBarRight );
	}
	
	private function createVerticalScrollBar():Void
	{
		verticalScrollBar = new Sprite();
		this.addChild( verticalScrollBar );
		
		verticalScrollBarBG.graphics.beginFill(0xCCCCCC);
        verticalScrollBarBG.graphics.drawRect(0, 0, scrollerSize, 40);
        verticalScrollBarBG.graphics.endFill();
		//verticalScrollBarBG.alpha = 0.4;
		verticalScrollBar.addChild( verticalScrollBarBG );
		
		verticalScrollBarUp.graphics.beginFill(0xFFA500);
        verticalScrollBarUp.graphics.drawRect(0, 0, scrollerSize, scrollerSize);
        verticalScrollBarUp.graphics.endFill();
		verticalScrollBarUp.graphics.beginFill(0xFFFFFF);
		verticalScrollBarUp.graphics.moveTo(5,2);
		verticalScrollBarUp.graphics.lineTo(8,8);
		verticalScrollBarUp.graphics.lineTo(2,8);
		verticalScrollBarUp.graphics.lineTo(5,2);
		verticalScrollBarUp.graphics.endFill();
		verticalScrollBarUp.addEventListener( MouseEvent.MOUSE_DOWN, verticalScrollBarUpMouseDownHandler );
		verticalScrollBar.addChild( verticalScrollBarUp );
		
		verticalScrollBarCursor.graphics.beginFill(0xFFA500);
        verticalScrollBarCursor.graphics.drawRect(0, 0, scrollerSize, 40);
        verticalScrollBarCursor.graphics.endFill();
		verticalScrollBarCursor.addEventListener( MouseEvent.MOUSE_DOWN, verticalScrollBarCursorMouseDownHandler );
		verticalScrollBar.addChild( verticalScrollBarCursor );
		
		verticalScrollBarDown.graphics.beginFill(0xFFA500);
        verticalScrollBarDown.graphics.drawRect(0, 0, scrollerSize, scrollerSize);
        verticalScrollBarDown.graphics.endFill();
		verticalScrollBarDown.graphics.beginFill(0xFFFFFF);
		verticalScrollBarDown.graphics.moveTo(2,2);
		verticalScrollBarDown.graphics.lineTo(8,2);
		verticalScrollBarDown.graphics.lineTo(5,8);
		verticalScrollBarDown.graphics.lineTo(2,2);
		verticalScrollBarDown.graphics.endFill();
		verticalScrollBarDown.addEventListener( MouseEvent.MOUSE_DOWN, verticalScrollBarDownMouseDownHandler );
		verticalScrollBar.addChild( verticalScrollBarDown );
	}
		
	private function horizontalScrollBarLeftMouseDownHandler(event:MouseEvent):Void
	{
		stage.addEventListener(MouseEvent.MOUSE_UP, horizontalScrollBarLeftMouseUpHandler);
		this.addEventListener(Event.ENTER_FRAME, horizontalScrollBarLeftClickHandler);
	}
	
	private function horizontalScrollBarLeftMouseUpHandler(event:MouseEvent):Void
	{
		this.removeEventListener(Event.ENTER_FRAME, horizontalScrollBarLeftClickHandler);
		stage.removeEventListener(MouseEvent.MOUSE_UP, horizontalScrollBarLeftMouseUpHandler);
	}
	
	private function horizontalScrollBarLeftClickHandler(event:MouseEvent)
	{
		var width:Float = verticalScrollBarVisible ? this.width - scrollerSize : this.width;
		var contentWidth:Float = this.contentWidth;
		var widthSB:Float = horizontalScrollBarCursor.width;
		var contentWidthSB:Float = horizontalScrollBarRight.x - scrollerSize - 2;
		this.x += 5;
		if( this.x > 0 ) this.x = 0;
		horizontalScrollBarCursor.x = ( scrollerSize + 1 ) - this.x * ( contentWidthSB - widthSB ) / ( contentWidth - width );
		horizontalScrollBar.x = -this.x;
		if( verticalScrollBarVisible ) verticalScrollBar.x = -this.x + width;
	}
	
	private function horizontalScrollBarRightMouseDownHandler(event:MouseEvent):Void
	{
		stage.addEventListener(MouseEvent.MOUSE_UP, horizontalScrollBarRightMouseUpHandler);
		this.addEventListener(Event.ENTER_FRAME, horizontalScrollBarRightClickHandler);
	}
	
	private function horizontalScrollBarRightMouseUpHandler(event:MouseEvent):Void
	{
		this.removeEventListener(Event.ENTER_FRAME, horizontalScrollBarRightClickHandler);
		stage.removeEventListener(MouseEvent.MOUSE_UP, horizontalScrollBarRightMouseUpHandler);
	}
	
	private function horizontalScrollBarRightClickHandler(event:MouseEvent)
	{
		var width:Float = verticalScrollBarVisible ? this.width - scrollerSize : this.width;
		var contentWidth:Float = this.contentWidth;
		var widthSB:Float = horizontalScrollBarCursor.width;
		var contentWidthSB:Float = horizontalScrollBarRight.x - scrollerSize - 2;
		this.x -= 5;
		if( this.x < width - contentWidth ) this.x = width - contentWidth;
		horizontalScrollBarCursor.x = ( scrollerSize + 1 ) - this.x * ( contentWidthSB - widthSB ) / ( contentWidth - width );
		horizontalScrollBar.x = -this.x;
		if( verticalScrollBarVisible ) verticalScrollBar.x = -this.x + width;
	}
	
	private function verticalScrollBarUpMouseDownHandler(event:MouseEvent):Void
	{
		stage.addEventListener(MouseEvent.MOUSE_UP, verticalScrollBarUpMouseUpHandler);
		this.addEventListener(Event.ENTER_FRAME, verticalScrollBarUpClickHandler);
	}
	
	private function verticalScrollBarUpMouseUpHandler(event:MouseEvent):Void
	{
		this.removeEventListener(Event.ENTER_FRAME, verticalScrollBarUpClickHandler);
		stage.removeEventListener(MouseEvent.MOUSE_UP, verticalScrollBarUpMouseUpHandler);
	}
	
	private function verticalScrollBarUpClickHandler(event:MouseEvent)
	{
		var height:Float = horizontalScrollBarVisible ? this.height - scrollerSize : this.height;
		var contentHeight:Float = this.contentHeight;
		var heightSB:Float = verticalScrollBarCursor.height;
		var contentHeightSB:Float = verticalScrollBarDown.y - scrollerSize - 2;
		this.y += 5;
		if( this.y > 0 ) this.y = 0;
		verticalScrollBarCursor.y = ( scrollerSize + 1 ) - this.y * ( contentHeightSB - heightSB ) / ( contentHeight - height );
		verticalScrollBar.y = -this.y;
		if( horizontalScrollBarVisible ) horizontalScrollBar.y = -this.y + height;
	}
	
	private function verticalScrollBarDownMouseDownHandler(event:MouseEvent):Void
	{
		stage.addEventListener(MouseEvent.MOUSE_UP, verticalScrollBarDownMouseUpHandler);
		this.addEventListener(Event.ENTER_FRAME, verticalScrollBarDownClickHandler);
	}
	
	private function verticalScrollBarDownMouseUpHandler(event:MouseEvent):Void
	{
		this.removeEventListener(Event.ENTER_FRAME, verticalScrollBarDownClickHandler);
		stage.removeEventListener(MouseEvent.MOUSE_UP, verticalScrollBarDownMouseUpHandler);
	}
	
	private function verticalScrollBarDownClickHandler(event:MouseEvent)
	{
		var height:Float = horizontalScrollBarVisible ? this.height - scrollerSize : this.height;
		var contentHeight:Float = this.contentHeight;
		var heightSB:Float = verticalScrollBarCursor.height;
		var contentHeightSB:Float = verticalScrollBarDown.y - scrollerSize - 2;
		this.y -= 5;
		if( this.y < height - contentHeight ) this.y = height - contentHeight;
		verticalScrollBarCursor.y = ( scrollerSize + 1 ) - this.y * ( contentHeightSB - heightSB ) / ( contentHeight - height );
		verticalScrollBar.y = -this.y;
		if( horizontalScrollBarVisible ) horizontalScrollBar.y = -this.y + height;
	}
	
	private function horizontalScrollBarCursorMouseDownHandler(event:MouseEvent):Void
	{
		stage.addEventListener(MouseEvent.MOUSE_UP, horizontalScrollBarCursorMouseUpHandler);
		var widthSB:Float = horizontalScrollBarCursor.width;
		var contentWidthSB:Float = horizontalScrollBarRight.x - scrollerSize - 2;
		var bounds:Rectangle = new Rectangle( scrollerSize + 1, 0, contentWidthSB - widthSB, 0 );
		horizontalScrollBarCursor.startDrag(false, bounds);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, horizontalScrollBarCursorMouseMoveHandler);
	}
	
	private function horizontalScrollBarCursorMouseMoveHandler(event:MouseEvent):Void
	{
		horizontalScrollBarCursorClickHandler();
	}
	
	private function horizontalScrollBarCursorMouseUpHandler(event:MouseEvent):Void
	{
		horizontalScrollBarCursor.stopDrag();
		stage.removeEventListener(MouseEvent.MOUSE_UP, horizontalScrollBarCursorMouseUpHandler);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, horizontalScrollBarCursorMouseMoveHandler);
	}
	
	private function horizontalScrollBarCursorClickHandler()
	{
		var x:Float = horizontalScrollBarCursor.x - scrollerSize - 1;
		var width:Float = verticalScrollBarVisible ? this.width - scrollerSize : this.width;
		var contentWidth:Float = this.contentWidth;
		var widthSB:Float = horizontalScrollBarCursor.width;
		var contentWidthSB:Float = horizontalScrollBarRight.x - scrollerSize - 2;
		this.x = -x * ( contentWidth - width ) / ( contentWidthSB - widthSB );
		horizontalScrollBar.x = -this.x;
		if( verticalScrollBarVisible ) verticalScrollBar.x = -this.x + width;
	}
	
	private function verticalScrollBarCursorMouseDownHandler(event:MouseEvent):Void
	{
		stage.addEventListener(MouseEvent.MOUSE_UP, verticalScrollBarCursorMouseUpHandler);
		var heightSB:Float = verticalScrollBarCursor.height;
		var contentHeightSB:Float = verticalScrollBarDown.y - scrollerSize - 2;
		var bounds:Rectangle = new Rectangle( 0, scrollerSize + 1, 0, contentHeightSB - heightSB );
		verticalScrollBarCursor.startDrag(false, bounds);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, verticalScrollBarCursorMouseMoveHandler);
	}
	
	private function verticalScrollBarCursorMouseMoveHandler(event:MouseEvent):Void
	{
		verticalScrollBarCursorClickHandler();
	}
	
	private function verticalScrollBarCursorMouseUpHandler(event:MouseEvent):Void
	{
		verticalScrollBarCursor.stopDrag();
		stage.removeEventListener(MouseEvent.MOUSE_UP, verticalScrollBarCursorMouseUpHandler);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, verticalScrollBarCursorMouseMoveHandler);
	}
	
	private function verticalScrollBarCursorClickHandler()
	{
		var y:Float = verticalScrollBarCursor.y - scrollerSize - 1;
		var height:Float = horizontalScrollBarVisible ? this.height - scrollerSize : this.height;
		var contentHeight:Float = this.contentHeight;
		var heightSB:Float = verticalScrollBarCursor.height;
		var contentHeightSB:Float = verticalScrollBarDown.y - scrollerSize - 2;
		this.y = -y * ( contentHeight - height ) / ( contentHeightSB - heightSB );
		verticalScrollBar.y = -this.y;
		if( horizontalScrollBarVisible ) horizontalScrollBar.y = -this.y + height;
	}
	
	private function swipeMouseDownHandler(event:MouseEvent):Void
	{
		if( ! swipe ) return;
		var width:Float = verticalScrollBarVisible ? this.width - scrollerSize : this.width;
		var height:Float = horizontalScrollBarVisible ? this.height - scrollerSize : this.height;
		var rect:Rectangle = new Rectangle( -this.x, -this.y, width, height );
		startMove = new Point( this.mouseX, this.mouseY );
		previousMove = startMove.clone();
		previousGlobalMove = new Point( stage.mouseX, stage.mouseY );
		if( ! rect.containsPoint( startMove ) ) return;
		stage.addEventListener(MouseEvent.MOUSE_UP, swipeMouseUpHandler);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, swipeMouseMoveHandler);
	}
	
	private function swipeMouseMoveHandler(event:MouseEvent):Void
	{
		var width:Float = verticalScrollBarVisible ? this.width - scrollerSize : this.width;
		var height:Float = horizontalScrollBarVisible ? this.height - scrollerSize : this.height;
		var contentWidth:Float = this.contentWidth;
		horizontalScrollBar.height = 0;
		var contentHeight:Float = super.height;
		var widthSB:Float = horizontalScrollBarCursor.width;
		var contentWidthSB:Float = horizontalScrollBarRight.x - scrollerSize - 2;
		horizontalScrollBar.height = scrollerSize;
		var heightSB:Float = verticalScrollBarCursor.height;
		var contentHeightSB:Float = verticalScrollBarDown.y - scrollerSize - 2;
		
		var rect:Rectangle = new Rectangle( -this.x, -this.y, width, height );
		var local:Point = new Point( this.mouseX, this.mouseY );
		var global:Point = new Point( stage.mouseX, stage.mouseY );
		if( ! rect.containsPoint( local ) ) return;
		var isPositiveSwipeX:Bool = global.x > previousGlobalMove.x ? true : false;
		if( isPositiveSwipeX != previousIsPositiveSwipeX ) startMove.x = local.x; // direction x change
		var isPositiveSwipeY:Bool = global.y > previousGlobalMove.y ? true : false;
		if( isPositiveSwipeY != previousIsPositiveSwipeY ) startMove.y = local.y; // direction y change
		if(local.x < startMove.x - swipeLatencyToStart) //next
		{
			mouseChildren = false;
			var delta:Float = (local.x - previousMove.x ) * swipeSpeed;
			if( Math.abs( delta ) > swipeSpeed * 10 ) delta = - swipeSpeed * 10;
			this.x += delta;
			if( this.x < width - contentWidth ) this.x = width - contentWidth;
			horizontalScrollBarCursor.x = ( scrollerSize + 1 ) - this.x * ( contentWidthSB - widthSB ) / ( contentWidth - width );
			horizontalScrollBar.x = -this.x;
			if( verticalScrollBarVisible ) verticalScrollBar.x = -this.x + width;
		}
		else if(local.x > startMove.x + swipeLatencyToStart) //previous
		{
			mouseChildren = false;
			var delta:Float = (local.x - previousMove.x ) * swipeSpeed;
			if( Math.abs( delta ) > swipeSpeed * 10 ) delta = swipeSpeed * 10;
			this.x += delta;
			if( this.x > 0 ) this.x = 0;
			horizontalScrollBarCursor.x = ( scrollerSize + 1 ) - this.x * ( contentWidthSB - widthSB ) / ( contentWidth - width );
			horizontalScrollBar.x = -this.x;
			if( verticalScrollBarVisible ) verticalScrollBar.x = -this.x + width;
		}
		
		if(local.y < startMove.y - swipeLatencyToStart) //next
		{
			mouseChildren = false;
			var delta:Float = (local.y - previousMove.y ) * swipeSpeed;
			if( Math.abs( delta ) > swipeSpeed * 10 ) delta = - swipeSpeed * 10;
			this.y += delta;
			if( this.y < height - contentHeight ) this.y = height - contentHeight;
			verticalScrollBarCursor.y = ( scrollerSize + 1 ) - this.y * ( contentHeightSB - heightSB ) / ( contentHeight - height );
			verticalScrollBar.y = -this.y;
			if( horizontalScrollBarVisible ) horizontalScrollBar.y = -this.y + height;
		}
		else if(local.y > startMove.y + swipeLatencyToStart) //previous
		{
			mouseChildren = false;
			var delta:Float = (local.y - previousMove.y ) * swipeSpeed;
			if( Math.abs( delta ) > swipeSpeed * 10 ) delta = swipeSpeed * 10;
			this.y += delta;
			if( this.y > 0 ) this.y = 0;
			verticalScrollBarCursor.y = ( scrollerSize + 1 ) - this.y * ( contentHeightSB - heightSB ) / ( contentHeight - height );
			verticalScrollBar.y = -this.y;
			if( horizontalScrollBarVisible ) horizontalScrollBar.y = -this.y + height;
		}
		
		previousMove = local.clone();
		previousGlobalMove = global.clone();
		previousIsPositiveSwipeX = isPositiveSwipeX;
		previousIsPositiveSwipeY = isPositiveSwipeY;
	}
	
	private function swipeMouseUpHandler(event:MouseEvent):Void
	{
		stage.removeEventListener(MouseEvent.MOUSE_UP, swipeMouseUpHandler);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, swipeMouseMoveHandler);
		mouseChildren = true;
	}
	
	@:dox(hide)
	override public function dispose():Void
	{
		super.dispose();
		horizontalScrollBarLeft.removeEventListener( MouseEvent.MOUSE_DOWN, horizontalScrollBarLeftMouseDownHandler );
		horizontalScrollBarRight.removeEventListener( MouseEvent.MOUSE_DOWN, horizontalScrollBarRightMouseDownHandler );
		verticalScrollBarUp.removeEventListener( MouseEvent.MOUSE_DOWN, verticalScrollBarUpMouseDownHandler );
		verticalScrollBarDown.removeEventListener( MouseEvent.MOUSE_DOWN, verticalScrollBarDownMouseDownHandler );
		horizontalScrollBarCursor.removeEventListener( MouseEvent.MOUSE_DOWN, horizontalScrollBarCursorMouseDownHandler );
		verticalScrollBarCursor.removeEventListener( MouseEvent.MOUSE_DOWN, verticalScrollBarCursorMouseDownHandler );
		stage.removeEventListener( MouseEvent.MOUSE_DOWN, swipeMouseDownHandler );
	}
}