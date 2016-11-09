package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class LinearRot extends MovieClip {
		var aa:Number=0;
		var speed=1;

		public function LinearRot() {
			addEventListener(Event.ENTER_FRAME,onEF,0,0,1);
		}
		
		public function onEF(e){
			aa=(aa+speed)%360;
			this.rotation = aa;

		}
	}
	
}
