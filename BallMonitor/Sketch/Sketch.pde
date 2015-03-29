
float lastMouseMillis;
float millis; // The value of millis() at the beginning of draw()

void setup() {
    size(displayWidth / 2, displayHeight / 2, P2D);
    setupGUI();

    Ani.init(this);
    Ani.noOverwrite();

    changeState(new IdleState());

    setupOsc();
    setupTuio();

    lastMouseMillis = millis();
}

void draw() {
    millis = millis();
    background(122);

    drawGUI();

    synchronized (mSpheros) {
        for (Sphero item : mSpheros.values()) {
            ellipse(item.tuioPos.x * width, item.tuioPos.y * height, 10, 10);
        }
    }
    drawState();
}

void drawGUI() {
    if (SHOW_GUI) {
        grpConfig.show();
        // textFont(sysFont);
        textAlign(LEFT, BASELINE);

        fill(255);
        stroke(255);
        text("State: " + getStateName() + "\n" +
             "=g= GUI\n" +
             "=c= Calibration\n" +
             "=i= Intro\n" +
             "\n" +
             "fps: " + int(frameRate), width - 200, 50);
    } else {
        grpConfig.hide();
    }
    cp5.draw();
}

void keyReleased() {
    if (key == 'c') changeState(new CalibrationState());
    else if (key == 'i') changeState(new IdleState());

    if (key == 'g') SHOW_GUI = !SHOW_GUI;
}

boolean isMouseDown = false;

PVector mouseStart = new PVector();
PVector mouseDragged = new PVector();

void mousePressed() {
    lastMouseMillis = millis;
    isMouseDown = true;

    mouseStart.set(mouseX, mouseY);

    currentState.mousePressed();
}

void mouseDragged() {
    lastMouseMillis = millis;
    mouseDragged.set(mouseX - mouseStart.x, mouseY - mouseStart.y);

    currentState.mouseDragged();
}

void mouseReleased() {
    isMouseDown = false;
    lastMouseMillis = millis;
    mouseDragged.set(0, 0);
    currentState.mouseReleased();
}
