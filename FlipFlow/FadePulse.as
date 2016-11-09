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
	//import vjyourself2.wave.WaveFollow;
	//import vjyourself2.wave.ColorScale;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	
	public class FadePulse extends MovieClip{
		var cc:Number=0;
		var delay:Number=24;
		function FadePulse(){
			cc=Math.floor(Math.random()*Math.PI*2);
			addEventListener(Event.ENTER_FRAME,onEF,0,0,1);
		}
		
		function onEF(e){
			cc+=0.1;
			fade.alpha=(Math.sin(cc)*0.5+0.5)*0.5;
			
		}
		
	}
}