package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class PosXSin extends MovieClip {
		var aa:Number=0;
		var speed=1;
		var distance=20;

		public function PosXSin() {
			addEventListener(Event.ENTER_FRAME,onEF,0,0,1);
			x0=this.x;
		}
		
		public function onEF(e){
			aa+=(aa+speed)%360;
			this.x=x0+Math.sin(aa/180*Math.PI)*distance/2;

		}
	}
	
}
