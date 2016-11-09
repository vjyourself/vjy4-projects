package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class SinRot extends MovieClip {
		var aa:Number=0;
		var angle=30;
		var speed=0.05;

		public function SinRot() {
			addEventListener(Event.ENTER_FRAME,onEF,0,0,1);
		}
		
		public function onEF(e){
			aa+=speed;
			this.rotation = Math.sin(aa)*angle/2;

		}
	}
	
}
