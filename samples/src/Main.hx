/*
Copyright 2019 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/

package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openflexUI.controls.Scroller;
import openflexUI.controls.UIComponent;
import openflexUI.events.FlexEvent;
import openflexUI.layout.HorizontalLayout;
import openflexUI.layout.VerticalLayout;

class Main extends Sprite
{
    private var result:TextField = new TextField();
	private var scroller:Scroller = new Scroller();
    
    public function new()
    {
        super();
        
		var component_2:UIComponent = new UIComponent();
		component_2.name="component_2";
		var verticalLayout_2:VerticalLayout = new VerticalLayout();
		verticalLayout_2.gap = 10;
		component_2.layout = verticalLayout_2;
		component_2.addEventListener( FlexEvent.CREATION_COMPLETE, creationCompleteHandler );
		
		scroller.name="scroller";
		scroller.width = 130;
		scroller.height = 70;
		
		var component_1:UIComponent = new UIComponent();
		component_1.name="component_1";
		var horizontalLayout_1:HorizontalLayout = new HorizontalLayout();
		horizontalLayout_1.gap = 10;
		component_1.layout = horizontalLayout_1;
		scroller.addChild( component_1 );
		component_2.addChild( scroller );
		
        var mybtn_1:Sprite = new Sprite();
		mybtn_1.name="mybtn_1";
        mybtn_1.graphics.beginFill(0xFF0000);
        mybtn_1.graphics.drawRect(0, 0, 100, 100);
        mybtn_1.graphics.endFill();
        mybtn_1.addEventListener(MouseEvent.MOUSE_UP, tch_btn_1);
        
        var mybtn_2:Sprite = new Sprite();
		mybtn_2.name="mybtn_2";
        mybtn_2.graphics.beginFill(0x00FF00);
        mybtn_2.graphics.drawRect(0, 0, 100, 50);
        mybtn_2.graphics.endFill();
        mybtn_2.addEventListener(MouseEvent.MOUSE_UP, tch_btn_2);
        
        var mybtn_3:Sprite = new Sprite();
		mybtn_3.name="mybtn_3";
        mybtn_3.graphics.beginFill(0x0000FF);
        mybtn_3.graphics.drawRect(0, 0, 100, 100);
        mybtn_3.addEventListener(MouseEvent.MOUSE_UP, tch_btn_3);
        mybtn_3.graphics.endFill();
        
        component_1.addChild(mybtn_1);
        component_1.addChild(mybtn_2);
        component_1.addChild(mybtn_3);
		
		var mybtn_4:Sprite = new Sprite();
		mybtn_4.name="mybtn_4";
        mybtn_4.graphics.beginFill(0xFFFF00);
        mybtn_4.graphics.drawRect(0, 0, 100, 100);
        mybtn_4.graphics.endFill();
        mybtn_4.addEventListener(MouseEvent.MOUSE_UP, tch_btn_4);
		component_2.addChild(mybtn_4);
		
		this.addChild(component_2);
		
		//component_2.validate();
		//trace( "component_2", component_2.width, component_2.height );
        
        result.y = 120;
        result.height = 250;
        result.border = true;
        this.addChild(result);
    }
	
	private function creationCompleteHandler(event:FlexEvent):Void
	{
		var component_2:UIComponent = event.target;
		trace( "component_2", component_2.width, component_2.height );
	}
    
    private function tch_btn_1(event:MouseEvent):Void
    {
		result.appendText("action_1" + "\n");
		result.appendText(scroller.verticalScrollBarPosition + "\n");
		result.appendText(scroller.maxVerticalScrollBarPosition + "\n");
		result.appendText(scroller.horizontalScrollBarPosition + "\n");
		result.appendText(scroller.maxHorizontalScrollBarPosition + "\n");
    }
    
    private function tch_btn_2(event:MouseEvent):Void
    {
        result.appendText("action_2" + "\n");
		scroller.verticalScrollBarPosition = 10;
		scroller.horizontalScrollBarPosition = 20;
    }
    
    private function tch_btn_3(event:MouseEvent):Void
    {
        result.appendText("action_3" + "\n");
    }
	
	private function tch_btn_4(event:MouseEvent):Void
    {
        result.appendText("action_4" + "\n");
    }
}
