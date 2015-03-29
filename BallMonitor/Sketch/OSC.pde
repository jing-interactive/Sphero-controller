/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

boolean isPadIpRecieved = false;
void setupOsc() {
    oscP5 = new OscP5(this, SharedConfig.OSC_PC_PORT);

    myRemoteLocation = new NetAddress(CFG_PAD_IP, SharedConfig.OSC_PAD_PORT);
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

void oscEvent(OscMessage msg) {
    print(msg.addrPattern());
    println(" typetag: " + msg.typetag());
    // println(" from " + msg.address());

    if (!isPadIpRecieved) {
        isPadIpRecieved = true;
        CFG_PAD_IP = msg.address().substring(1);
        saveConfig(); // HACK: should be automatically
        myRemoteLocation = new NetAddress(CFG_PAD_IP, SharedConfig.OSC_PAD_PORT);
    }

    currentState.oscEvent(msg);
}
