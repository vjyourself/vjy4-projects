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

	public class AppGamepad extends MovieClip{

		var gi:GameInput;
		var gamepad:GameInputDevice;
		var fanA:MovieClip;
		var fanB:MovieClip;

		var x1:WaveFollow=new WaveFollow({div:3,treshold:0});
		var y1:WaveFollow=new WaveFollow({div:3,treshold:0});
		var x2:WaveFollow=new WaveFollow({div:3,treshold:0});
		var y2:WaveFollow=new WaveFollow({div:3,treshold:0});

		var microphone:Microphone;
		var sampleInd:Number=0;

		public function AppGamepad() {
			// constructor code
			log("Capabilities.os: "+Capabilities.os);
			log("Capabilities.playerType: "+Capabilities.playerType);
			log("Micy: "+Microphone.isSupported);
			if(Microphone.isSupported){
				log("MicNum: "+Microphone.names.length);
				for(var i=0;i<Microphone.names.length;i++) log(Microphone.names[i]);
				microphone = Microphone.getMicrophone();
				microphone.rate=22;
				microphone.gain=1;
				log("mymicy: "+microphone);
				log("muted: "+microphone.muted);
				log("name: "+microphone.name);
				microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, microphoneOnSampleData); 
			}
			log("GameInput: "+GameInput.isSupported);
			if(GameInput.isSupported){
				log("Gamepads: "+GameInput.numDevices);
				gi=new GameInput();
				gi.addEventListener(GameInputEvent.DEVICE_ADDED,onAdded,0,0,1);
				gi.addEventListener(GameInputEvent.DEVICE_REMOVED,onRemoved,0,0,1);
			}
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
		}
		
		function microphoneOnSampleData(eve:SampleDataEvent){
		//	trace("SAMPLE");
			sampleInd++;
			tfMicSample.text=""+sampleInd;
		}
		function onKeyDown(e:KeyboardEvent){
			e.stopPropagation();
			e.preventDefault();
		}
		function log(txt){
			tfTrace.text+=txt+"\n";
			trace(txt);
		}
		function onAdded(e:GameInputEvent){
			var device=e.device;
			log("ADDED: "+device.name);
			log("id: "+device.id);
			log("numCtrl: "+device.numControls);
			
			start();
		}

		function onRemoved(e:GameInputEvent){
			log("REMOVED");
		}

		function start(){
			gamepad=GameInput.getDeviceAt(0);
			gamepad.enabled=true;
	
			for(var i=0;i<gamepad.numControls;i++){
				var c:GameInputControl=gamepad.getControlAt(i);
				log(c.id+" "+c.minValue+"-"+c.maxValue+" : "+c.value);
			}
			//log("controls: "+gamepad.numControls);
		}


function onEF(e:Event){
	//trace(microphone.activityLevel);
	tfMicLevel.text=""+microphone.activityLevel;
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
	}
}	

	}
	
}
