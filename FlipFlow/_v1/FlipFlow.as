package vjyourself4.comp{
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
	import vjyourself4.patt.WaveFollow;
	
	/**************************************************************************

		Map.layers -> [drawBmpD] -> Mirrors

		visMirrors [BMP][BMP][BMP]
		titleHolder [TitleMC]
		[UI Buttons]
		[Menu]

	*****************************************************************************/
	public class CompFlipFlow{
		public var _debug:Object;
		public var _meta:Object={name:"CompFlipFlow"};
		public function setDLevels(l1,l2,l3,l4){dLevels=[l1,l2,l3,l4];}
		var dLevels:Array=[true,false,false,false];
		function log(level,msg){if(dLevels[level-1])_debug.log(this,level,msg);}

		public var ns:Object;
		public var params:Object;
		public var vis:Sprite;

		var maps:Array = FlipFlowMaps.mapsAfro;
		
		public var speed:Number=0.5;
		public var perform:Boolean=true;
		

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

		//DRAW SCALE
		var drawScale000:Number=1; // Initial calculated from device ppi 
		var drawScale0:Number=1; // adjusted by 'map'.drawScale or 'map'.drawScaleMobile
		var drawScaleMod:Number=0; // manual Zoom value : 0 - no zoom
		var drawScale:Number=1; // Final scale : drawScale0 + Manual Zoom
		
		var drawAlpha:Number=1;

		var drawTrans:Matrix = new Matrix();
		var mirrors:Array; 

		var debug:MetaStream;
		var man:GamepadManager;

		
		var bmp:Bitmap;
		var bmpD:BitmapData;
		var canvas:Sprite;
		var upscaling:Number=1;
	
		var elems:Array;
		var touches:Array=[];
		
		var addCC:Number=0;
		var addDelay:Number=6;
		var moCurrown:Boolean=false;
		
		var currPatts:Array=[];
		
		
		var locked:Boolean=false;
		var lockMax:Number=100;

		
		var buttScale:Number=1;
		var activeY:Number;

		var mapSpeedX:Number=0;
		var mapSpeedY:Number=0;
		var touchActive:Boolean=false;
	
		var mapInd:Number=0;
		
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

		
		var maxSpeed:Number=20;

		var baseMapSprite:Sprite;
		var baseMap:Object;
		var winMenu:WinMenu;
		var smallSize:Boolean=false;
		var titleHolder:Sprite;

		var rotSpeed:WaveFollow = new WaveFollow({treshold:0,div:12});
		var zoomSpeed:WaveFollow = new WaveFollow({treshold:0,div:12});
		var xSpeed:WaveFollow = new WaveFollow({treshold:0,div:12});
		var ySpeed:WaveFollow = new WaveFollow({treshold:0,div:12});

		function FlipFlow(){init();}
		public function log(txt){trace(txt);}
		

		/********************************************************************************************
		  INIT
		*****************************************************************************************/
		public function init(){
			
			if(GameInput.isSupported){
				man = new GamepadManager();
				man._debug=debug;
				man.platform=platform;
				man.defGamepadType="XBOX";
				man.init();
				//man.events.addEventListener("CHANGE",onGamepadChange,0,0,1);
				man.events.addEventListener("Gamepad0_Up",onButtNext,0,0,1);
				man.events.addEventListener("Gamepad0_Down",onButtPrev,0,0,1);
				man.events.addEventListener("Gamepad0_Right",onButtPlus,0,0,1);
				man.events.addEventListener("Gamepad0_Left",onButtMinus,0,0,1);
				man.events.addEventListener("Gamepad0_LB",onButtFlip,0,0,1);
				man.events.addEventListener("Gamepad0_RB",clearBack,0,0,1);
				man.events.addEventListener("Gamepad0_A",toggleLayer0,0,0,1);
				man.events.addEventListener("Gamepad0_B",toggleLayer1,0,0,1);
				man.events.addEventListener("Gamepad0_X",toggleLayer2,0,0,1);
				man.events.addEventListener("Gamepad0_Y",toggleLayer3,0,0,1);


				//man.events.addEventListener("Gamepad0_RB",onVROrder,0,0,1);

			}
	
		
			dimX=stage.fullScreenWidth
			dimY=stage.fullScreenHeight;
			ppi=Capabilities.screenDPI;
			if(desktop){
				ppi=130;
				stage.displayState=StageDisplayState.FULL_SCREEN;
				//dimX=stage.stageWidth
				//dimY=stage.stageHeight;
			}
			dimXin=dimX/ppi;
			dimYin=dimY/ppi;
			dimDin=Math.sqrt(dimXin*dimXin+dimYin*dimYin);

			mirrNum = 2;
			
			if(dimDin<6){
				smallSize=true;
				mirrNum = 2;
			}
			mirrNumX = mirrNum;
			mirrNumY = mirrNum;

			drawScale000=ppi/300*0.75;
			drawScale=drawScale000;
			buttScale=ppi/300;
			if(dimDin>4) buttScale*=1+(dimDin-4)/7;


			// Events + Init ****************************************************
			touches=[];
			addEventListener(Event.ENTER_FRAME,onEF,0,0,1);

			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM,onZoom,0,0,1);
			stage.addEventListener(TransformGestureEvent.GESTURE_ROTATE,onRotate,0,0,1);
			

			//stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			//addEventListener(MouseEvent.MOUSE_DOWN,onMoCurrown,0,0,1);
			//stage.addEventListener(MouseEvent.MOUSE_UP,globalMouseUp,0,0,1);

			heartShapeAni = new HeartShapeAni();
			//heartShapeAni = new AniFlip(); //new HeartShapeAni();


			aniDimX=dimX;
			aniDimY=dimY;

			visMirrors= new Sprite();
			//visMirrors.filters=[filter];
			visMap=new Sprite();
			addChild(visMirrors);
			//mirrorsFadeIn(24*10);
			createMirrors();

			titleHolder = new Sprite();
			addChild(titleHolder);

			setMap(0);
			heartShapeAniCC=50;
			/*
			for(var i in layers){
				var ll=layers[i];
				ll.sX=0 //((i%2)*2-1)*16;
				ll.sY=((i%2)*2-1)*16;
			}*/


			
			
			//trace("dimX:"+dimX+" dimY:"+dimY);
			
			//GUI
			
			
			
			
		}
		var playing:Boolean=true;
		public function pause(v:Boolean){playing=!v;}

		public function dispose(){
			//removeEventListener(MouseEvent.MOUSE_DOWN,onMoCurrown);
		}

		
		/*******************************************************************************************
		  MIRRORS
		********************************************************************************************/
		public function toggleUpScaling(){
			if(upscaling==2) upscaling=8;
			else upscaling =2;
			createMirrors();
		}

		function onButtPlus(e){
		if(playing){
			switch(flipMode){
				case "Grid":
				if(mirrNum<12){
					mirrNum+=2;
					mirrNumX=mirrNum;
					mirrNumY=mirrNum;
					createMirrors();
				}
				break;
				case "Radial":
				if(radialNum==6){
					radialNum=12;
					createMirrors();
				}
				break;
			}
		}
		}
		function onButtMinus(e){
			if(playing){
			switch(flipMode){
				case "Grid":
				if(mirrNum>2){
					mirrNum-=2;
					mirrNumX=mirrNum;
					mirrNumY=mirrNum;
					createMirrors();
				}
				break;
				case "Radial":
				if(radialNum==12){
					radialNum=6;
					createMirrors();
				}
				break;
			}
		}}

		function onButtFlip(e){
		if(playing){
			flipModesInd=(flipModesInd+1)%flipModes.length;
			flipMode=flipModes[flipModesInd];
			createMirrors();
		}
		}
	
		var flipModes:Array = ["Grid","Radial"];
		var flipModesInd:Number=0;
		var flipMode:String= "Grid";
		var radialNum:Number = 12;
		var radialElemAngle:Number=0;
		var radialR:Number = 0;

		function createMirrors(){
			for(var i in mirrors){
				switch(mirrors[i].type){
					case "Grid":
						visMirrors.removeChild(mirrors[i].bmp);mirrors[i].bmp=null;
					break;
					case "Radial":
					
						mirrors[i].sp.removeChild(mirrors[i].bmp);mirrors[i].bmp=null;
						mirrors[i].sp.removeChild(mirrors[i].m);mirrors[i].m=null;
						visMirrors.removeChild(mirrors[i].sp);mirrors[i].sp=null;
					break;
				}
				
				mirrors[i]=null;
			}
			if(drawBmpD!=null) drawBmpD.dispose();
			if(!perform){
				heartShapeAni.gotoAndPlay(1);
				heartShapeAniCC=0;
				heartShapeAniTrans.identity();
			}
			mirrors=[];
			switch(flipMode){
				//GRID
				case "Grid":
				drawDimX=Math.ceil(aniDimX/mirrNumX);
				drawDimY=Math.ceil(aniDimY/mirrNumY);
				drawBmpD=new BitmapData(Math.ceil(drawDimX/upscaling),Math.ceil(drawDimY/upscaling),false,0x000000);
				if(vrActive){
					drawBmpD2=new BitmapData(drawDimX,drawDimY,false,0x000000);
					if(drawBmpD2!=null) drawBmpD2.dispose();
				}

				for(var x=0;x<mirrNumX;x++) for(var y=0;y<mirrNumY;y++){
					if(vrActive) var bmp = new Bitmap(((x==1)||(x==2))?drawBmpD:drawBmpD2);
					else var bmp = new Bitmap(drawBmpD);
					bmp.x=(x+x%2)*drawDimX;
					bmp.y=(y+y%2)*drawDimY;
					bmp.scaleX=(x%2*-2+1)*upscaling;
					bmp.scaleY=(y%2*-2+1)*upscaling;
					visMirrors.addChild(bmp);
					mirrors.push({bmp:bmp,type:"Grid"});
				}
				heartShapeAniTrans.scale(drawBmpD.height/255*0.66,drawBmpD.height/255*0.66);
				heartShapeAniTrans.translate(drawBmpD.width/2,drawBmpD.height/2);
			
				break;

				case "Radial":
				radialR = Math.sqrt(aniDimX*aniDimX+aniDimY*aniDimY)/2;
				radialElemAngle = 360/radialNum;

				drawDimX=radialR;
				drawDimY=Math.sin(radialElemAngle/180*Math.PI)*radialR*2;
				drawBmpD=new BitmapData(Math.ceil(drawDimX/upscaling),Math.ceil(drawDimY/upscaling),false,0x000000);
				for(var x=0;x<radialNum;x++){
					var bmp = new Bitmap(drawBmpD);
					var sp = new Sprite();
					var m:Sprite;
					switch(radialNum){
						case 6:m= new MaskRadial6();break;
						case 12:m= new MaskRadial12();break;
					}
					
					bmp.x=0;
					bmp.y=-(x%2*-2+1)*drawDimY/2;
					bmp.scaleX=upscaling;
					bmp.scaleY=(x%2*-2+1)*upscaling;
					sp.addChild(bmp);

					m.scaleX=drawDimX/100;
					m.scaleY=drawDimX/100;
					sp.addChild(m);
					bmp.mask=m;

					sp.rotation=360/radialNum*x;
					sp.x=aniDimX/2;
					sp.y=aniDimY/2;
					
					visMirrors.addChild(sp);
					mirrors.push({bmp:bmp,sp:sp,m:m,type:"Radial"});
				}
				heartShapeAniTrans.scale(drawBmpD.height/255*0.25,drawBmpD.height/255*0.25);
				heartShapeAniTrans.rotate(Math.PI/2);
				heartShapeAniTrans.translate(drawBmpD.width*0.5,drawBmpD.height/2);
			
				break;
			}

			mouseDown=true;
			
			//heartShapeAniTrans.scale(drawBmpD.width/100,drawBmpD.height/100);
			//heartShapeAniTrans.translate(0,0);
			
			updateMapDim();
		}

		/******************************************************************************************
		  MOVE CONTROLS
		******************************************************************************************/
		var inputMode:String = ""; // touch or gamepad

		var gamepadSX=0;
		var gamepadSY=0;
		
		var touchSX=0;
		var touchSY=0;
		var touchX0=0;
		var touchY0=0;
		
		var mouseDown:Boolean=false;
		function onMouseDown(e){
			inputMode="touch";
			mouseDown=true;
			touchX0=stage.mouseX;
			touchY0=stage.mouseY;
		}
		
		function onMouseUp(e){
			inputMode="";
			mouseDown=false;
			touchSX=0;
			touchSY=0;
		}

		var gestureHappend=false;
		function onZoom(e:TransformGestureEvent){
			trace(e.scaleX);
			drawScaleMod+=(e.scaleX-1)/2;
			//drawScaleMod*=e.scaleX;
			gestureHappend=true;
		}
		
		function onRotate(e:TransformGestureEvent){
			mapRot=(mapRot+e.rotation)%360;
			gestureHappend=true;
		}
/*
		function shiftLayer(ind,x,y){
			//trace(x,y);
			var l=layers[ind];
			l.obj.shift(x,y);
			l.avgSInd=(l.avgSind+1)%avgSNum;
			l.avgSXArray[l.avgSind]=x;
			l.avgSYArray[l.avgSind]=y;
			var v:Number=0;
			for(var i=0;i<avgS
				mouseDown=false;Num;i++) v+=l.avgSXArray[i];
			l.avgSX=v/avgSNum;
			v=0;
			for(var i=0;i<avgSNum;i++) v+=l.avgSYArray[i];
			l.avgSY=v/avgSNum;

		}
*/

		/**************************************************************************************
		 CREATE MAP
		 *************************************************************************************/
		 
		function onButtNext(e){if(playing)setMap((mapInd+1)%maps.length);}
		function onButtPrev(e){if(playing)setMap((mapInd-1+maps.length)%maps.length);}
		
		
		 function setMap(ind){
		 	closeMenu();
			mapInd=ind;
			mapM = maps[mapInd];
			if(mapM.buildOrder==null) mapM.buildOrder=[0,1,2,3,4,5,6,7,8,9];
			if(!perform){
				drawScaleMod=0;
				drawScale0=drawScale000*(smallSize?mapM.drawScaleMobile:mapM.drawScale);
				drawScale=drawScale0;
				mapRot=0;
			}

			baseMap=mapM.baseMap;
			if(baseMap.enabled){
				var c:Class = getDefinitionByName(baseMap.cn) as Class;
				baseMapSprite = new c();
			}
			//clear back
			if((mapM.clearAtStart)&&(!perform)){
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
			
			//despose previous layers;
			var l:Object;
			while(layers.length>0){
				l=layers.pop();
				l.obj.dispose();
				visMap.removeChild(l.obj.vis);
				l.obj=null;
				l.m=null;
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
				l.m=mapM.layers[i];
				l.obj = new LayerShift();
				l.obj.layerScale=drawScale;
				l.obj.dimX=drawDimX;
				l.obj.dimY=drawDimY;
				l.obj.params=lM;
				l.obj.init();
				visMap.addChild(l.obj.vis);
				layers.push(l);
			}

			if(!perform) startTitleAnimation(mapM.titleMC);
			else startFadeAnimation();

			
		}

		function toggleLayer0(e=null){if(layers.length>0) layers[0].obj.vis.visible=!layers[0].obj.vis.visible;}
		function toggleLayer1(e=null){if(layers.length>1) layers[1].obj.vis.visible=!layers[1].obj.vis.visible;}
		function toggleLayer2(e=null){if(layers.length>2) layers[2].obj.vis.visible=!layers[2].obj.vis.visible;}
		function toggleLayer3(e=null){if(layers.length>3) layers[3].obj.vis.visible=!layers[3].obj.vis.visible;}
		
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
		public var mapRot=0;

		public function onEF(e=null){
			//consoleVal.tfVal.text=Math.round(drawScale000*100)/100+" : "+Math.round(drawScale0*100)/100+" : "+Math.round(drawScale*100)/100;
			var ss=Math.round(music.meta.pos/1000);
			var mm=Math.floor(ss/60);ss-=mm*60;
			consoleVal.tfVal.text=mm+" : "+ss;
			if(winMenu.visible) winMenu.onEF();

			if(GameInput.isSupported) man.onEF();
			if(playing){
				if(GameInput.isSupported){
					var s0=man.getState(0);
					var activeGamepad=(s0.RightStick.x!=0)||(s0.RightStick.y!=0)||(s0.LeftStick.x!=0)||(s0.LeftStick.y!=0)||(s0.RightTrigger!=0)||(s0.LeftTrigger!=0);
					if(!activeGamepad &&  inputMode=="gamepad") inputMode="";
					if(activeGamepad) inputMode="gamepad";
						
				
					if(inputMode=="gamepad"){	
					
						xSpeed.setVal(-s0.LeftStick.x*maxSpeed*speed);
						ySpeed.setVal(s0.LeftStick.y*maxSpeed*speed);
						
						//vrShift=vrShift0+s0.LeftTrigger*10-s0.RightTrigger*10;

						zoomSpeed.setVal(s0.RightStick.y/30*speed);
						//drawScaleMod+=s0.LeftStick.y/30;
						rotSpeed.setVal(s0.RightStick.x*2*speed);
						

						if((s0.LeftTrigger>0)||(s0.RightTrigger>0)){
							setDrawAlpha(drawAlpha-s0.RightTrigger/100+s0.LeftTrigger/100)
						}
					}else{
						rotSpeed.setVal(0);
						xSpeed.setVal(0);
						ySpeed.setVal(0);
						zoomSpeed.setVal(0);
					}
					rotSpeed.onEF();
					xSpeed.onEF();
					ySpeed.onEF();
					zoomSpeed.onEF();
					drawScaleMod+=zoomSpeed.val;
					mapRot=(mapRot+rotSpeed.val)%360;
					gamepadSX=xSpeed.val;
					gamepadSY=ySpeed.val;
						
				}
				if(inputMode=="touch"){
					touchSX=stage.mouseX-touchX0;
					touchSY=stage.mouseY-touchY0;
					touchX0=stage.mouseX;
					touchY0=stage.mouseY;
				}

				//Calculate Draw Scale
				if(drawScaleMod<-(drawScale0/3*2)) drawScaleMod=-(drawScale0/3*2);
				if(drawScaleMod>1) drawScaleMod=1;
				drawScale=drawScale0+drawScaleMod;

				//SET SHIFT & SCALE
				var x_x=Math.cos(mapRot/180*Math.PI);
				var x_y=-Math.sin(mapRot/180*Math.PI);

				var y_x=Math.sin(mapRot/180*Math.PI);
				var y_y=Math.cos(mapRot/180*Math.PI);

				for(var i=0;i<layers.length;i++){
					var ll=layers[i];
					var pole=(i%2)*2-1;
					ll.obj.setScale(drawScale);
					switch(inputMode){
						//free move (not controlled)
						case "":
							ll.sX*=0.95;
							ll.sY*=0.95;
						break;
						//controlled by touch
						case "touch":
							ll.sX=touchSX*pole;
							ll.sY=touchSY*pole;
						break;
						//controlled by gamepad
						case "gamepad":
							ll.sX=gamepadSX*pole;
							ll.sY=gamepadSY*pole;
						break;
					}
					//add movement to layer
					if(gestureHappend){
						ll.sX=0;
						ll.sY=0;
					}else{
						ll.obj.shift(ll.sX*x_x+ll.sY*y_x,ll.sX*x_y+ll.sY*y_y);
					}
				
				}
				gestureHappend=false;
				touchSX=0;
				touchSY=0;
				gamepadSX=0;
				gamepadSY=0;	

				if(titleAnimActive){
					titleAnimCC++;
					if(titleAnimCC<titleAnimDelay){
						var perc=titleAnimCC/titleAnimDelay;
						if(perc<0.3){
							//visMirrors.alpha=0;
							titleMC.alpha=1;
						}else{
							//visMirrors.alpha=(perc-0.3)/(1-0.3);
							titleMC.alpha=1-(perc-0.3)/(1-0.3);
						}
					}else{
						titleAnimActive=false;
						visMirrors.alpha=1;
						if(titleMC!=null){
							titleHolder.removeChild(titleMC);
							titleMC=null;
						}
						
					}
			}

			if(fadeAnimActive) doFadeAnimation();
			
			
			if(FlipFlow.musicActive){
				music.onEF();
				updateMusicMaterials();
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
		function clearBack(e=null){
			drawBmpD.fillRect(drawBmpD.rect,0x000000);
		}
		function drawMap(){
			var upscalingMatrix:Matrix = new Matrix();
			upscalingMatrix.scale(1/upscaling,1/upscaling);
			if(baseMap.enabled) drawBmpD.draw(baseMapSprite,upscalingMatrix);

			//Filter
			if(filterMeta.type!="none"){
				
				//if there is changing filter param, recalculate ...
				if(filterMeta.type=="ColorAdjust"){
					if(filterParams.hueAni.enabled){
						filterParams.hueAni.alpha+=filterParams.hueAni.speed;
						filterHue=filterParams.hueAni.v0+(filterParams.hueAni.v1-filterParams.hueAni.v0)*(Math.sin(filterParams.hueAni.alpha)*0.5+0.5);
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
			
			//Blur
			if(mapM.blur.enabled){
				drawBmpD.applyFilter(drawBmpD,drawBmpD.rect,new Point(0,0),new BlurFilter(mapM.blur.val,mapM.blur.val));
			}
			for(var i=0;i<layers.length;i++){
				layers[i].obj.vis.rotation=mapRot;
			}

			drawBmpD.draw(visMap,upscalingMatrix);
			
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
			if(mapM.shiftEffect.enabled){
				mapM.shiftEffect.alpha+=mapM.shiftEffect.speed;
				drawBmpD.scroll(Math.sin(mapM.shiftEffect.alpha)*mapM.shiftEffect.radius,Math.cos(mapM.shiftEffect.alpha)*mapM.shiftEffect.radius);
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

		// TITLE ANIM
		var titleAnimCC:Number=0;
		var titleAnimDelay:Number=0;
		var titleAnimActive:Boolean=false;
		public function startTitleAnimation(tmc){
			if(titleMC!=null){
				titleHolder.removeChild(titleMC);
				titleMC=null;
			}

			var c:Class = getDefinitionByName(tmc) as Class;
			titleMC = new c();
			titleHolder.addChild(titleMC);
			titleMC.x=dimX/2;
			titleMC.y=dimY/2;
			titleMC.scaleX=dimY/768;
			titleMC.scaleY=dimY/768;
			titleMC["back"].scaleX=dimX/1024/dimY*768;
			titleAnimCC=0;
			titleAnimDelay=24*3;
			titleAnimActive=true;
		}
		public function stopTitleAnimation(){
			titleAnimActive=false;
			if(titleMC!=null){
				titleHolder.removeChild(titleMC);
				titleMC=null;
			}
		}

		// FADE ANIM
		var fadeAnimActive:Boolean=false;
		var fadeAnimInd:Number=0;
		var fadeAnimCC:Number=0;
		var fadeAnimLength:Number=24*6;
		var fadeAnimGap:Number=24*3;
		var fadeAnimDelay:Number=0; // calculated
		public function startFadeAnimation(){
			
			fadeAnimCC=0;
			fadeAnimInd=0;
			fadeAnimActive=true;
			fadeAnimDelay=fadeAnimLength+(layers.length-1)*(fadeAnimLength-fadeAnimGap);
			for(var i=0;i<layers.length;i++){
				layers[i].obj.vis.alpha=0;
			}
		}
		public function doFadeAnimation(){
			fadeAnimCC++;
			var perc=0;
			var str="";
			if(fadeAnimCC>=fadeAnimDelay) stopFadeAnimation();
			else{
				for(var i=0;i<layers.length;i++){
					if(fadeAnimCC<i*fadeAnimGap) layers[mapM.buildOrder[i]].obj.vis.alpha=0;
					else if(fadeAnimCC>i*fadeAnimGap+fadeAnimLength) layers[mapM.buildOrder[i]].obj.vis.alpha=drawAlpha*layers[mapM.buildOrder[i]].m.alpha;
						else{
							perc=(fadeAnimCC-i*fadeAnimGap)/fadeAnimLength;
							layers[mapM.buildOrder[i]].obj.vis.alpha=drawAlpha*perc*layers[mapM.buildOrder[i]].m.alpha;//1-Math.sin(Math.PI/2*(1-perc));
						}
					//str+=" "+Math.round(layers[i].obj.vis.alpha*100);
				}
			}
			//trace(str);
		}
		public function stopFadeAnimation(){
			fadeAnimActive=false;
			for(var i=0;i<layers.length;i++){
				layers[i].obj.vis.alpha=drawAlpha*layers[i].m.alpha;
			}
		}

		public function setDrawAlpha(a){
			drawAlpha=a;
			if(drawAlpha>1)drawAlpha=1;
			if(drawAlpha<0)drawAlpha=0;
			for(var i=0;i<layers.length;i++){
				layers[i].obj.vis.alpha=drawAlpha*layers[i].m.alpha;
			}
		}
		
		public function openMenu(e=null){
			if(playing){
				stopTitleAnimation();
				pause(true);
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
				winMenu.visible=true;
				winMenu.open();
				//overlayShade.visible=true;
			}
		}
		public function closeMenu(e=null){
			if(!playing){
				
				winMenu.visible=false;
				winMenu.close();

				stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				pause(false);
			}
			//overlayShade.visible=false;
		}

		public function takeScreenShot(e=null){
			if(playing){
			var win = new OverlayScreenshot();
			win.x=dimX/2;
			win.y=dimY/2;
			addChild(win);
			win.scaleX=buttScale;
			win.scaleY=buttScale;
			//var cameraRoll:CameraRoll = new CameraRoll();
			var bmpD:BitmapData=getScreenShot();
			//cameraRoll.addBitmapData(bmpD);
			bmpD.dispose();
		}}
		
		public function openVJYWeb(e=null){
			navigateToURL(new URLRequest("http://www.vjyourself.com"), "_blank");
		}
		
		/**********************************************************
		  MUSIC META
		*****************************************************************/

		var musicMaterials={};
		function initMusicMaterials(){
			var mm:MusicMaterial;

			//circ512
			mm = new MusicMaterial();
			mm.dim=512;
			mm.compDrawWave.waveData=music.meta.waveDataDamped;
			mm.init();
			MM["circ512"]=mm;

			//circ1024
			/*mm = new MusicMaterial();
			mm.dim=1024;
			mm.compDrawWave.waveData=music.meta.waveDataDamped;
			mm.init();
			MM["circ1024"]=mm;*/
			
		}

		function updateMusicMaterials(){
			for(var i in MM) MM[i].onEF();
		}

		
	}
}