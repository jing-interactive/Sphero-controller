public class Sphero {
    String name = "Sphere #XXX";
    PVector realPos = new PVector(); // real world
    PVector tuioPos0 = new PVector(); // initial position
    PVector tuioPos = new PVector(); // recv from KinServer
    long tuioId;
}

Map<Long, Sphero> mSpheros = new HashMap<Long, Sphero>();

/*
if (mSpheros.containsKey(sphero.getName())) {

mSperos.size();

mSpheros.put(sphero.getName(), sphero);
mSpheros.remove(sphero.getName());
mSpheros.get(sphero.getName());

for (Sphero robot : mRobots.values()) {

*/

void addTuioSphero(long tuioId, float x, float y) {
    currentState.addTuioSphero(tuioId, x, y);
}

void updateTuioSphero(long tuioId, float x, float y) {
    synchronized (mSpheros) {
        Sphero item = mSpheros.get(tuioId);
        if (item == null) {
            item = new Sphero();
            item.tuioId = tuioId;
            item.tuioPos0.set(x, y);
            mSpheros.put(tuioId, item);
        }
        item.tuioPos.set(x, y);
    }

    currentState.updateTuioSphero(tuioId, x, y);
}

void removeTuioSphero(long tuioId, float x, float y) {
    currentState.removeTuioSphero(tuioId, x, y);

    synchronized (mSpheros) {
        mSpheros.remove(tuioId);
    }
}