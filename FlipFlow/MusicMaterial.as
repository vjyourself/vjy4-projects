package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.system.Capabilities;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.StageDisplayState;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;

	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;

	import flash.filters.ColorMatrixFilter;
	import 	fl.motion.AdjustColor;
	//import flash.media.CameraRoll;
	import flash.display.StageQuality;

	import flash.system.Capabilities;
	import vjyourself4.io.gamepad.GamepadManager;
	import vjyourself4.io.gamepad.GamepadState;
	import vjyourself4.sys.MetaStream;
	import flash.ui.GameInput;

	import vjyourself4.media.*;
	import vjyourself4.two.DrawWave;
	
	
	public class MusicMaterial{
		public var BMPD:BitmapData;
		public var dim:Number=512;
		
		public var compDrawWave:DrawWave;
		public var mmm1:Matrix;

		

		function MusicMaterial(){
			compDrawWave = new DrawWave();
			compDrawWave.baseCurve="circle";
			compDrawWave.doStars=false;
			compDrawWave.doLine=true;
			compDrawWave.doFill=false;
			compDrawWave.fillColor=0xffffff;
			compDrawWave.lineColor0=0xffffff;
			compDrawWave.lineT0=2;
			//compDrawWave.waveData=music.meta.waveDataDamped;
		}
		

		function init(){
			
			compDrawWave.wDimX=dim;
			compDrawWave.wDimY=dim;
			compDrawWave.init();

			mmm1 = new Matrix();
			mmm1.translate(dim/2,dim/2);
			
			BMPD = new BitmapData(dim,dim,false,0x000000);
		}

		function onEF(){
			compDrawWave.onEF();
			

			BMPD.fillRect(BMPD.rect, 0);
			BMPD.draw(compDrawWave.canvas,mmm1);
			//if(waveDrawMode==1) bmpDWave.draw(compDrawWave.canvas,mmm2);
			BMPD.applyFilter(BMPD,BMPD.rect,new Point(0,0),new BlurFilter(3,3));		
		}

		
	}
}