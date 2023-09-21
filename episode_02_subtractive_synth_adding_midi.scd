// midi part
MIDIIn.connectAll;
(
// array has one slot per possible MIDI note
var midiSamplerArray = Array.newClear(128);

// MIDI processing
MIDIdef.noteOn(key: \sampleOn,
	func: { arg velocity, noteNumber;
		midiSamplerArray[noteNumber] = Synth(\MultiOsc,[
			\freq, noteNumber.midicps,
			\amp, velocity.linlin(0, 127, 0, 1),
			\release, ~globalRelease,
			\detune2, ~globalVCO2Detune,
			\cutoff, ~cutoff,
			\waveForm, ~waveForm,
			\resonance, ~resonance
		]);
});

MIDIdef.noteOff(key: \sampleOff,
	        func: { arg velocity, noteNumber;
		midiSamplerArray[noteNumber].set(\gate, 0);
		midiSamplerArray[noteNumber] = nil;
});


MIDIdef.cc(key: \ccTest,
	func: { arg value, ccNum, chan;
		chan.post;" ".post;
		value.post;" ".post;
		value.post;" ".post;
		ccNum.postln;
		~globalRelease.post;" ".post;
		~globalVC02Detune.post;" ".post;
		~cutoff.post;" ".post;
		~resonance.post;" ".post;
		~waveForm.post;" ".post;
		"".postln;

		if(ccNum==74,{ ~globalRelease = value.linlin(0,127, 0, 5 );"release".postln;});
		if(ccNum==75,{ ~globalVC02Detune = value.linexp(0,127, 0.00001, 0.7);"detuneVCO2".postln;});
		if(ccNum==76,{ ~cutoff = value.linexp(0,127, 10, 20000 );"cutoff".postln;});
		if(ccNum==77,{ ~resonance = value.linexp(0, 127, 4, 0.001);"resonance".postln;});

		// update all synths
		midiSamplerArray.do({arg synth;
			if( synth != nil , {
				synth.set(\release, ~globalRelease);
				synth.set(\detune2, ~globalVC02Detune);
				synth.set(\cutoff, ~cutoff);
				synth.set(\resonance, ~resonance);
				"update".postln;
			});
		});
	}
);
)
