public class MainControlState extends State {
	PVector targetPos = new PVector();
	void enter() {
		targetPos.set(width / 2, height / 2);
		for (Sphero item : mSpheros.values()) {
			// See BallMonitor/sketch/doc/coordinate.png
			float absolute = degrees(PVector.sub(targetPos, item.tuioPos).heading());
			if (absolute < 0) {
				absolute += 360;
			}
			println("absolute: " + absolute);
			float relative = absolute - item.baseTheta;
			if (relative < 0) {
				relative += 360;
			}
			println("relative: " + relative);
			sendSpheroMove(relative, MAIN_CONTROL_MOVE_VELOCITY);

			// FIXME: should support multi-spheros
			break;
		}
	}

	void quit() {
	}

	void draw() {
		synchronized (mSpheros) {
			for (Sphero item : mSpheros.values()) {
				if (PVector.dist(targetPos, item.tuioPos) < CFG_TARGET_ARRIVAL_RADIUS) {
					println("arrived");
					sendSpheroMove(0, 0);
				} else {
					// changeState(new MainControlState());
				}
			}
		}
		// if (mSpheros.size() == 1 && elapsedSec() > 2) {
		// changeState(new IdleState());
		// }
	}
}
