package  {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	public class WinMenu extends MovieClip {
		public var app:AppFlipFlow;
		public var dimX:Number;
		public var dimY:Number;
		public var ppi:Number=130;
		public var buttScale:Number=1;

		public var iconSize=1/2;
		
		var overlayShade:Sprite;
		var overlayShadeUnderButtons:Sprite;
		var onClose:Function;
		var openLevel:Function;

		var maps:Array;
		var thumbs:Array;
		var scrollPane:Sprite;
		var scrollPaneWidth:Number=0;

		var scrollPaneShade:Sprite;
		var scrollPaneCont:Sprite;
		var scrollPaneContWidth:Number=0;
		var scrollPos:Number=0;
		var iconDim:Number=0;
		var iconScale:Number=1;
		var speed:Number=0;

		var toggle8bit:Toggle8bit;
		var buttVJY:RoundVJY;
		var buttControls:RoundControls;
		var winLanding:Sprite;
		var winControls:WinControls;

		public function WinMenu() {}

		public function init(){
			addEventListener(Event.ENTER_FRAME,onEF,0,0,1);
			overlayShade = new OverlayShade();
			
			addChild(overlayShade);
			winLanding = new Sprite();
			addChild(winLanding);

			
			overlayShade.addEventListener(MouseEvent.CLICK,onBackClick);

			scrollPane=new Sprite();
			
			scrollPaneShade = new OverlayShade();
			scrollPane.addChild(scrollPaneShade);
			scrollPaneCont = new Sprite();
			scrollPane.addChild(scrollPaneCont);
			winLanding.addChild(scrollPane);

			thumbs=[];
			iconDim = dimY*iconSize;
			iconScale = iconDim/260;

			for(var i=0;i<maps.length;i++){
				var e={};
				e.thumbFrame= new ThumbFrame();
				e.thumbFrame.addEventListener(MouseEvent.MOUSE_UP,thumbUp);

				e.thumbFrame.name=i;
				var c:Class = getDefinitionByName(maps[i].thumbMC) as Class;
				e.thumb=new c();
				e.thumb.name=i;
				e.thumbFrame.img.addChild(e.thumb);
				scrollPaneCont.addChild(e.thumbFrame);
				
				e.thumbFrame.x=iconDim*i;
				e.thumbFrame.y=-iconDim/2;
				e.thumbFrame.scaleX=iconScale;
				e.thumbFrame.scaleY=iconScale;
				
			}
			
			scrollPaneContWidth=maps.length*iconDim;

			toggle8bit = new Toggle8bit();
			winLanding.addChild(toggle8bit);
			toggle8bit.addEventListener(MouseEvent.MOUSE_DOWN,onToggle8bit);
			buttVJY= new RoundVJY();
			buttVJY.addEventListener(MouseEvent.MOUSE_DOWN,onVJY);
			
			winLanding.addChild(buttVJY);
			buttControls = new RoundControls();
			buttControls.addEventListener(MouseEvent.MOUSE_DOWN,onControls);
			
			winLanding.addChild(buttControls);

			winControls= new WinControls();
			winControls.visible=false;
			addChild(winControls);
			winControls.addEventListener(MouseEvent.CLICK,onClickControls);
			// onResize();
		}
		
		public function onResize(e=null){
			iconDim = dimY*iconSize;
			iconScale = iconDim/260;

			overlayShade.width=dimX;
			overlayShade.height=dimY;
			scrollPane.y=dimY/2;
			scrollPane.x=20;
			scrollPaneWidth=dimX-20*2;
			scrollPaneShade.width=dimX;
			scrollPaneShade.height=iconDim;
			scrollPaneShade.y=-iconDim/2;

			toggle8bit.scaleX=iconScale;
			toggle8bit.scaleY=iconScale;
			toggle8bit.x=dimX*0.25;
			toggle8bit.y=(dimY-iconDim)/2/2;

			buttControls.scaleX=iconScale;
			buttControls.scaleY=iconScale;
			buttControls.x=dimX*0.75;
			buttControls.y=(dimY-iconDim)/2/2;

			buttVJY.scaleX=iconScale;
			buttVJY.scaleY=iconScale;
			buttVJY.x=dimX/2;
			buttVJY.y=dimY-(dimY-iconDim)/2/2;

			winControls.dimX=dimX;
			winControls.dimY=dimY;
			// winControls.ppi=ppi;
			winControls.buttScale=buttScale;
			winControls.onResize();
		}

		function onToggle8bit(e){
			app.toggleUpScaling();
			toggle8bit.gotoAndStop(toggle8bit.currentFrame%2+1);
			onClose();
		}

		function onVJY(e){
			navigateToURL(new URLRequest("http://vjyourself.com"));
		}
		function onControls(e){
			overlayShade.alpha=0.3;
			overlayShadeUnderButtons.visible=true;
			winLanding.visible=false;
			winControls.visible=true;
		}
		function closeControls(){
			overlayShade.alpha=1;
			overlayShadeUnderButtons.visible=false;
			winLanding.visible=true;
			winControls.visible=false;
		}
		function onClickControls(e:MouseEvent){
			// e.stopImmediatePropagation();
			trace("ON CLICK CTRL");
			closeControls();
		}

		var scrollDrag:Boolean=false;
		var scrollMoved:Boolean=false;
		var scrollDragX0:Number=0;
		var scrollDragY0:Number=0;
		var scrollDragX00:Number=0;
		var scrollDragY00:Number=0;

		public function scrollDown(e){
			scrollDrag=true;
			scrollMoved=false;
			scrollDragX0=stage.mouseX;
			scrollDragY0=stage.mouseY;
			scrollDragX00=stage.mouseX;
			scrollDragY00=stage.mouseY;
		}
		public function thumbUp(e:MouseEvent){
			scrollDrag=false;
			if(
				(Math.abs(scrollDragX00-scrollDragX0)<ppi/6)&&
				(Math.abs(scrollDragY00-scrollDragY0)<ppi/6)

				){
				trace(e.target.name);
				onClose();
				openLevel(e.target.name);
			}
		}
		public function open(){
			stage.addEventListener(MouseEvent.MOUSE_DOWN,scrollDown);
			//scrollPane.addEventListener(MouseEvent.MOUSE_UP,scrollUp);
			stage.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			speed=0;
		}
		public function close(){
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,scrollDown);
			//scrollPane.addEventListener(MouseEvent.MOUSE_UP,scrollUp);
			stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			speed=0;
		}
		public function mouseUp(e){
			scrollDrag=false;
		}
		public function mouseMove(e){
			if(scrollDrag){
				scrollMoved=true;
				addScroll(stage.mouseX-scrollDragX0);
				scrollDragX0=stage.mouseX;
				scrollDragY0=stage.mouseY;
			}
		}
		var frameMove:Number=0;
		public function addScroll(val){
			frameMove+=-val;
		}
		public function setScroll(val){
			scrollPos=val;
			if(scrollPos<0) scrollPos=0;
			if(scrollPos>scrollPaneContWidth-scrollPaneWidth) scrollPos=scrollPaneContWidth-scrollPaneWidth;
			scrollPaneCont.x=-scrollPos;
		}
		

		function onBackClick(e){
			if(winControls.visible) closeControls();
			else onClose();
		}
		public function onEF(e=null){
			if(frameMove!=0)speed=frameMove;
			frameMove=0;
			
			setScroll(scrollPos+speed);
			speed*=0.9;

		}
	}
	
}
