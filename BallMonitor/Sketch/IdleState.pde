public class IdleState extends State {
	void enter() {
	}

	void quit() {
	}

	void draw() {
		if (mSpheros.size() == 1 && elapsedSec() > 2) {
			changeState(new WaitForConnectionState());
		}
	}
}
