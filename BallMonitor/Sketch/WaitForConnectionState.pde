public class WaitForConnectionState extends State {
	void enter() {
		sendOsc(SharedConfig.MSG_DEVICE_QUERY);
	}

	void quit() {
	}

	void draw() {
		if (elapsedSec() > 5) {
			changeState(new IdleState());
		}
	}

	void oscEvent(OscMessage msg) {
		if (msg.checkAddrPattern(SharedConfig.MSG_DEVICE_ANSWER)) {
			int count = msg.get(0).intValue();
			println("count: " + count);
			if (count > 0) {
				changeState(new CalibrationState());
			}
		}
	}
}
