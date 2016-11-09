package{
    import flash.display.MovieClip;
    import flash.display.Bitmap;
    import flash.display.BlendMode;
	import vjyourself4.comp.*;
    public class WaveCirc extends MovieClip{
        var bmp:Bitmap;
        public var src:String="circ512";
        public var dim:Number=512;

        public function WaveCirc(){
        }
        public function init(){
            if(CompGlobals.NS.MM!=null){
                if(CompGlobals.NS.MM["circ512"]!=null){
                    bmp = new Bitmap(CompGlobals.NS.MM["circ512"].BMPD);
                    bmp.width=dim;
                    bmp.height=dim;
                    bmp.x=-dim/2;
                    bmp.y=-dim/2;
                    addChild(bmp);
                    this.blendMode=BlendMode.ADD;
                }
            }
        }
    }
}