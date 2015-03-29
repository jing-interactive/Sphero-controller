public class CalibrationState extends State {
	void enter() {
		for (Sphero item : mSpheros.values()) {
			item.tuioPos0.set(item.tuioPos);
		}

		sendSpheroMove(0, CALIBRATION_MOVE_VELOCITY);
	}

	void quit() {
		for (Sphero item : mSpheros.values()) {
			item.baseDegree = degrees(PVector.sub(item.tuioPos, item.tuioPos0).heading());
		}
	}

	void draw() {
		noFill();

		stroke(255, 0, 0);
		for (Sphero item : mSpheros.values()) {
			ellipse(item.tuioPos0.x * width, item.tuioPos0.y * height, 10, 10);
		}

		if (elapsedSec() > CALIBRATION_READY_SECONDS) {
			changeState(new MainControlState());
		}
		fill(255);
	}
}