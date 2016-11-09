package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class ScaleSin extends MovieClip {
		var aa:Number=0;
		var speed=2;
		var s0:Number=0.2;
		var s1:Number=1;

		public function ScaleSin() {
			addEventListener(Event.ENTER_FRAME,onEF,0,0,1);
		}
		
		public function onEF(e){
			aa=(aa+speed)%360;
			this.scaleX = s0+(s1-s0)*(Math.sin(aa/180*Math.PI)/2+0.5);
			this.scaleY=this.scaleX;
		}
	}
	
}
