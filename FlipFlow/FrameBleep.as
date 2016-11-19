package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
//	import vjyourself2.wave.WaveFollow;
//	import vjyourself2.wave.ColorScale;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	
	public class FrameBleep extends MovieClip{
		var cc:Number=0;
		var delay:Number=24*5;
		var bleep=false;
		function FrameBleep(){
			cc=Math.floor(Math.random()*delay);
			addEventListener(Event.ENTER_FRAME,onEF,0,0,1);
			gotoAndStop(1);
		}
		
		function onEF(e){
			cc++;
			if(cc>=delay){
				cc=0;
				if(!bleep){
					bleep = true;
					gotoAndStop(2);
					delay=12;
				}else{
					bleep = false;
					gotoAndStop(1);
					delay=Math.floor(5*24+Math.random()*delay);
				}
				
			}
		}
		
	}
}