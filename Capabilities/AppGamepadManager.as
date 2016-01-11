package  {
	import flash.display.MovieClip;
	import flash.ui.GameInput;
	import flash.events.GameInputEvent;
	import flash.ui.GameInputDevice;
	import flash.events.Event;
	import flash.ui.GameInputControl;
	import flash.events.KeyboardEvent;
	import vjyourself4.patt.WaveFollow;
	import flash.media.Microphone;
	import flash.events.SampleDataEvent;
	import flash.system.Capabilities;
	import vjyourself4.io.gamepad.GamepadManager;
	import vjyourself4.io.gamepad.GamepadState;
	import vjyourself4.sys.MetaStream;

	public class AppGamepadManager extends MovieClip{

		var debug:MetaStream;
		var man:GamepadManager;
		
		var fanA:MovieClip;
		var fanB:MovieClip;

		var x1:WaveFollow=new WaveFollow({div:3,treshold:0});
		var y1:WaveFollow=new WaveFollow({div:3,treshold:0});
		var x2:WaveFollow=new WaveFollow({div:3,treshold:0});
		var y2:WaveFollow=new WaveFollow({div:3,treshold:0});

		var microphone:Microphone;
		var sampleInd:Number=0;



		public function AppGamepadManager() {
			debug = new MetaStream();
			debug.console={log:log};
			debug.init();
			tfTrace.text="";
			// constructor code
			var oos=Capabilities.os.toLowerCase();
			var platform="Mac";
			if(oos.indexOf("windows")>=0) platform="Win";
			if(oos.indexOf("linux")>=0) platform="Linux";
			
			man = new GamepadManager();
			man._debug=debug;
			man.platform=platform;
			man.defGamepadType="XBOX";
			man.init();
			man.events.addEventListener("CHANGE",onChange,0,0,1);

			addEventListener(Event.ENTER_FRAME,onEF,0,0,1);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown,0,0,1);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyDown,0,0,1);
			fanA = new Fan();
			visBack.addChild(fanA);
			fanA.width=960*2;
			fanA.height=960*2;
			fanB = new Fan2();
			visBack.addChild(fanB);
			fanB.blendMode="add";
			fanB.width=960*2;
			fanB.height=960*2;
			log("Capabilities.os: "+Capabilities.os);
			log("Capabilities.playerType: "+Capabilities.playerType);
		
		}
	
		function onKeyDown(e:KeyboardEvent){
			e.stopPropagation();
			e.preventDefault();
		}
		function log(txt){
			tfTrace.text+=txt+"\n";
			trace(txt);
		}
		function onChange(e){
			trace("CHANGED");
		}
		
		


		function onEF(e:Event){
			//trace(microphone.activityLevel);
			//tfMicLevel.text=""+microphone.activityLevel;

			man.onEF();
			var s0=man.getState(0);
			var str="";
			for(var i in s0) if((i=="LeftStick")||(i=="RightStick")) str+=i+".x : "+s0[i].x+"\n"+i+".y : "+s0[i].y+"\n"; else str+=i+" : "+s0[i]+"\n";
			tfCon.text=str;
	/*
	if(gamepad!=null){
		//tfCon.text="";
		var str="";
		for(var i=0;i<gamepad.numControls;i++){
			var c:GameInputControl=gamepad.getControlAt(i);
			str+=c.id+" "+c.minValue+" - "+c.maxValue+" : "+c.value+"\n";
			switch(i){
				case 0:x1.setVal(c.value*0.5+0.5);break;
				case 1:y1.setVal(c.value*0.5+0.5);break;
				case 3:x2.setVal(c.value*0.5+0.5);break;
				case 4:y2.setVal(c.value*0.5+0.5);break;
			}
		}
		tfCon.text=str;
		x1.onEF();y1.onEF();
		fanA.x=960*x1.val;
		fanA.y=540*y1.val;
		x2.onEF();y2.onEF();
		fanB.x=960*x2.val;
		fanB.y=540*y2.val;
			}*/
		}	

	}
	
}
