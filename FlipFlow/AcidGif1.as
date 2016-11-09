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
	import flash.system.Capabilities;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;

	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;

	import flash.filters.ColorMatrixFilter;
	import 	fl.motion.AdjustColor;
	import flash.media.CameraRoll;
	import flash.display.StageQuality;

	import flash.system.Capabilities;
	import vjyourself4.io.gamepad.GamepadManager;
	import vjyourself4.io.gamepad.GamepadState;
	import vjyourself4.sys.MetaStream;
	import flash.ui.GameInput;
	
	/**************************************************************************

		Layers -> [drawBmpD] -> Mirrors

	*****************************************************************************/
	public class AcidGif extends Sprite{
		
		public var dimX:Number=320;
		public var dimY:Number=480;
		public var ppi:Number=72;
		public var dimXin:Number=0;
		public var dimYin:Number=0;
		public var dimDin:Number=0;

		var visMap:Sprite;
		var visMirrors:Sprite;
		var drawBmpD:BitmapData;
		var drawBmpD2:BitmapData;

		var aniDimX:Number;
		var aniDimY:Number;

		var mapDimX:Number;
		var mapX:Number=0;
		var mapDimY:Number;
		var mapY:Number=0;

		var mirrNum:Number=3;
		var mirrNumX:Number=3;
		var mirrNumY:Number=3;
		var drawDimX:Number;
		var drawDimY:Number;
		var drawScale:Number=1; 
		var drawScale0:Number=1; // from ppi

		var drawTrans:Matrix = new Matrix();
		var mirrors:Array; 

		var touchX0:Number=0;
		var touchY0:Number=0;

		var debug:MetaStream;
		var man:GamepadManager;

		
		var bmp:Bitmap;
		var bmpD:BitmapData;
		var canvas:Sprite;
		
		var elems:Array;
		var touches:Array=[];
		
		var addCC:Number=0;
		var addDelay:Number=6;
		var moCurrown:Boolean=false;
		
		var currPatts:Array=[];
		
		var buttPlus;
		var buttMinus;
		var buttPrev;
		var buttNext;
		var buttHelp;
		var buttPhoto;
		var overlayShade:OverlayShade;
		var overlayIntro:OverlayIntro;
		
		var locked:Boolean=false;
		var lockMax:Number=100;

		
		var buttScale:Number=1;
		var activeY:Number;

		var mapSpeedX:Number=0;
		var mapSpeedY:Number=0;
		var touchActive:Boolean=false;
	
		var mapInd:Number=0;
		
		var maps:Array = AcidGifMaps.maps;
		var filterMeta:Object;
		var filterParams:Object;
		var filter:ColorMatrixFilter = new ColorMatrixFilter();
		var filterMatrix:AdjustColor = new AdjustColor();
		var filterHue:Number=0;
		var filterCC:Number=0;

		var mapM:Object;

		var layers:Array=[];
	
		var heartShapeAni:MovieClip;
		var heartShapeAniTrans:Matrix = new Matrix();
		var heartShapeAniCC:Number=0;

		
		// 0:move 1:speed 2:hybrid
		var moveMode:int=2;
		var avgSNum:int=4;

		var titleMC:MovieClip;

		var inputMode:String = "touch"; // touch or gamepad
		var maxSpeed:Number=20;

		var starsAdditive:Sprite;
		
		function AcidGif(){init();}
		public function log(txt){trace(txt);}
		

		/********************************************************************************************
		  INIT
		*****************************************************************************************/
		public function init(){
			debug = new MetaStream();
			debug.console={log:log};
			debug.init();

			var oos=Capabilities.os.toLowerCase();
			var platform="Mac";
			if(oos.indexOf("windows")>=0) platform="Win";
			if(oos.indexOf("linux")>=0) platform="Linux";
			
			if(GameInput.isSupported){
				man = new GamepadManager();
				man._debug=debug;
				man.platform=platform;
				man.defGamepadType="XBOX";
				man.init();
				man.events.addEventListener("CHANGE",onGamepadChange,0,0,1);
				man.events.addEventListener("Gamepad0_Up",onButtNext,0,0,1);
				man.events.addEventListener("Gamepad0_Down",onButtPrev,0,0,1);
				man.events.addEventListener("Gamepad0_Left",onButtPlus,0,0,1);
				man.events.addEventListener("Gamepad0_Right",onButtMinus,0,0,1);
				man.events.addEventListener("Gamepad0_RB",onVROrder,0,0,1);

			}
			//Screen & ppi & scaling *********************************************
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		
			dimX=stage.fullScreenWidth
			dimY=stage.fullScreenHeight;
			ppi=Capabilities.screenDPI;
			ppi=130;
			dimXin=dimX/ppi;
			dimYin=dimY/ppi;
			dimDin=Math.sqrt(dimXin*dimXin+dimYin*dimYin);

			mirrNum = 3;
			mirrNumX = 3;
			mirrNumY = 3;
			if(dimDin<6){
				mirrNum = 2;
				mirrNumX = 2;
				mirrNumY = 2;	
			}

			drawScale0=ppi/300;
			drawScale=drawScale0;
			buttScale=ppi/300;
			if(dimDin>4) buttScale*=1+(dimDin-4)/7;


			// Events + Init ****************************************************
			touches=[];
			addEventListener(Event.ENTER_FRAME,onEF,0,0,1);

			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
			//addEventListener(MouseEvent.MOUSE_DOWN,onMoCurrown,0,0,1);
			//stage.addEventListener(MouseEvent.MOUSE_UP,globalMouseUp,0,0,1);

			heartShapeAni = new HeartShapeAni();

			aniDimX=dimX;
			aniDimY=dimY;

			visMirrors= new Sprite();
			//visMirrors.filters=[filter];
			visMap=new Sprite();
			addChild(visMirrors);
			visMirrors.alpha=0;
			//mirrorsFadeIn(24*10);

			createMirrors();
			setMap(0);
			
			for(var i in layers){
				var ll=layers[i];
				ll.iX=0 //((i%2)*2-1)*16;
				ll.iY=-((i%2)*2-1)*16;
			}
			
			
			//trace("dimX:"+dimX+" dimY:"+dimY);
			
			//GUI
			
			
			var buttWidth=126*buttScale;
			var buttHeight=106*buttScale;
			var guiY=dimY;
			activeY=dimY-buttHeight*0.8;
			
			overlayShade = new OverlayShade();
			overlayShade.width=dimX;
			overlayShade.height=dimY;
			addChild(overlayShade);
			//swapChildren(gui,overlayShade);
			overlayShade.visible=false;
			
			buttPlus = new ButtTriPlus();
			buttPlus.x=buttWidth*0.5;
			buttPlus.y=dimY+2;
			buttPlus.scaleX=buttScale;
			buttPlus.scaleY=buttScale;
			buttPlus.addEventListener(MouseEvent.CLICK,onButtPlus,0,0,1);
			addChild(buttPlus);

			buttMinus = new ButtTriMinus();
			buttMinus.x=buttWidth*1.5;
			buttMinus.y=dimY+2;
			buttMinus.scaleX=buttScale;
			buttMinus.scaleY=buttScale;
			buttMinus.addEventListener(MouseEvent.CLICK,onButtMinus,0,0,1);
			addChild(buttMinus);

			buttNext = new ButtTriNext();
			buttNext.x=dimX-buttWidth*0.5;
			buttNext.y=-2;
			buttNext.scaleX=buttScale;
			buttNext.scaleY=-buttScale;
			buttNext.addEventListener(MouseEvent.CLICK,onButtNext,0,0,1);
			addChild(buttNext);

			buttPrev = new ButtTriPrev();
			buttPrev.x=dimX-buttWidth*1.5;
			buttPrev.y=-2;
			buttPrev.scaleX=buttScale;
			buttPrev.scaleY=-buttScale;
			buttPrev.addEventListener(MouseEvent.CLICK,onButtPrev,0,0,1);
			addChild(buttPrev);

			buttHelp = new ButtTriHelp();
			buttHelp.x=0;
			buttHelp.y=0;
			buttHelp.scaleX=buttScale;
			buttHelp.scaleY=buttScale;
			buttHelp.addEventListener(MouseEvent.CLICK,openIntro,0,0,1);
			addChild(buttHelp);

			buttPhoto = new ButtTriPhoto();
			buttPhoto.x=dimX;
			buttPhoto.y=dimY;
			buttPhoto.scaleX=buttScale;
			buttPhoto.scaleY=buttScale;
			buttPhoto.addEventListener(MouseEvent.CLICK,takeScreenShot,0,0,1);
			addChild(buttPhoto);			
			
			overlayIntro = new OverlayIntro();
			addChild(overlayIntro);
			overlayIntro.visible=false;
			overlayShade.addEventListener(MouseEvent.CLICK,closeIntro,0,0,1);
			overlayIntro.addEventListener(MouseEvent.CLICK,closeIntro,0,0,1);
			var osc=dimY/640;
			overlayIntro["mid"].buttLink.addEventListener(MouseEvent.CLICK,openVJYWeb,0,0,1);
			overlayIntro["mid"].x=dimX/2;
			overlayIntro["mid"].y=dimY/2;
			overlayIntro["mid"].scaleX=osc;
			overlayIntro["mid"].scaleY=osc;
			overlayIntro["maps"].x=dimX-buttWidth*2;
			overlayIntro["maps"].y=50*osc;
			overlayIntro["maps"].scaleX=osc;
			overlayIntro["maps"].scaleY=osc;
			overlayIntro["mirrors"].x=buttWidth*2;
			overlayIntro["mirrors"].y=dimY-50*osc;
			overlayIntro["mirrors"].scaleX=osc;
			overlayIntro["mirrors"].scaleY=osc;
			overlayIntro["screenshot"].x=dimX-buttWidth*0.5;
			overlayIntro["screenshot"].y=dimY-50*osc;
			overlayIntro["screenshot"].scaleX=osc;
			overlayIntro["screenshot"].scaleY=osc;
			
			starsAdditive = new StarsAdditive();
		}
		var playing:Boolean=true;
		public function pause(v:Boolean){playing=!v;}

		public function dispose(){
			//removeEventListener(MouseEvent.MOUSE_DOWN,onMoCurrown);
		}

		
		/*******************************************************************************************
		  MIRRORS
		********************************************************************************************/
		var mirrFade_filterCC:Number=0;
		var mirrFade_dd:Number=0;
		var mirrFade_act:Boolean=false;
		function mirrorsFadeIn(dd){
			mirrFade_filterCC=0;
			mirrFade_dd=dd;
			mirrFade_act=true;
		}
		function onButtPlus(e){
		if(playing){
			if(mirrNum<12){
				mirrNum++;
				mirrNumX=mirrNum;
				mirrNumY=mirrNum;
				createMirrors()
			}
		}
		}
		function onButtMinus(e){
			if(playing){
			if(mirrNum>2){
				mirrNum--;
				mirrNumX=mirrNum;
				mirrNumY=mirrNum;
				createMirrors()
			}
		}}
	
		function createMirrors(){
			for(var i in mirrors){
				visMirrors.removeChild(mirrors[i]);
				mirrors[i]=null;
			}
			mirrors=[];
			drawDimX=Math.ceil(aniDimX/mirrNumX);
			drawDimY=Math.ceil(aniDimY/mirrNumY);

			if(drawBmpD!=null) drawBmpD.dispose();
			drawBmpD=new BitmapData(drawDimX,drawDimY,false,0x000000);
			if(vrActive){
				drawBmpD2=new BitmapData(drawDimX,drawDimY,false,0x000000);
				if(drawBmpD2!=null) drawBmpD2.dispose();
			}
			for(var x=0;x<mirrNumX;x++) for(var y=0;y<mirrNumY;y++){
				if(vrActive) var bmp = new Bitmap(((x==1)||(x==2))?drawBmpD:drawBmpD2);
				else var bmp = new Bitmap(drawBmpD);
				bmp.x=(x+x%2)*drawDimX;
				bmp.y=(y+y%2)*drawDimY;
				bmp.scaleX=x%2*-2+1;
				bmp.scaleY=y%2*-2+1;
				visMirrors.addChild(bmp);
				mirrors.push(bmp);
			}

			heartShapeAni.gotoAndPlay(1);
			heartShapeAniCC=0;
			heartShapeAniTrans.identity();
			heartShapeAniTrans.scale(drawDimX/276*0.66,drawDimY/255*0.66);
			heartShapeAniTrans.translate(drawDimX/2,drawDimY/2);
			updateMapDim();
		}

		/******************************************************************************************
		  MOVE CONTROLS
		******************************************************************************************/
		public function onGamepadChange(e){
			inputMode="gamepad";
		}
		
		function onTouchBegin(ev:TouchEvent){
			inputMode="touch";
			var e={x:ev.stageX,y:ev.stageY,touchPointID:ev.touchPointID};
			if(touches.length>1) e.type="none";
			else {
				e.type="layer";
				var ind=0;
				for(var i=0;i<layers.length;i++){
					var used=false;
					for(var ii=0;ii<touches.length;ii++) if(touches[ii].type=="layer") if(touches[ii].layerInd==i) used=true;
					if(!used) ind=i;
				}
				e.layerInd=ind;
			}
			touches.push(e);
		}
		function onTouchMove(e:TouchEvent){
			inputMode="touch";
			var ind=-1;
			for(var i=0;i<touches.length;i++) if(touches[i].touchPointID==e.touchPointID) ind=i;
			if(i>=0){
				var tt=touches[ind];
				//trace("TOUCH ",touches.length," ",ind);
				if(tt.type=="layer"){
					var dX=e.stageX-tt.x;
					var dY=e.stageY-tt.y;
					
					if(touches.length==1){
						setLayerSpeed(0,dX,dY);
						setLayerSpeed(1,-dX,-dY);
						setLayerControl(0,true);
						setLayerControl(1,true);
					}else{
						var polar:Number=(tt.layerInd%2)?1:-1;
						polar=1;
						setLayerSpeed(tt.layerInd,dX*polar,dY*polar);
						setLayerControl(tt.layerInd,true);
					}
					tt.x=e.stageX;
					tt.y=e.stageY;
				}
			}
		}
		function onTouchEnd(e:TouchEvent){
			var ind=-1;
			for(var i=0;i<touches.length;i++) if(touches[i].touchPointID==e.touchPointID) ind=i;
			//trace("END",ind);
			if(ind>=0){
				if(touches.length==1){
					setLayerControl(0,false);
					setLayerControl(1,false);		
				}else{
					if(touches[ind].layerInd!=null) setLayerControl(touches[ind].layerInd,false);
					
				}
				touches.splice(ind,1);
			}
		}

		function setLayerControl(ind,b){
			var ll=layers[ind];
			if(ll!=null){
				ll.controlled=b;
				if(!b){
					ll.iX=ll.avgSX;
					ll.iY=ll.avgSY;
				}
			}
		}
		function shiftLayer(ind,x,y){
			//trace(x,y);
			var l=layers[ind];
			l.obj.shift(x,y);
			l.avgSInd=(l.avgSind+1)%avgSNum;
			l.avgSXArray[l.avgSind]=x;
			l.avgSYArray[l.avgSind]=y;
			var v:Number=0;
			for(var i=0;i<avgSNum;i++) v+=l.avgSXArray[i];
			l.avgSX=v/avgSNum;
			v=0;
			for(var i=0;i<avgSNum;i++) v+=l.avgSYArray[i];
			l.avgSY=v/avgSNum;

		}

		function setLayerSpeed(ind,x,y){
			//trace(x,y);
			var l=layers[ind];
			l.sX+=x;
			l.sY+=y;
		}

		/**************************************************************************************
		 CREATE MAP
		 *************************************************************************************/
		 
		function onButtNext(e){if(playing)setMap((mapInd+1)%maps.length);}
		function onButtPrev(e){if(playing)setMap((mapInd-1+maps.length)%maps.length);}
		
		
		 function setMap(ind){
			mapInd=ind;
			mapM = maps[mapInd];
			drawScale=drawScale0;
			
			//clear back
			if(mapM.clearAtStart){
				drawBmpD.fillRect(drawBmpD.rect,0x000000);
				if(vrActive) drawBmpD2.fillRect(drawBmpD.rect,0x000000);
			}
			//Set Up Filter
			filterMeta = mapM.filter;
			switch(filterMeta.type){
				case "none": break;
				case "ColorAdjust":
					filterParams=filterMeta.params;
					filterMatrix=new AdjustColor();
					filterMatrix.brightness=filterParams.brightness;
					filterMatrix.contrast=filterParams.contrast;
					filterHue=filterParams.hue;
					filterMatrix.hue=filterHue;
					filterMatrix.saturation=filterParams.saturation;
					filter.matrix=filterMatrix.CalculateFinalFlatArray();
				break;
				case "ColorTransform":
					filterParams=filterMeta.params;
					filter.matrix=[
						filterParams.redMultiplier,0,0,0,filterParams.redOffset,
						0,filterParams.greenMultiplier,0,0,filterParams.greenOffset,
						0,0,filterParams.blueMultiplier,0,filterParams.blueOffset,
						0,0,0,1,0
					];
				break;

			}

			if(titleMC!=null){
				removeChild(titleMC);
				titleMC=null;
			}

			var c:Class = getDefinitionByName(mapM.titleMC) as Class;
			titleMC = new c();
			addChild(titleMC);
			titleMC.x=dimX/2;
			titleMC.y=dimY/2;
			titleMC.scaleX=dimY/768;
			titleMC.scaleY=dimY/768;
			
			//despose previous layers;
			var l:Object;
			while(layers.length>0){
				l=layers.pop();
				l.obj.dispose();
				visMap.removeChild(l.obj.vis);
				l.obj=null;
			}

			//create new ones
			var lM:Object;
			for(var i=0;i<mapM.layers.length;i++){
				lM=mapM.layers[i];
				l={mul:lM.mul,sX:0,sY:0,controlled:false,iX:0,iY:0,avgSX:0,avgSY:0,avgSYArray:[],avgSXArray:[],avgSind:0};
				for(var ii=0;ii<avgSNum;ii++){
					l.avgSYArray.push(0);
					l.avgSXArray.push(0);
				}
				l.obj = new LayerShift();
				l.obj.adjustScale=drawScale;
				l.obj.dimX=drawDimX;
				l.obj.dimY=drawDimY;
				l.obj.params=lM;
				l.obj.init();
				visMap.addChild(l.obj.vis);
				layers.push(l);
			}
			mirrorsFadeIn(24*3);

			
		}

		function updateMapDim(){
			var l:Object;
			for(var i=0;i<layers.length;i++){
				l=layers[i];
				l.obj.dimX=drawDimX;
				l.obj.dimY=drawDimY;
				l.obj.shift(0,0);
			}
		}

		/**************************************************************************************
		 ON EF + DRAW MAP
		**************************************************************************************/

		public function onEF(e=null){
			if(GameInput.isSupported) man.onEF();
			if(playing){
				if(inputMode=="gamepad"){	
					var s0=man.getState(0);
					//setLayerSpeed(0,s0.LeftStick.x*maxSpeed,s0.LeftStick.y*maxSpeed);
					setLayerSpeed(0,-s0.RightStick.x*maxSpeed,-s0.RightStick.y*maxSpeed);
					setLayerSpeed(1,s0.RightStick.x*maxSpeed,s0.RightStick.y*maxSpeed);
					vrShift=vrShift0+s0.LeftTrigger*10-s0.RightTrigger*10;
				}
				if(mirrFade_act){
				mirrFade_filterCC++;
				if(mirrFade_filterCC>=mirrFade_dd){
					mirrFade_act=false;
					visMirrors.alpha=1;
					if(titleMC!=null){
						removeChild(titleMC);
						titleMC=null;
					}
				}else{
					var perc=mirrFade_filterCC/mirrFade_dd;
					if(perc<0.3){
						visMirrors.alpha=0;
						titleMC.alpha=1;
					}else{
						visMirrors.alpha=(perc-0.3)/(1-0.3);
						titleMC.alpha=1-(perc-0.3)/(1-0.3);
					}
				}
			}
			

			for(var i=0;i<layers.length;i++){
				var ll=layers[i];
				switch(moveMode){
					case 0:
					shiftLayer(i,ll.sX,ll.sY);
					ll.sX=0;
					ll.sY=0;
					break;
					case 1:
					ll.sX*=0.95;
					ll.sY*=0.95;
					shiftLayer(i,ll.sX/8,ll.sY/8);
					break;
					case 2:
					
					if(ll.controlled){
						ll.iX*=0.95;
						ll.iY*=0.95;
					}else{
						ll.iX*=0.97;
						ll.iY*=0.97;
					}
					shiftLayer(i,ll.sX+ll.iX,ll.sY+ll.iY);
					ll.sX=0;
					ll.sY=0;
					break;
				}
			}
			//trace(layers[0].avgSX,layers[0].avgSY);
			drawMap();

			if(heartShapeAniCC<40){
				heartShapeAniCC++;
				drawBmpD.draw(heartShapeAni,heartShapeAniTrans);
			}
			}
		}
		
		// VR distro
		var vrShift0=20;
		var vrShift=vrShift0;
		var vrOrder=true;
		var vrActive=false;
		public function onVROrder(e){vrOrder=!vrOrder;}
		
		// DRAW MAP ----------------------------------------------------------------------------------
		function drawMap(){
			drawBmpD.draw(starsAdditive);
			//Filter
			if(filterMeta.type!="none"){
				
				//if there is changing filter param, recalculate ...
				if(filterMeta.type=="ColorAdjust"){
					if(filterParams.hue_inc!=0){
						filterHue=(filterHue+filterParams.hue_inc)%360;
						filterMatrix.hue=filterHue;
						filter.matrix=filterMatrix.CalculateFinalFlatArray();
					}
				}
				
				//apply filter after delay
				filterCC++
				if(filterCC>=filterMeta.delay){
					filterCC=0;
					drawBmpD.applyFilter(drawBmpD,drawBmpD.rect,new Point(0,0),filter);
					if(vrActive) drawBmpD2.applyFilter(drawBmpD2,drawBmpD2.rect,new Point(0,0),filter);
				}
			}
			
			drawBmpD.draw(visMap);
			
			if(vrActive){
				//shift layers
				for(var i=0;i<layers.length;i++){
					layers[i].obj.vis.x+=vrShift*(vrOrder?(i+1):(2-i));
				}
				//draw 2. bitmap
				drawBmpD2.draw(visMap);
				//shift layers back
				for(var i=0;i<layers.length;i++){
					layers[i].obj.vis.x-=vrShift*(vrOrder?(i+1):(2-i));
				}
			}

			if(mapM.glitchEffect){
				var y=Math.floor(Math.random()*drawBmpD.height);
				var x=Math.floor(Math.random()*10);
				drawBmpD.copyPixels(drawBmpD,new Rectangle(0,y,drawBmpD.width,1),new Point(x,y));
				if(vrActive) drawBmpD2.copyPixels(drawBmpD2,new Rectangle(0,y,drawBmpD2.width,1),new Point(x,y));
			}
		}

		
		/******************************************************************************************
		  APP GUI FUNCTIONS
		*****************************************************************************************/
		public function getScreenShot():BitmapData{
			var bmpScreenShot = new BitmapData(dimX,dimY);
			bmpScreenShot.drawWithQuality(visMirrors,null,null,null,null,true,StageQuality.BEST);
			return bmpScreenShot;
		}

		public function openIntro(e){
			if(playing){
			pause(true);
			overlayIntro.visible=true;
			overlayShade.visible=true;
		}
		}
		public function closeIntro(e){
			pause(false);
			overlayIntro.visible=false;
			overlayShade.visible=false;
		}
		public function takeScreenShot(e=null){
			if(playing){
			var win = new OverlayScreenshot();
			win.x=dimX/2;
			win.y=dimY/2;
			addChild(win);
			var cameraRoll:CameraRoll = new CameraRoll();
			var bmpD:BitmapData=getScreenShot();
			cameraRoll.addBitmapData(bmpD);
			bmpD.dispose();
		}}
		
		public function openVJYWeb(e=null){
			navigateToURL(new URLRequest("http://www.vjyourself.com"), "_blank");
		}
		
		
		
	}
}