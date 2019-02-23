/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.controls;

import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openflexUI.controls.UIComponent;
import openflexUI.themes.Theme;

/**
 * The Scroller control displays a single scrollable component, called a viewport, and horizontal and vertical scroll bars.
 */
class Scroller extends UIComponent
{
	private var maskVP:SpriteUI = new SpriteUI();
	
	private var _horizontalScrollPolicy:String = "auto";
	/**
		 * Indicates under what conditions the horizontal scroll bar is displayed. The acceptable values are "auto" or "off".
		 *
		 * The default value is `auto`
		 */
	public var horizontalScrollPolicy(get, set):String;
	
	private function get_horizontalScrollPolicy():String
	{
		return _horizontalScrollPolicy;
	}
	
	private function set_horizontalScrollPolicy(value:String)
	{
		_horizontalScrollPolicy = value;
		createChildren();
		return value;
	}
	
	private var _verticalScrollPolicy:String = "auto";
	/**
		 * Indicates under what conditions the vertical scroll bar is displayed. The acceptable values are "auto" or "off".
		 *
		 * The default value is `auto`
		 */
	public var verticalScrollPolicy(get, set):String;
	
	private function get_verticalScrollPolicy():String
	{
		return _verticalScrollPolicy;
	}
	
	private function set_verticalScrollPolicy(value:String)
	{
		_verticalScrollPolicy = value;
		createChildren();
		return value;
	}
	
	public var horizontalScrollBar:SpriteUI;
	private var horizontalScrollBarBG:Sprite = new Sprite();
	private var horizontalScrollBarLeft:Sprite = new Sprite();
	private var horizontalScrollBarCursor:Sprite = new Sprite();
	private var horizontalScrollBarRight:Sprite = new Sprite();
	public var verticalScrollBar:SpriteUI;
	private var verticalScrollBarBG:Sprite = new Sprite();
	private var verticalScrollBarUp:Sprite = new Sprite();
	private var verticalScrollBarCursor:Sprite = new Sprite();
	private var verticalScrollBarDown:Sprite = new Sprite();
	@:dox(hide)
	public var scrollerSize:Int = 10;
	private var startMove:Point;
	private var swipeLatencyToStart:Int = 5;
	private var swipeSpeed:Float = 2;
	private var previousGlobalMove:Point;
	private var previousViewPort:Rectangle;
	private var previousContent:Rectangle = new Rectangle();
	private var scrollBarColor:Int = 0xFFA500;
	private var iconColor:Int = 0xFFFFFF;
	private var backgroundSBColor:Int = 0xCCCCCC;
	/**
		 * Swipe to scroll the viewport.
		 *
		 * The default value is `true`
		 */
	public var swipe:Bool = true;
	private var previousIsPositiveSwipeX:Bool;
	private var previousIsPositiveSwipeY:Bool;
	
	private var _width:Float = Math.NaN;
	
	private var Width(get, never):Float;
	
	private function get_Width():Float
	{
		if( Math.isNaN( _width ) ) return getWidth();
		return _width;
	}
	
	private var _getWidth:Float = 0;
	
	override private function getWidth():Float
	{
		if( ! isCreating ) return _getWidth;
		_getWidth = super.getWidth();
		return _getWidth;
	}
	
	/*override private function get_width():Float
	{
		return viewPort.width;
	}*/
	
	@:dox(hide)
	#if flash @:setter(width) public #else override public #end function set_width(value:Float)
	{
		_width = value;
		createChildren();
		#if !flash return value; #end
	}
	
	private var _height:Float = Math.NaN;
	
	private var Height(get, never):Float;
	
	private function get_Height():Float
	{
		if( Math.isNaN( _height ) ) return getHeight();
		return _height;
	}
	
	private var _getHeight:Float = 0;
	
	override private function getHeight():Float
	{
		if( ! isCreating ) return _getHeight;
		_getHeight = super.getHeight();
		return _getHeight;
	}
	
	/*override private function get_height():Float
	{
		return viewPort.height;
	}*/
	
	@:dox(hide)
	#if flash @:setter(height) public #else override public #end function set_height(value:Float)
	{
		_height = value;
		createChildren();
		#if !flash return value; #end
	}
	
	private var _x:Float = 0;
	
	#if flash @:getter(x) public #else override public #end function get_x():Float
	{
		return _x;
	}
	
	#if flash @:setter(x) public #else override public #end function set_x(value:Float)
	{
		_x = value;
		super.x = value - pivotX;
		#if !flash return value; #end
	}
	
	private var _y:Float = 0;
	
	#if flash @:getter(y) public #else override public #end function get_y():Float
	{
		return _y;
	}
	
	#if flash @:setter(y) public #else override public #end function set_y(value:Float)
	{
		_y = value;
		super.y = value - pivotY;
		#if !flash return value; #end
	}
	
	private var _pivotX:Float = 0;
	/**
		 * The x coordinate of the object's origin in its own coordinate space (default: 0).
		 */
	public var pivotX(get, set):Float;
	
	private function get_pivotX():Float
	{
		return _pivotX;
	}
	
	private function set_pivotX(value:Float)
	{
		_pivotX = value;
		var x:Float = this.x;
		return this.x = x;
	}
	
	private var _pivotY:Float = 0;
	/**
		 * The y coordinate of the object's origin in its own coordinate space (default: 0).
		 */
	public var pivotY(get, set):Float;
	
	private function get_pivotY():Float
	{
		return _pivotY;
	}
	
	private function set_pivotY(value:Float)
	{
		_pivotY = value;
		var y:Float = this.y;
		return this.y = y;
	}
	
	/**
		 * Get a number that represents the maximum horizontal scroll position.
		 */
	public var maxHorizontalScrollPosition(get, never):Float;
	
	private function get_maxHorizontalScrollPosition():Float
	{
		var width:Float = viewPort.width;
		var contentWidth:Float = this.contentWidth;
		/*var widthSB:Float = horizontalScrollBarCursor.width;
		var contentWidthSB:Float = horizontalScrollBarRight.x - scrollerSize - gap * 2;
		return contentWidthSB - widthSB;*/
		return contentWidth - width;
	}
	
	/**
		 * Get a number that represents the maximum vertical scroll position.
		 */
	public var maxVerticalScrollPosition(get, never):Float;
	
	private function get_maxVerticalScrollPosition():Float
	{
		var height:Float = viewPort.height;
		var contentHeight:Float = this.contentHeight;
		/*var heightSB:Float = verticalScrollBarCursor.height;
		var contentHeightSB:Float = verticalScrollBarDown.y - scrollerSize - gap * 2;
		return contentHeightSB - heightSB;*/
		return contentHeight - height;
	}
	
	/**
		 * The x coordinate of the origin of the viewport in the component's coordinate system, where the default value is (0,0) corresponding to the upper-left corner of the component.
		 */
	public var horizontalScrollPosition(get, set):Float;
	
	private function get_horizontalScrollPosition():Float
	{
		var contentWidth:Float = this.contentWidth;
		var contentWidthSB:Float = horizontalScrollBarRight.x - scrollerSize - gap * 2;
		var x:Float = horizontalScrollBarCursor.x - scrollerSize - gap;
		//return horizontalScrollBarCursor.x - scrollerSize - gap;
		return x * contentWidth / contentWidthSB;
	}
	
	private function set_horizontalScrollPosition(x:Float)
	{
		if( ! horizontalScrollBar.visible ) return x;
		var contentWidth:Float = this.contentWidth;
		var contentWidthSB:Float = horizontalScrollBarRight.x - scrollerSize - gap * 2;
		x *= contentWidthSB / contentWidth;
		if( x < 0 ) x = 0;
		if( x > maxHorizontalScrollPosition ) x = maxHorizontalScrollPosition;
		horizontalScrollBarCursor.x = scrollerSize + gap + x;
		horizontalScrollBarCursorClickHandler();
		return x;
	}
	
	/**
		 * The y coordinate of the origin of the viewport in the component's coordinate system, where the default value is (0,0) corresponding to the upper-left corner of the component.
		 */
	public var verticalScrollPosition(get, set):Float;
	
	private function get_verticalScrollPosition():Float
	{
		var contentHeight:Float = this.contentHeight;
		var contentHeightSB:Float = verticalScrollBarDown.y - scrollerSize - gap * 2;
		var y:Float = verticalScrollBarCursor.y - scrollerSize - gap;
		//return verticalScrollBarCursor.y - ( scrollerSize + gap );
		return y * contentHeight / contentHeightSB;
	}
	
	private function set_verticalScrollPosition(y:Float)
	{
		if( ! verticalScrollBar.visible ) return y;
		var contentHeight:Float = this.contentHeight;
		var contentHeightSB:Float = verticalScrollBarDown.y - scrollerSize - gap * 2;
		y *= contentHeightSB / contentHeight;
		if( y < 0 ) y = 0;
		if( y > maxVerticalScrollPosition ) y = maxVerticalScrollPosition;
		verticalScrollBarCursor.y = scrollerSize + gap + y;
		verticalScrollBarCursorClickHandler();
		return y;
	}
		
	private var horizontalScrollBarHeight(get, never):Float;
	
	private function get_horizontalScrollBarHeight():Float
	{
		return horizontalScrollBar.visible ? scrollerSize : 0;
	}
	
	private var verticalScrollBarWidth(get, never):Float;
	
	private function get_verticalScrollBarWidth():Float
	{
		return verticalScrollBar.visible ? scrollerSize : 0;
	}
	
	private var gap:Float = 1;
	
	/**
		 * The rectangle displayed and scrolled within the Scroller.
		 */
	public var viewPort(get, never):Rectangle;
	
	private function get_viewPort():Rectangle
	{
		if( horizontalScrollBar == null ) return new Rectangle();
		return new Rectangle( maskVP.x, maskVP.y, maskVP.width - verticalScrollBarWidth, maskVP.height - horizontalScrollBarHeight );
	}
		
	@:dox(hide)
	public function new()
	{
		super();
		//this.visible = false;
		maskVP.graphics.beginFill(0x000000);
        maskVP.graphics.drawRect(0, 0, 0, 0);
        maskVP.graphics.endFill();
		maskVP.noLayout = true;
		this.addChild( maskVP );
		previousViewPort = new Rectangle();
		this.mask = maskVP;
		this.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
	}
	
	private function addedToStageHandler(event:Event):Void
	{
		this.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		stage.addEventListener( MouseEvent.MOUSE_DOWN, swipeMouseDownHandler );
	}
	
	override private function style():Void
	{
		super.style();
		if( Theme.scrollBarColor != -1 ) scrollBarColor = Theme.scrollBarColor;
		if( Theme.iconColor != -1 ) iconColor = Theme.iconColor;
		if( Theme.backgroundColor != -1 ) backgroundSBColor = Theme.backgroundColor;
	}
	
	//override private function updateDisplayList(unscaledWidth:Float, unscaledHeight:Float):Void
	override private function measure():Void
	{
		super.measure();
		createViewPort();
		//super.updateDisplayList(unscaledWidth, unscaledHeight);
	}
	
	private function createViewPort():Void
	{
		var previousHorizontalScrollPosition:Float = 0;
		var previousVerticalScrollPosition:Float = 0;
		if( horizontalScrollBar != null ) previousHorizontalScrollPosition = horizontalScrollPosition;
		if( verticalScrollBar != null ) previousVerticalScrollPosition = verticalScrollPosition;
		
		if( horizontalScrollBar == null ) createHorizontalScrollBar();
		if( verticalScrollBar == null ) createVerticalScrollBar();
		
		//trace("CREATE VIEWPORT");
		var width:Float = this.Width;
		var height:Float = this.Height;
		var contentWidth:Float = this.contentWidth;
		var contentHeight:Float = this.contentHeight;
		var isChange:Bool = false;
		var rect:Rectangle = new Rectangle( 0, 0, width, height );
		var rectContent:Rectangle = new Rectangle( 0, 0, contentWidth, contentHeight );
		if( ! rect.equals( previousViewPort ) || ! rectContent.equals( previousContent ) )
		{
			maskVP.graphics.clear();
			maskVP.graphics.beginFill(0x000000);
			maskVP.graphics.drawRect(0, 0, width, height);
			maskVP.graphics.endFill();
			isChange = true;
			previousViewPort = rect.clone();
			previousContent = rectContent.clone();
		}
		
		var horizontalScrollBarVisible:Bool = false;
		var verticalScrollBarVisible:Bool = false;
		if( ! Math.isNaN( this._width ) && contentWidth > this._width ) horizontalScrollBarVisible = true;
		if( ! Math.isNaN( this._height ) && contentHeight > this._height ) verticalScrollBarVisible = true;
		if( horizontalScrollBarVisible && ! verticalScrollBarVisible)
		{
			if( ! Math.isNaN( this._height ) && contentHeight > this._height - scrollerSize )  verticalScrollBarVisible = true;
		}
		else if( ! horizontalScrollBarVisible && verticalScrollBarVisible)
		{
			if( ! Math.isNaN( this._width ) && contentWidth > this._width - scrollerSize )  horizontalScrollBarVisible = true;
		}
		
		if( Math.isNaN( this._width ) || ! horizontalScrollBarVisible || horizontalScrollPolicy == "off" )
		{
			horizontalScrollBar.visible = false;
		}
		else
		{
			horizontalScrollBar.visible = true;
		}
		
		if( Math.isNaN( this._height ) || ! verticalScrollBarVisible || verticalScrollPolicy == "off" )
		{
			verticalScrollBar.visible = false;
		}
		else
		{
			verticalScrollBar.visible = true;
		}
		
		horizontalScrollBar.y = viewPort.y + viewPort.height;
		horizontalScrollBarBG.width = viewPort.width;
		horizontalScrollBarCursor.x = scrollerSize + gap;
		horizontalScrollBarCursor.width = viewPort.width - scrollerSize * 2 - gap * 2;
		horizontalScrollBarCursor.width *= viewPort.width / contentWidth;
		horizontalScrollBarRight.x = viewPort.width - scrollerSize;
		
		verticalScrollBar.x = viewPort.x + viewPort.width;
		verticalScrollBarBG.height = viewPort.height;
		verticalScrollBarCursor.y = scrollerSize + gap;
		verticalScrollBarCursor.height = viewPort.height - scrollerSize * 2 - gap * 2;
		verticalScrollBarCursor.height *= viewPort.height / contentHeight;
		verticalScrollBarDown.y = viewPort.height - scrollerSize;
		
		if( isChange )
		{
			if( horizontalScrollBar.visible && verticalScrollBar.visible )
			{
				maskVP.graphics.clear();
				maskVP.graphics.beginFill(0x000000);
				maskVP.graphics.drawRect(0, 0, width, height - scrollerSize);
				maskVP.graphics.drawRect(0, height - scrollerSize, width - scrollerSize, scrollerSize);
				maskVP.graphics.endFill();
			}
			else if( ( horizontalScrollBar.visible && ! verticalScrollBar.visible ) || ( ! horizontalScrollBar.visible && verticalScrollBar.visible ) )
			{
				if( horizontalScrollBar.visible && Math.isNaN( this._height ) ) horizontalScrollBar.y = viewPort.y + maskVP.height;
				if( verticalScrollBar.visible && Math.isNaN( this._width ) ) verticalScrollBar.x = viewPort.x + maskVP.width;
				maskVP.graphics.clear();
				maskVP.graphics.beginFill(0x000000);
				var _width:Float = Math.isNaN( this._width ) ? width + verticalScrollBarWidth : width;
				var _height:Float = Math.isNaN( this._height ) ? height + horizontalScrollBarHeight : height;
				maskVP.graphics.drawRect(0, 0, _width, _height);
				maskVP.graphics.endFill();
			}
		}
		
		this.setChildIndex( horizontalScrollBar, this.numChildren - 1 );
		
		if( previousHorizontalScrollPosition != 0 )
		{
			var horizontalScrollPosition:Float = previousHorizontalScrollPosition > maxHorizontalScrollPosition ? maxHorizontalScrollPosition : previousHorizontalScrollPosition;
			this.horizontalScrollPosition = horizontalScrollPosition;
		}
		
		this.setChildIndex( verticalScrollBar, this.numChildren - 1 );
		
		if( previousVerticalScrollPosition != 0 )
		{
			var verticalScrollPosition:Float = previousVerticalScrollPosition > maxVerticalScrollPosition ? maxVerticalScrollPosition : previousVerticalScrollPosition;
			this.verticalScrollPosition = verticalScrollPosition;
		}
	}
	
	private function createHorizontalScrollBar():Void
	{
		horizontalScrollBar = new SpriteUI();
		horizontalScrollBar.noLayout = true;
		
		horizontalScrollBarBG.graphics.beginFill(backgroundSBColor);
        horizontalScrollBarBG.graphics.drawRect(0, 0, 40, scrollerSize);
        horizontalScrollBarBG.graphics.endFill();
		//horizontalScrollBarBG.alpha = 0.4;
		horizontalScrollBar.addChild( horizontalScrollBarBG );
		
		horizontalScrollBarLeft.graphics.beginFill(scrollBarColor);
        horizontalScrollBarLeft.graphics.drawRect(0, 0, scrollerSize, scrollerSize);
        horizontalScrollBarLeft.graphics.endFill();
		horizontalScrollBarLeft.graphics.beginFill(iconColor);
		horizontalScrollBarLeft.graphics.moveTo(2,5);
		horizontalScrollBarLeft.graphics.lineTo(8,2);
		horizontalScrollBarLeft.graphics.lineTo(8,8);
		horizontalScrollBarLeft.graphics.lineTo(2,5);
		horizontalScrollBarLeft.graphics.endFill();
		horizontalScrollBarLeft.addEventListener( MouseEvent.MOUSE_DOWN, horizontalScrollBarLeftMouseDownHandler );
		horizontalScrollBar.addChild( horizontalScrollBarLeft );
		
		horizontalScrollBarCursor.graphics.beginFill(scrollBarColor);
        horizontalScrollBarCursor.graphics.drawRect(0, 0, 40, scrollerSize);
        horizontalScrollBarCursor.graphics.endFill();
		horizontalScrollBarCursor.addEventListener( MouseEvent.MOUSE_DOWN, horizontalScrollBarCursorMouseDownHandler );
		horizontalScrollBar.addChild( horizontalScrollBarCursor );
		
		horizontalScrollBarRight.graphics.beginFill(scrollBarColor);
        horizontalScrollBarRight.graphics.drawRect(0, 0, scrollerSize, scrollerSize);
        horizontalScrollBarRight.graphics.endFill();
		horizontalScrollBarRight.graphics.beginFill(iconColor);
		horizontalScrollBarRight.graphics.moveTo(2,2);
		horizontalScrollBarRight.graphics.lineTo(8,5);
		horizontalScrollBarRight.graphics.lineTo(2,8);
		horizontalScrollBarRight.graphics.lineTo(2,2);
		horizontalScrollBarRight.graphics.endFill();
		horizontalScrollBarRight.addEventListener( MouseEvent.MOUSE_DOWN, horizontalScrollBarRightMouseDownHandler );
		horizontalScrollBar.addChild( horizontalScrollBarRight );
		
		this.addChild( horizontalScrollBar );
	}
	
	private function createVerticalScrollBar():Void
	{
		verticalScrollBar = new SpriteUI();
		verticalScrollBar.noLayout = true;
		
		verticalScrollBarBG.graphics.beginFill(backgroundSBColor);
        verticalScrollBarBG.graphics.drawRect(0, 0, scrollerSize, 40);
        verticalScrollBarBG.graphics.endFill();
		//verticalScrollBarBG.alpha = 0.4;
		verticalScrollBar.addChild( verticalScrollBarBG );
		
		verticalScrollBarUp.graphics.beginFill(scrollBarColor);
        verticalScrollBarUp.graphics.drawRect(0, 0, scrollerSize, scrollerSize);
        verticalScrollBarUp.graphics.endFill();
		verticalScrollBarUp.graphics.beginFill(iconColor);
		verticalScrollBarUp.graphics.moveTo(5,2);
		verticalScrollBarUp.graphics.lineTo(8,8);
		verticalScrollBarUp.graphics.lineTo(2,8);
		verticalScrollBarUp.graphics.lineTo(5,2);
		verticalScrollBarUp.graphics.endFill();
		verticalScrollBarUp.addEventListener( MouseEvent.MOUSE_DOWN, verticalScrollBarUpMouseDownHandler );
		verticalScrollBar.addChild( verticalScrollBarUp );
		
		verticalScrollBarCursor.graphics.beginFill(scrollBarColor);
        verticalScrollBarCursor.graphics.drawRect(0, 0, scrollerSize, 40);
        verticalScrollBarCursor.graphics.endFill();
		verticalScrollBarCursor.addEventListener( MouseEvent.MOUSE_DOWN, verticalScrollBarCursorMouseDownHandler );
		verticalScrollBar.addChild( verticalScrollBarCursor );
		
		verticalScrollBarDown.graphics.beginFill(scrollBarColor);
        verticalScrollBarDown.graphics.drawRect(0, 0, scrollerSize, scrollerSize);
        verticalScrollBarDown.graphics.endFill();
		verticalScrollBarDown.graphics.beginFill(iconColor);
		verticalScrollBarDown.graphics.moveTo(2,2);
		verticalScrollBarDown.graphics.lineTo(8,2);
		verticalScrollBarDown.graphics.lineTo(5,8);
		verticalScrollBarDown.graphics.lineTo(2,2);
		verticalScrollBarDown.graphics.endFill();
		verticalScrollBarDown.addEventListener( MouseEvent.MOUSE_DOWN, verticalScrollBarDownMouseDownHandler );
		verticalScrollBar.addChild( verticalScrollBarDown );
		
		this.addChild( verticalScrollBar );
	}
		
	private function horizontalScrollBarLeftMouseDownHandler(event:MouseEvent):Void
	{
		stage.addEventListener(MouseEvent.MOUSE_UP, horizontalScrollBarLeftMouseUpHandler);
		mouseChildren = false;
		this.addEventListener(Event.ENTER_FRAME, horizontalScrollBarLeftClickHandler);
	}
	
	private function horizontalScrollBarLeftMouseUpHandler(event:MouseEvent):Void
	{
		this.removeEventListener(Event.ENTER_FRAME, horizontalScrollBarLeftClickHandler);
		mouseChildren = true;
		stage.removeEventListener(MouseEvent.MOUSE_UP, horizontalScrollBarLeftMouseUpHandler);
	}
	
	private function horizontalScrollBarLeftClickHandler(event:Event):Void
	{
		var width:Float = viewPort.width;
		var contentWidth:Float = this.contentWidth;
		var widthSB:Float = horizontalScrollBarCursor.width;
		var contentWidthSB:Float = horizontalScrollBarRight.x - scrollerSize - gap * 2;
		
		horizontalScrollBarCursor.x -= 5 * ( contentWidthSB - widthSB ) / ( contentWidth - width );
		
		positioningX( width, contentWidth, widthSB, contentWidthSB );
	}
	
	private function horizontalScrollBarRightMouseDownHandler(event:MouseEvent):Void
	{
		stage.addEventListener(MouseEvent.MOUSE_UP, horizontalScrollBarRightMouseUpHandler);
		mouseChildren = false;
		this.addEventListener(Event.ENTER_FRAME, horizontalScrollBarRightClickHandler);
	}
	
	private function horizontalScrollBarRightMouseUpHandler(event:MouseEvent):Void
	{
		this.removeEventListener(Event.ENTER_FRAME, horizontalScrollBarRightClickHandler);
		mouseChildren = true;
		stage.removeEventListener(MouseEvent.MOUSE_UP, horizontalScrollBarRightMouseUpHandler);
	}
	
	private function horizontalScrollBarRightClickHandler(event:Event):Void
	{
		var width:Float = viewPort.width;
		var contentWidth:Float = this.contentWidth;
		var widthSB:Float = horizontalScrollBarCursor.width;
		var contentWidthSB:Float = horizontalScrollBarRight.x - scrollerSize - gap * 2;
		
		horizontalScrollBarCursor.x += 5 * ( contentWidthSB - widthSB ) / ( contentWidth - viewPort.width );
		
		positioningX( width, contentWidth, widthSB, contentWidthSB );
	}
	
	private function verticalScrollBarUpMouseDownHandler(event:MouseEvent):Void
	{
		stage.addEventListener(MouseEvent.MOUSE_UP, verticalScrollBarUpMouseUpHandler);
		mouseChildren = false;
		this.addEventListener(Event.ENTER_FRAME, verticalScrollBarUpClickHandler);
	}
	
	private function verticalScrollBarUpMouseUpHandler(event:MouseEvent):Void
	{
		this.removeEventListener(Event.ENTER_FRAME, verticalScrollBarUpClickHandler);
		mouseChildren = true;
		stage.removeEventListener(MouseEvent.MOUSE_UP, verticalScrollBarUpMouseUpHandler);
	}
	
	private function verticalScrollBarUpClickHandler(event:Event):Void
	{
		var height:Float = viewPort.height;
		var contentHeight:Float = this.contentHeight;
		var heightSB:Float = verticalScrollBarCursor.height;
		var contentHeightSB:Float = verticalScrollBarDown.y - scrollerSize - gap * 2;
		
		verticalScrollBarCursor.y -= 5 * ( contentHeightSB - heightSB ) / ( contentHeight - height );
		
		positioningY( height, contentHeight, heightSB, contentHeightSB );
	}
	
	private function verticalScrollBarDownMouseDownHandler(event:MouseEvent):Void
	{
		stage.addEventListener(MouseEvent.MOUSE_UP, verticalScrollBarDownMouseUpHandler);
		mouseChildren = false;
		this.addEventListener(Event.ENTER_FRAME, verticalScrollBarDownClickHandler);
	}
	
	private function verticalScrollBarDownMouseUpHandler(event:MouseEvent):Void
	{
		this.removeEventListener(Event.ENTER_FRAME, verticalScrollBarDownClickHandler);
		mouseChildren = true;
		stage.removeEventListener(MouseEvent.MOUSE_UP, verticalScrollBarDownMouseUpHandler);
	}
	
	private function verticalScrollBarDownClickHandler(event:Event):Void
	{
		var height:Float = viewPort.height;
		var contentHeight:Float = this.contentHeight;
		var heightSB:Float = verticalScrollBarCursor.height;
		var contentHeightSB:Float = verticalScrollBarDown.y - scrollerSize - gap * 2;
		
		verticalScrollBarCursor.y += 5 * ( contentHeightSB - heightSB ) / ( contentHeight - height );
		
		positioningY( height, contentHeight, heightSB, contentHeightSB );
	}
	
	private function horizontalScrollBarCursorMouseDownHandler(event:MouseEvent):Void
	{
		stage.addEventListener(MouseEvent.MOUSE_UP, horizontalScrollBarCursorMouseUpHandler);
		var widthSB:Float = horizontalScrollBarCursor.width;
		var contentWidthSB:Float = horizontalScrollBarRight.x - scrollerSize - gap * 2;
		var bounds:Rectangle = new Rectangle( scrollerSize + gap, 0, contentWidthSB - widthSB, 0 );
		mouseChildren = false;
		horizontalScrollBarCursor.startDrag(false, bounds);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, horizontalScrollBarCursorMouseMoveHandler);
	}
	
	private function horizontalScrollBarCursorMouseMoveHandler(event:MouseEvent):Void
	{
		horizontalScrollBarCursorClickHandler();
	}
	
	private function horizontalScrollBarCursorMouseUpHandler(event:MouseEvent):Void
	{
		mouseChildren = true;
		horizontalScrollBarCursor.stopDrag();
		stage.removeEventListener(MouseEvent.MOUSE_UP, horizontalScrollBarCursorMouseUpHandler);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, horizontalScrollBarCursorMouseMoveHandler);
	}
	
	private function horizontalScrollBarCursorClickHandler():Void
	{
		var width:Float = viewPort.width;
		var contentWidth:Float = this.contentWidth;
		var widthSB:Float = horizontalScrollBarCursor.width;
		var contentWidthSB:Float = horizontalScrollBarRight.x - scrollerSize - gap * 2;
		
		positioningX( width, contentWidth, widthSB, contentWidthSB );
	}
	
	private function verticalScrollBarCursorMouseDownHandler(event:MouseEvent):Void
	{
		stage.addEventListener(MouseEvent.MOUSE_UP, verticalScrollBarCursorMouseUpHandler);
		var heightSB:Float = verticalScrollBarCursor.height;
		var contentHeightSB:Float = verticalScrollBarDown.y - scrollerSize - gap * 2;
		var bounds:Rectangle = new Rectangle( 0, scrollerSize + gap, 0, contentHeightSB - heightSB );
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
	
	private function verticalScrollBarCursorClickHandler():Void
	{
		var height:Float = viewPort.height;
		var contentHeight:Float = this.contentHeight;
		var heightSB:Float = verticalScrollBarCursor.height;
		var contentHeightSB:Float = verticalScrollBarDown.y - scrollerSize - gap * 2;
		
		positioningY( height, contentHeight, heightSB, contentHeightSB );
	}
	
	private function swipeMouseDownHandler(event:MouseEvent):Void
	{
		if( ! swipe ) return;
		var width:Float = viewPort.width;
		var height:Float = viewPort.height;
		var point:Point = this.localToGlobal( new Point( viewPort.x, viewPort.y ) );
		var rect:Rectangle = new Rectangle( point.x, point.y, width, height );
		previousGlobalMove = new Point( stage.mouseX, stage.mouseY );
		startMove = previousGlobalMove.clone();
		if( ! rect.containsPoint( startMove ) ) return;
		stage.addEventListener(MouseEvent.MOUSE_UP, swipeMouseUpHandler);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, swipeMouseMoveHandler);
	}
	
	private function swipeMouseMoveHandler(event:MouseEvent):Void
	{
		var width:Float = viewPort.width;
		var contentWidth:Float = this.contentWidth;
		var widthSB:Float = horizontalScrollBarCursor.width;
		var contentWidthSB:Float = horizontalScrollBarRight.x - scrollerSize - gap * 2;
		
		var height:Float = viewPort.height;
		var contentHeight:Float = this.contentHeight;
		var heightSB:Float = verticalScrollBarCursor.height;
		var contentHeightSB:Float = verticalScrollBarDown.y - scrollerSize - gap * 2;
		
		var point:Point = this.localToGlobal( new Point( viewPort.x, viewPort.y ) );
		var rect:Rectangle = new Rectangle( point.x, point.y, width, height );
		var global:Point = new Point( stage.mouseX, stage.mouseY );
		if( ! rect.containsPoint( global ) ) return;
		
		var isPositiveSwipeX:Bool = global.x > previousGlobalMove.x ? true : false;
		if( isPositiveSwipeX != previousIsPositiveSwipeX ) startMove.x = global.x; // direction x change
		var isPositiveSwipeY:Bool = global.y > previousGlobalMove.y ? true : false;
		if( isPositiveSwipeY != previousIsPositiveSwipeY ) startMove.y = global.y; // direction y change
		
		if( horizontalScrollBar.visible )
		{
			if(global.x < startMove.x - swipeLatencyToStart) //next
			{
				mouseChildren = false;
				var delta:Float = (global.x - previousGlobalMove.x ) * swipeSpeed;
				if( Math.abs( delta ) > swipeSpeed * 10 ) delta = - swipeSpeed * 10;
				
				horizontalScrollBarCursor.x -= delta * ( contentWidthSB - widthSB ) / ( contentWidth - width );
				
				positioningX( width, contentWidth, widthSB, contentWidthSB );
			}
			else if(global.x > startMove.x + swipeLatencyToStart) //previous
			{
				mouseChildren = false;
				var delta:Float = (global.x - previousGlobalMove.x ) * swipeSpeed;
				if( Math.abs( delta ) > swipeSpeed * 10 ) delta = swipeSpeed * 10;
				
				horizontalScrollBarCursor.x -= delta * ( contentWidthSB - widthSB ) / ( contentWidth - width );
				
				positioningX( width, contentWidth, widthSB, contentWidthSB );
			}
		}
		
		if( verticalScrollBar.visible )
		{
			if(global.y < startMove.y - swipeLatencyToStart) //next
			{
				mouseChildren = false;
				var delta:Float = (global.y - previousGlobalMove.y ) * swipeSpeed;
				if( Math.abs( delta ) > swipeSpeed * 10 ) delta = - swipeSpeed * 10;
				
				verticalScrollBarCursor.y -= delta * ( contentHeightSB - heightSB ) / ( contentHeight - height );
				
				positioningY( height, contentHeight, heightSB, contentHeightSB );
			}
			else if(global.y > startMove.y + swipeLatencyToStart) //previous
			{
				mouseChildren = false;
				var delta:Float = (global.y - previousGlobalMove.y ) * swipeSpeed;
				if( Math.abs( delta ) > swipeSpeed * 10 ) delta = swipeSpeed * 10;
				
				verticalScrollBarCursor.y -= delta * ( contentHeightSB - heightSB ) / ( contentHeight - height );
				
				positioningY( height, contentHeight, heightSB, contentHeightSB );
			}
		}
		
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
	
	private function positioningX(width:Float, contentWidth:Float, widthSB:Float, contentWidthSB:Float):Void
	{
		if( horizontalScrollBarCursor.x < scrollerSize + gap )
		{
			horizontalScrollBarCursor.x = scrollerSize + gap;
		}
		else if( horizontalScrollBarCursor.x > horizontalScrollBarRight.x - gap - horizontalScrollBarCursor.width)
		{
			horizontalScrollBarCursor.x = horizontalScrollBarRight.x - gap - horizontalScrollBarCursor.width;
		}
		
		var x:Float = horizontalScrollBarCursor.x - scrollerSize - gap;
		
		var previousViewPort:Point = this.localToGlobal( new Point(viewPort.x, 0) );
		previousViewPort = parent.globalToLocal( previousViewPort );
		
		maskVP.x = x * ( contentWidth - width ) / ( contentWidthSB - widthSB );
		var point:Point = this.localToGlobal( new Point(viewPort.x, 0) );
		point = parent.globalToLocal( point );
		
		this.pivotX += point.subtract( previousViewPort ).x;
		//this.x -= point.subtract( previousViewPort ).x;
		horizontalScrollBar.x = viewPort.x;
		verticalScrollBar.x = viewPort.x + width;
	}
	
	private function positioningY(height:Float, contentHeight:Float, heightSB:Float, contentHeightSB:Float):Void
	{
		if( verticalScrollBarCursor.y < scrollerSize + gap )
		{
			verticalScrollBarCursor.y = scrollerSize + gap;
		}
		else if( verticalScrollBarCursor.y > verticalScrollBarDown.y - gap - verticalScrollBarCursor.height)
		{
			verticalScrollBarCursor.y = verticalScrollBarDown.y - gap - verticalScrollBarCursor.height;
		}
		
		var y:Float = verticalScrollBarCursor.y - scrollerSize - gap;
		
		var previousViewPort:Point = this.localToGlobal( new Point(0, viewPort.y) );
		previousViewPort = parent.globalToLocal( previousViewPort );
		
		maskVP.y = y * ( contentHeight - height ) / ( contentHeightSB - heightSB );
		var point:Point = this.localToGlobal( new Point(0, viewPort.y) );
		point = parent.globalToLocal( point );
		
		this.pivotY += point.subtract( previousViewPort ).y;
		//this.y -= point.subtract( previousViewPort ).y;
		verticalScrollBar.y = viewPort.y;
		horizontalScrollBar.y = viewPort.y + height;
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