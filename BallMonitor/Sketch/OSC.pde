/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setupOsc() {
    /* start oscP5, listening for incoming messages at port 12000 */
    oscP5 = new OscP5(this, 3333);

    oscP5.plug(this, "tuio2Dcur", "/tuio/2Dcur", "sifffff");

    myRemoteLocation = new NetAddress("127.0.0.1", 4444);
}

final int FAKE_BLOB_ID = 9999;

public void tuio2Dcur(String addrPattern, int id, float x, float y, float fvx, float fvy, float fa) {
    if (id == FAKE_BLOB_ID) {
        println("target x:" + x + " y:" + y);
    } else {
        println("ball_" + id + " x:" + x + " y:" + y);
    }
}

private void testOsc() {
    /* in the following different ways of creating osc messages are shown by example */
    OscMessage msg = new OscMessage("/test");

    msg.add(123); /* add an int to the osc message */

    /* send the message */
    oscP5.send(msg, myRemoteLocation);
}

void sendOsc(String name) {
    OscMessage msg = new OscMessage(name);
    oscP5.send(msg, myRemoteLocation);
}

void sendOsc(String name, String value) {
    OscMessage msg = new OscMessage(name);
    msg.add(value);
    oscP5.send(msg, myRemoteLocation);
}

void sendOsc(String name, float value) {
    OscMessage msg = new OscMessage(name);
    msg.add(value);
    oscP5.send(msg, myRemoteLocation);
}

void sendOsc(String name, int value) {
    OscMessage msg = new OscMessage(name);
    msg.add(value);
    oscP5.send(msg, myRemoteLocation);
}

/* incoming osc message are forwarded to the oscEvent method. */
void _oscEvent(OscMessage msg) {
    /* print the address pattern and the typetag of the received OscMessage */
    print("### received an osc message.");
    print(" addrpattern: " + msg.addrPattern());
    println(" typetag: " + msg.typetag());
    println(" from " + msg.address());

    if (msg.checkAddrPattern("/state")) {
        State newState = null;
        String state = msg.get(0).stringValue();
        if (state.equals("menu")) {
            newState = new MenuState();
        } else if (state.equals("intro")) {
            newState = new IntroState();
        }

        if (newState != null) {
            changeState(newState);
            return;
        }
    }

    currentState.oscEvent(msg);
}
