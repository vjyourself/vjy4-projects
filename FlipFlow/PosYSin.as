package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class PosYSin extends MovieClip {
		var aa:Number=0;
		var speed=6;
		var distance=60;
		var y0:Number=0;

		public function PosYSin() {
			addEventListener(Event.ENTER_FRAME,onEF,0,0,1);
			y0=this.y;
		}
		
		public function onEF(e){
			aa=(aa+speed)%360;
			this.y=y0+Math.sin(aa/180*Math.PI)*distance/2;

		}
	}
	
}
