package  {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	public class WinControls extends MovieClip {
		public var menu:WinMenu;
		var dimX:Number;
		var dimY:Number;
		// var ppi:Number=130;
		public var buttScale:Number=1;
		

		public function WinControls() {
			mid.buttLink.addEventListener(MouseEvent.CLICK,openVJYWeb,0,0,1);
			mid.buttContact.addEventListener(MouseEvent.CLICK,openVJYContact,0,0,1);
			
		}
		public function openVJYWeb(e=null){
			navigateToURL(new URLRequest("http://www.vjyourself.com"), "_blank");
		}
		public function openVJYContact(e=null){
			navigateToURL(new URLRequest("http://www.vjyourself.com"), "_blank");
		}
		public function onResize(e=null){
		
			var buttWidth=126*buttScale;
			var buttHeight=106*buttScale;
			
			// button stripe 3*buttScale
			var midSX=(dimX-4*buttWidth)/650;
			var midSY=dimY/676;
			var midS=(midSX>midSY)?midSY:midSX;
			
			// 650 * 676
			mid.x=dimX/2;
			mid.y=dimY/2;
			mid.scaleX=midS;
			mid.scaleY=midS;
			//mid["back"].scaleY=midSY/midS;

			var osc=buttScale*1.5;

			maps.x=dimX-buttWidth*1;
			maps.y=buttHeight*1.2;
			maps.scaleX=osc;
			maps.scaleY=osc;
			mirrors.x=buttWidth*1;
			mirrors.y=dimY-buttHeight*1.2;
			mirrors.scaleX=osc;
			mirrors.scaleY=osc;
			screenshot.x=dimX-buttWidth*0.5;
			screenshot.y=dimY-buttHeight*0.8;
			screenshot.scaleX=osc;
			screenshot.scaleY=osc;
		}

		
	}
	
}
