public class CalibrationState extends State {
	void enter() {
		for (Sphero item : mSpheros.values()) {
			item.tuioPos0.set(item.tuioPos);
		}

		sendOsc(SharedConfig.MSG_MOVE, CALIBRATION_MOVE_VELOCITY);
	}

	void quit() {
	}

	void draw() {
		noFill();

		stroke(255, 0, 0);
		for (Sphero item : mSpheros.values()) {
			ellipse(item.tuioPos0.x * width, item.tuioPos0.y * height, 10, 10);
		}
		fill(255);
	}
}