package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	//import vjyourself2.wave.WaveFollow;
	//import vjyourself2.wave.ColorScale;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	
	public class LayerShift extends Sprite{
		
		public var params:Object;
		var dimX:Number=320;
		var dimY:Number=480;
		var eDimX:Number=3000;
		var eDimY:Number=2000;

		var vis:Sprite;
		var elems:Array=[];
		var layerX:Number=0;
		var layerY:Number=0;
		var layerMX:Number=0;
		var layerMY:Number=0;
		var layerScale:Number=1;
	
		
		function LayerShift(){
	
		}
		
		public function dispose(){
			while(elems.length>0){
				vis.removeChild(elems.pop());
			}
		}
		

		public function init(){
			vis = new Sprite();

			eDimX=params.dimX*params.scale*layerScale;
			eDimY=params.dimY*params.scale*layerScale;

			layerMX=dimX/2;
			layerMY=dimY/2;

			var c:Class = getDefinitionByName(params.cn) as Class;
			for(var x=0;x<3;x++) for(var y=0;y<3;y++){
				var patt=new c();
				patt.scaleX=params.scale*layerScale;
				patt.scaleY=params.scale*layerScale;
				patt.x=(x-1)*eDimX;
				patt.y=(y-1)*eDimY;
				vis.addChild(patt);
				elems.push(patt);
			}

		}

		public function shift(x,y){
			layerX+=x;
			layerY+=y;
	
			//trace(layerX,layerY);

			//9 FOLD REPEAT LOOP
			if(layerX>0) layerX-=eDimX;
			if(layerY>0) layerY-=eDimY;
			if(layerX<-eDimX) layerX+=eDimX;
			if(layerY<-eDimY) layerY+=eDimY;

			for(var x=0;x<3;x++) for(var y=0;y<3;y++){
					var patt=elems[x*3+y];
					//patt.scaleX=params.scale*layerScale;
					//patt.scaleY=params.scale*layerScale;
					patt.x=(x-1)*eDimX+layerX;
					patt.y=(y-1)*eDimY+layerY;
				}
		}

		public function setScale(s){
			if(layerScale!=s)
			{
				var zoom=s/layerScale;
				layerScale=s;

				eDimX=params.dimX*params.scale*layerScale;
				eDimY=params.dimY*params.scale*layerScale;
				layerX+=(layerX-dimX/2)*(zoom-1);
				layerY+=(layerY-dimY/2)*(zoom-1);
				

				for(var x=0;x<3;x++) for(var y=0;y<3;y++){
					var patt=elems[x*3+y];
					patt.scaleX=params.scale*layerScale;
					patt.scaleY=params.scale*layerScale;
					patt.x=(x-1)*eDimX+layerX;
					patt.y=(y-1)*eDimY+layerY;
				}

				
				
			}

		}
	
		
	}
}