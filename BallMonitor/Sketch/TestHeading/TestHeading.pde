void setup() {
	size(800, 800);
	setupOsc();
}

static String MSG_MOVE = "/move";

void sendSpheroMove(float heading, float velocity) {
	OscMessage msg = new OscMessage(MSG_MOVE);
	msg.add(heading);
	msg.add(velocity);
	oscP5.send(msg, myRemoteLocation);
}

float deg = 0;

void keyReleased() {
	sendSpheroMove(deg, 0.05);
}

void draw() {
	background(0);
	ellipse(width / 2, height / 2, 10, 10);
	ellipse(mouseX, mouseY, 10, 10);
	PVector dir = new PVector(mouseX - width / 2, mouseY - height / 2);

	if (mousePressed) {
		deg = degrees(dir.heading());
		if (deg < 0) deg += 360;
		println("deg: " + deg);
		sendSpheroMove(deg, 0);
	}
}