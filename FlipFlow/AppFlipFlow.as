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
	import flash.display.StageQuality;

	import flash.system.Capabilities;
	import vjyourself4.io.gamepad.GamepadManager;
	import vjyourself4.io.gamepad.GamepadState;
	import vjyourself4.sys.MetaStream;
	import flash.ui.GameInput;

	import vjyourself4.media.*;
	import vjyourself4.two.DrawWave;
	import vjyourself4.patt.WaveFollow;
	import vjyourself4.comp.CompFlipFlow;
	import vjyourself4.comp.CompFlipFlowMaps;
	import vjyourself4.comp.CompGlobals;

	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.events.ProgressEvent;

	import flash.media.CameraRoll;
	
	public class AppFlipFlow extends Sprite{
		
		//Params
		public var speed:Number=0.5;
		public var maxSpeed:Number=20;
		public var perform:Boolean=false;
		public var desktop:Boolean=true;
		public var fullscreen:Boolean=false;
		public var showUI:Boolean=true;
		public var showDebug:Boolean=false;
		public var musicActive:Boolean=false;
		public var contFile:String="contApp.swf";
		public var mapsName:String = "App";

		
		
		//Sys
		public var sys:Object={};
		var debug:MetaStream;
		var gamepad:GamepadManager;
		var music:Music;
		var screen:Object={};
		public var MM:Object={};

		//Cont Loader
		public var context:LoaderContext;
		var contLoader:Loader;
		
		//CompFlipFlow
		var compFlipFlow:CompFlipFlow;

		//UI		
		var buttPlus;
		var buttMinus;
		var buttFlip;
		var buttPrev;
		var buttNext;
		var buttMenu;
		var buttPhoto;
		var consoleVal;
		var overlayShadeUnderButtons:Sprite;
		var winMenu:WinMenu;

		var maps:Array;
		var dimX:Number;
		var dimY:Number;
		var ppi:Number;
		var dimXin:Number;
		var dimYin:Number;
		var dimDin:Number;
		var buttScale:Number=1;
		var smallSize:Boolean=false;
		var ups:Number=1.2;
			
	
		public var running:Boolean=false;
		
		
		//MM
		//public var MM:Object;
		/*var bmp:Bitmap;
		var bmpD:BitmapData;
		var canvas:Sprite;*/

		function AppFlipFlow(){
			init();
		}
		public function log(txt){trace(txt);}
		

		/********************************************************************************************
		  INIT
		*****************************************************************************************/
		
		public function init(){
			////////////////////////////////////////////////////////////////////
			// CREATE + INIT SYS :: debug / screen / music / io.gamepad
			////////////////////////////////////////////////////////////////////

			//SYS.DEBUG ////////////////////////////////////////////////////////
			debug = new MetaStream();
			debug.console={log:log};
			debug.init();
			sys.debug=debug;

			//SYS.MUSIC ////////////////////////////////////////////////////////
			if(musicActive){
				music = new Music();
				music.mstream=debug;
				music._debug=debug;
				music.stage=this.stage;
				//music.init({play:{src:"Mic"}});
				music.init({
					//play:{"url":"music/Entheogenic_PagenDreamMachine.mp3","loop":true},
					//play:{"url":"music/AnnaMudekaBand_ MudzimuDzoka.mp3","loop":true},
					play:{src:"Mic"},
					meta:{
						wave:{
							"enabled":true,
	    					"wave_gain":1,
	    					"peak_gain":1,
	    					"damping_gain":1,
	    					"damping_mul":0.4
	    					},
						beat:{enabled:false},timeline:{enabled:false},mixer:{enabled:false}}

					});
				sys.music=music;
				MM={};
				CompGlobals.NS.MM = MM;
				initMusicMaterials();
				
			}

			// SYS.IO.GAMEPAD ///////////////////////////////////////////////////////////////
			sys.io={gamepad:{enabled:false},touch:{enabled:true}}
			var oos=Capabilities.os.toLowerCase();
			var platform="Mac";
			if(oos.indexOf("windows")>=0) platform="Win";
			if(oos.indexOf("linux")>=0) platform="Linux";
			
			if(GameInput.isSupported){
				sys.io.gamepad.enabled=true;
				gamepad = new GamepadManager();
				gamepad._debug=debug;
				gamepad.platform=platform;
				gamepad.defGamepadType="XBOX";
				gamepad.init();
				sys.io.gamepad.manager=gamepad;
			}

			// SYS.SCREEN //////////////////////////////////////////////////////////////////
			//Screen & ppi & scaling *********************************************
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		
			dimX=stage.fullScreenWidth;
			dimY=stage.fullScreenHeight;
			ppi=Capabilities.screenDPI;
			
			if(desktop){
				ppi=130;
				if(fullscreen) stage.displayState=StageDisplayState.FULL_SCREEN;
				else{
					dimX=stage.stageWidth
					dimY=stage.stageHeight;
				}
			}
			screen={wDimX:dimX,wDimY:dimY,ppi:ppi,stage:stage};
			sys.screen=screen;

			// Events + Init ****************************************************
			addEventListener(Event.ENTER_FRAME,onEF,0,0,1);
			stage.addEventListener(Event.RESIZE,onResize,0,0,1);

			/*
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM,onZoom,0,0,1);
			stage.addEventListener(TransformGestureEvent.GESTURE_ROTATE,onRotate,0,0,1);
			*/

			//stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			//addEventListener(MouseEvent.MOUSE_DOWN,onMoCurrown,0,0,1);
			//stage.addEventListener(MouseEvent.MOUSE_UP,globalMouseUp,0,0,1);

			////////////////////////
			// LOAD CONT
			////////////////////////
			if(contFile=="") init2();
			else{
				context =new LoaderContext(false,ApplicationDomain.currentDomain);
				contLoader = new Loader();
				contLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,contLoader_COMPLETE,0,0,1);
				contLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,contLoader_PROGRESS,0,0,1);
				contLoader.load(new URLRequest(contFile),context);
			}
		}
		public function contLoader_PROGRESS(e){
			trace("Cont Progress");
		}
		public function contLoader_COMPLETE(e){
			trace("Cont Complete");
			init2();
		}
		public function init2(){
			//////////////////////////////////////////////////////////////////////////////
			// COMP FLIP FLOW ////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////

			compFlipFlow = new CompFlipFlow();
			compFlipFlow._debug=debug;
			compFlipFlow.ns={sys:sys,_sys:sys};
			compFlipFlow.params={};
			compFlipFlow.speed=speed;
			compFlipFlow.perform=perform;
			compFlipFlow.desktop=desktop;
			compFlipFlow.musicActive=musicActive;
			compFlipFlow.mapsName=mapsName;
			compFlipFlow.upscaling=2;
			compFlipFlow.init();
			addChild(compFlipFlow.vis);
			
			
			////////////////////////////////////////////////////////////////////////////////
			// UI //////////////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////////////
			
			maps=CompFlipFlowMaps["maps"+mapsName];

			dimXin=dimX/ppi;
			dimYin=dimY/ppi;
			dimDin=Math.sqrt(dimXin*dimXin+dimYin*dimYin);
	
			if(dimDin<6) smallSize=true;
		
			buttScale=ppi/300;
			if(dimDin>4) buttScale*=1+(dimDin-4)/7;
			
			
			var buttWidth=126*buttScale;
			var buttHeight=106*buttScale;
			var guiY=dimY;
			
			overlayShadeUnderButtons = new OverlayShade();
			overlayShadeUnderButtons.visible=false;
			addChild(overlayShadeUnderButtons);

			consoleVal = new ConsoleValue();
			consoleVal.visible=showDebug;
			addChild(consoleVal);

			buttPlus = new ButtCircPlus();
			buttPlus.visible=showUI;
			buttPlus.addEventListener(MouseEvent.CLICK,onButtPlus,0,0,1);
			addChild(buttPlus);

			buttMinus = new ButtCircMinus();
			buttMinus.visible=showUI;
			buttMinus.addEventListener(MouseEvent.CLICK,onButtMinus,0,0,1);
			addChild(buttMinus);

			buttFlip = new ButtTriFlip();
			buttFlip.visible=showUI;
			buttFlip.addEventListener(MouseEvent.CLICK,onButtFlip,0,0,1);
			addChild(buttFlip);

			buttNext = new ButtTriNext();
			buttNext.visible=showUI;
			buttNext.addEventListener(MouseEvent.CLICK,onButtNext,0,0,1);
			addChild(buttNext);

			buttPrev = new ButtTriPrev();
			buttPrev.visible=showUI;
			buttPrev.addEventListener(MouseEvent.CLICK,onButtPrev,0,0,1);
			addChild(buttPrev);

			
			buttMenu = new ButtCircMenu(); // ButtTriHelp();
			buttMenu.visible=showUI;
			buttMenu.addEventListener(MouseEvent.CLICK,openMenu,0,0,1);
			addChild(buttMenu);

			buttPhoto = new ButtCircScreenShot(); // ButtTriPhoto();
			buttPhoto.visible=showUI;
			buttPhoto.addEventListener(MouseEvent.CLICK,takeScreenShot,0,0,1);
			addChild(buttPhoto);			
			
			//Win Menu
			winMenu = new WinMenu();
			addChild(winMenu);
			winMenu.app=this;
			winMenu.onClose = this.closeMenu;
			winMenu.openLevel = compFlipFlow.setMap;
			winMenu.visible=false;
			winMenu.dimX=dimX;
			winMenu.dimY=dimY;
			winMenu.ppi=ppi;
			winMenu.maps=maps;
			winMenu.iconSize=smallSize?1/2:1/3;
			winMenu.overlayShadeUnderButtons=overlayShadeUnderButtons;
			winMenu.buttScale=buttScale;
			winMenu.init();
			running=true;
			onResize();
		}
	

		

		function toggleUpScaling(){
			compFlipFlow.toggleUpScaling();
		}

		function onButtPlus(e){
			compFlipFlow.onButtPlus();
		}
		function onButtMinus(e){
			compFlipFlow.onButtMinus();
		}

		function onButtFlip(e){
			compFlipFlow.onButtFlip();
		}
		 
		function onButtNext(e){compFlipFlow.onButtNext();}
		function onButtPrev(e){compFlipFlow.onButtPrev();}
		
		
		
		function toggleLayer0(e=null){compFlipFlow.toggleLayer0();}
		function toggleLayer1(e=null){compFlipFlow.toggleLayer1();}
		function toggleLayer2(e=null){compFlipFlow.toggleLayer2();}
		function toggleLayer3(e=null){compFlipFlow.toggleLayer3();}
		
		
		public function onEF(e=null){
			if(running){
				if(winMenu.visible) winMenu.onEF();
				if(sys.io.gamepad.enabled) gamepad.onEF();
				if(musicActive) updateMusicMaterials();
				compFlipFlow.onEF();
			}
		}
		public function onResize(e=null){
			if(running){
			dimX=stage.stageWidth;
			dimY=stage.stageHeight;
			sys.screen.wDimX=dimX;
			sys.screen.wDimY=dimY;
			var buttWidth=126*buttScale;
			var buttHeight=106*buttScale;

			overlayShadeUnderButtons.x=0;
			overlayShadeUnderButtons.y=0;
			overlayShadeUnderButtons.width=dimX;
			overlayShadeUnderButtons.height=dimY;
			consoleVal.x=dimX/2;
			consoleVal.y=dimY;
			consoleVal.scaleX=buttScale;
			consoleVal.scaleY=buttScale;
			buttPlus.x=buttWidth*1.1+60*buttScale;
			buttPlus.y=dimY-60*buttScale*ups;
			buttPlus.scaleX=buttScale;
			buttPlus.scaleY=buttScale;
			buttMinus.x=buttWidth*0.9-60*buttScale;
			buttMinus.y=dimY-60*buttScale*ups;
			buttMinus.scaleX=buttScale;
			buttMinus.scaleY=buttScale;
			buttFlip.x=buttWidth*1;
			buttFlip.y=dimY+2;
			buttFlip.scaleX=buttScale;
			buttFlip.scaleY=buttScale;
			buttNext.x=dimX-buttWidth*0.5;
			buttNext.y=-2;
			buttNext.scaleX=buttScale;
			buttNext.scaleY=-buttScale;
			buttPrev.x=dimX-buttWidth*1.5;
			buttPrev.y=-2;
			buttPrev.scaleX=buttScale;
			buttPrev.scaleY=-buttScale;
			buttMenu.x=10*buttScale*ups;
			buttMenu.y=10*buttScale*ups;
			buttMenu.scaleX=buttScale*ups;
			buttMenu.scaleY=buttScale*ups;
			buttPhoto.x=dimX-60*buttScale*ups;
			buttPhoto.y=dimY-60*buttScale*ups;
			buttPhoto.scaleX=buttScale*ups;
			buttPhoto.scaleY=buttScale*ups;
			winMenu.dimX=dimX;
			winMenu.dimY=dimY;
			winMenu.ppi=ppi;
			winMenu.maps=maps;
			winMenu.iconSize=smallSize?1/2:1/3;
			winMenu.overlayShadeUnderButtons=overlayShadeUnderButtons;
			winMenu.buttScale=buttScale;
			winMenu.onResize();
			compFlipFlow.onResize();
		}
		}
		
		
		
		
		/******************************************************************************************
		  APP GUI FUNCTIONS
		*****************************************************************************************/
		public function getScreenShot():BitmapData{
			var bmpScreenShot = new BitmapData(dimX,dimY);
			bmpScreenShot.drawWithQuality(compFlipFlow.visMirrors,null,null,null,null,true,StageQuality.BEST);
			return bmpScreenShot;
		}
		
		public function openMenu(e=null){
			if(compFlipFlow.playing){
				compFlipFlow.stopTitleAnimation();
				compFlipFlow.pause(true);
			
				winMenu.visible=true;
				winMenu.open();
				//overlayShade.visible=true;
			}
		}
		public function closeMenu(e=null){
			if(!compFlipFlow.playing){
				
				winMenu.visible=false;
				winMenu.close();

				compFlipFlow.pause(false);
			}
			//overlayShade.visible=false;
		}

		var bmpSS:Bitmap;
		var bmpDSS:BitmapData;
		public function takeScreenShot(e=null){
			if(compFlipFlow.playing){
				var win = new OverlayScreenshot();
				win.x=dimX/2;
				win.y=dimY/2;
				win.scaleX=buttScale;
				win.scaleY=buttScale;
				bmpDSS = getScreenShot();
				bmpSS = new Bitmap(bmpDSS);
				addChild(bmpSS);
				addChild(win);

				var cameraRoll:CameraRoll = new CameraRoll();
				cameraRoll.addBitmapData(bmpDSS);
				
			}
		}
		public function aniDone(){
			removeChild(bmpSS);
			bmpSS.bitmapData=null;
			bmpDSS.dispose();
		}
		public function openVJYWeb(e=null){
			navigateToURL(new URLRequest("http://www.vjyourself.com"), "_blank");
		}
		
		/**********************************************************
		  MUSIC META
		*****************************************************************/
		
		
		function initMusicMaterials(){
			var mm:MusicMaterial;

			//circ512
			mm = new MusicMaterial();
			mm.dim=512;
			mm.compDrawWave.waveData=music.meta.waveDataDamped;
			mm.init();
			MM["circ512"]=mm;

			//circ1024
			// mm = new MusicMaterial();
			// mm.dim=1024;
			// mm.compDrawWave.waveData=music.meta.waveDataDamped;
			// mm.init();
			// MM["circ1024"]=mm;
			
		}

		function updateMusicMaterials(){
			for(var i in MM) MM[i].onEF();
		}

		

		public function dispose(){
		}
	}
}