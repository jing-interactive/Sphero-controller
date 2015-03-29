void setup() {
	size(800, 800);
}

void draw() {
	background(0);
	ellipse(width / 2, height / 2, 10, 10);
	ellipse(mouseX, mouseY, 10, 10);
	PVector dir = new PVector(mouseX - width / 2, mouseY - height / 2);
	float deg = degrees(dir.heading());
	println("deg: " + deg);
}