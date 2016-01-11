package{
    import vjyourself4.media.MetaBeat;
    import flash.display.MovieClip;
	import flash.events.Event;
    public class AudioMeta extends MovieClip{
        var beat:MetaBeat;
        public function AudioMeta(){
            beat=new MetaBeat();
            beat.params={
                sync:"tap",
                tap:{}
            }
			beat.stage=stage;
            beat.init();
			addEventListener(Event.ENTER_FRAME,onEF);
        }
		function onEF(e){
			beat.onEF(e);
            var ss=beat.A["ASR1"].val/2;
            dot.scaleX=ss;
            dot.scaleY=ss;
            ss=beat.A["ASR2A"].val;
            dotA.scaleX=ss;
            dotA.scaleY=ss;
            ss=beat.A["ASR2B"].val;
            dotB.scaleX=ss;
            dotB.scaleY=ss;

		}
    }
}