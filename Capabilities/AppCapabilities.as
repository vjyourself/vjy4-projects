package{
    import flash.display.MovieClip;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.system.Capabilities;
    import flash.media.Microphone;
    import flash.ui.GameInput;
    import flash.ui.Multitouch;
	import flash.text.TextFormat;
    public class AppCapabilities extends MovieClip{
        public function AppCapabilities(){
            trace("hello");
            stage.scaleMode=StageScaleMode.NO_SCALE;
            stage.align=StageAlign.TOP_LEFT;
            
            tfConsole.x=20;
            tfConsole.y=20;
            tfConsole.width=stage.fullScreenWidth-40;
            tfConsole.height=stage.fullScreenHeight-40;
            tfConsole.text="";
            
            

            border.x=0;
            border.y=0;
            border.width=stage.fullScreenWidth-1;
            border.height=stage.fullScreenHeight-1;

            log("fullScreen : "+stage.fullScreenWidth+"x"+stage.fullScreenHeight);
            log("stage : "+stage.stageWidth+"x"+stage.stageHeight);
            log("PPI : "+Capabilities.screenDPI);
            log("diagonal : "+(Math.round(Math.sqrt(Math.pow(stage.fullScreenWidth/Capabilities.screenDPI,2)+Math.pow(stage.fullScreenHeight/Capabilities.screenDPI,2))*100)/100));
            log("OS : "+Capabilities.os);
            log("CPU : "+Capabilities.cpuArchitecture);
            log("touch : "+Capabilities.touchscreenType);
            if(Capabilities.touchscreenType!="none"){
                log("multitouch : "+Multitouch.maxTouchPoints);
            }
            log("mic : "+Microphone.isSupported);
            if(Microphone.isSupported){
                log("micNum : "+Microphone.names.length);
                if(Microphone.names.length>0) log("mic[0] : "+Microphone.names[0]);
            }
            log("gamepad : "+GameInput.isSupported);
            if(GameInput.isSupported){
                log("gamepadNum : "+GameInput.numDevices);
            }
            
           var myformat:TextFormat = new TextFormat(); 
            myformat.color = 0xffffff; 
            myformat.size = 32/326*Capabilities.screenDPI; 
            myformat.underline = false; 
            tfConsole.setTextFormat(myformat);
        }
        function log(s:String){
            tfConsole.text=tfConsole.text+" >> "+s;
            trace(s);
        }
    }
}