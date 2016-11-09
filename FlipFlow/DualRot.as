package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class DualRot extends MovieClip {
		var aa:Number=0;
		
		public function DualRot() {
			addEventListener(Event.ENTER_FRAME,onEF,0,0,1);
		}
		
		public function onEF(e){
			aa+=0.1;
			obj1.x=Math.sin(aa)*32;
			obj1.y=Math.cos(aa)*32;
			
			obj2.x=Math.sin(aa)*28;
			obj2.y=Math.cos(aa)*28;

		}
	}
	
}
