package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Flash extends MovieClip {
		var aa:Number=0;
		var speed=1;
		var delay=24;

		public function Flash() {
			addEventListener(Event.ENTER_FRAME,onEF,0,0,1);
		}
		
		public function onEF(e){
			aa+=speed;
			if(aa>=delay){
				aa=0;
				this.visible=true;
			}else{
				this.visible=false;
			}

		}
	}
	
}
