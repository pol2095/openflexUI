/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package openflexUI.data;

import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;
import openflexUI.events.ArrayCollectionEvent;

/**
 * A Label component displays one line of plain text. Label components do not have borders.
 */
class ArrayCollection extends EventDispatcher
{	
	//private var source:Array<{label:String, icon:BitmapData}> = [];
	private var source:Array<Dynamic> = [];
	
	public var length(get, never):Int;
	
	private function get_length()
	{
		if( source == null ) return 0;
		return source.length;
	}
		
	@:dox(hide)
	//public function new(source:Array<{label:String, icon:BitmapData}> = null)
	public function new(source:Array<Dynamic> = null)
	{
		super();
		
		this.source = source;
	}
	
	//public function addItemAt(item:{label:String, icon:BitmapData}, index:Int):Void
	public function addItemAt(item:Dynamic, index:Int):Void
	{
		this.dispatchEvent( new ArrayCollectionEvent( ArrayCollectionEvent.ADDED, item, index ) );
		if( source == null )
		{
			source = [ item ];
		}
		else
		{
			source.push(item);
		}
	}
	
	//public function addItem(item:{label:String, icon:BitmapData}):Void
	public function addItem(item:Dynamic):Void
	{
		this.addItemAt( item, this.length - 1 );
	}
	
	public function removeItemAt(index:Int):Void
	{
		this.dispatchEvent( new ArrayCollectionEvent( ArrayCollectionEvent.REMOVED, null, index ) );
		if( source != null ) source.splice( index, 1 );
	}
	
	public function removeAll():Void
	{
		this.dispatchEvent( new ArrayCollectionEvent( ArrayCollectionEvent.REMOVE_ALL, null, null ) );
		if( source != null ) source = [];
		trace(source);
	}
	
	//public function getItemAt(index:Int):{label:String, icon:BitmapData}
	public function getItemAt(index:Int):Dynamic
	{
		return source[index];
	}
	
	//public function setItemAt(item:{label:String, icon:BitmapData}, index:Int):Void
	public function setItemAt(item:Dynamic, index:Int):Void
	{
		this.dispatchEvent( new ArrayCollectionEvent( ArrayCollectionEvent.REPLACE, item, index ) );
		source[index] = item;
	}
	
	@:dox(hide)
	public function dispose():Void
	{
		//
	}
}