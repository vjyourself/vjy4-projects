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
	
	public class RandomFrameStart extends MovieClip{
		
		function RandomFrameStart(){
			gotoAndPlay(Math.floor(Math.random()*(totalFrames))+1);
		}
		
	
		
	}
}