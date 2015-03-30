public class MainControlState extends State {
	PVector targetPos = new PVector();
	void enter() {
		targetPos.set(width / 2, height / 2);
		for (Sphero item : mSpheros.values()) {
			// See BallMonitor/sketch/doc/coordinate.png
			float alpha = degrees(PVector.sub(targetPos, item.tuioPos).heading());
			println("alpha: " + alpha);
			if (alpha < 0) {
				alpha += 360;
			}
			alpha -= item.baseTheta;
			if (alpha < 0) {
				alpha += 360;
			}
			println("final: " + alpha);
			sendSpheroMove(alpha, MAIN_CONTROL_MOVE_VELOCITY);

			// FIXME: should support multi-spheros
			break;
		}
	}

	void quit() {
	}

	void draw() {
		for (Sphero item : mSpheros.values()) {
			if (PVector.dist(targetPos, item.tuioPos) < CFG_TARGET_ARRIVAL_RADIUS) {
				println("arrived");
			}
		}
		// if (mSpheros.size() == 1 && elapsedSec() > 2) {
		// changeState(new IdleState());
		// }
	}
}
