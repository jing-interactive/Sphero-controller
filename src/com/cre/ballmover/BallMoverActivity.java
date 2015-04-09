package com.cre.ballmover;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import orbotix.robot.base.CollisionDetectedAsyncData;
import orbotix.robot.base.Robot;
import orbotix.robot.base.RobotProvider;
import orbotix.robot.sensor.DeviceSensorsData;
import orbotix.sphero.CollisionListener;
import orbotix.sphero.ConfigurationControl;
import orbotix.sphero.ConnectionListener;
import orbotix.sphero.DiscoveryListener;
import orbotix.sphero.PersistentOptionFlags;
import orbotix.sphero.SensorControl;
import orbotix.sphero.SensorFlag;
import orbotix.sphero.SensorListener;
import orbotix.sphero.Sphero;
import oscP5.OscEventListener;
import oscP5.OscMessage;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;
import android.widget.Toast;

public class BallMoverActivity extends com.cre.BaseActivity {
	public static final String TAG = "____BallMover____";

	private RobotProvider mRobotMgr;
	private ConfigurationControl mRobotCfg;

	float mHeading = 0;
	Map<String, Sphero> mRobots = new HashMap<String, Sphero>();

	void msg(String msg) {
		Log.d(TAG, msg);
		Toast.makeText(BallMoverActivity.this, msg, Toast.LENGTH_SHORT).show();
	}

	void msgLong(String msg) {
		Log.i(TAG, msg);
		Toast.makeText(BallMoverActivity.this, msg, Toast.LENGTH_LONG).show();
	}

	public int getRemotePort() {
		return SharedConfig.OSC_PC_PORT;
	}

	public int getListenPort() {
		return SharedConfig.OSC_PAD_PORT;
	}

	// private static final int MSG_ROTATE = 0;

	protected String getAppAboutMe() {
		return "Mobile Control. Copyright： CRE Shanghai (2015 - 2015)";
	}

	// private Handler mHandler = new Handler() {
	// @Override
	// public void handleMessage(Message msg) {
	// switch (msg.what) {
	// case MSG_ROTATE:
	// for (Sphero robot : mRobots.values()) {
	// robot.rotate((mHeading += 10) % 360);
	// }
	// break;
	// }
	// }
	// };

	public void onAnswerClick(View v) {
		answerDeviceCount();
	}

	public void onStartClick(View v) {
		boolean success = mRobotMgr.startDiscovery(this);
		if (!success) {
			msgLong("Unable To start Discovery!");
		}
	}

	public void onStopClick(View v) {
		mRobotMgr.endDiscovery();
		mRobotMgr.removeAllControls();
		mRobots.clear();
	}

	public void onSleepClick(View v) {
		for (Sphero robot : mRobots.values()) {
			robot.sleep(600);
		}
		onStopClick(v);
	}
	
	public void onConfigClick(View v) {
		showInputBox(0);
	}

	public void onDestroy() {
		super.onDestroy();
		mRobotMgr.shutdown();
	}

	void answerDeviceCount() {
		sendCmd(SharedConfig.MSG_DEVICE_ANSWER, mRobots.size());
	}

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);

		// always light on
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON,
				WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

		mRobotMgr = RobotProvider.getDefaultProvider();
		mRobotMgr.addConnectionListener(new ConnectionListener() {
			@Override
			public void onConnected(Robot robot) {
				Sphero sphero = (Sphero) robot;
				if (mRobots.containsKey(sphero.getName())) {
					msgLong("onConnected again: " + sphero.getName());
				} else {
					msgLong("onConnected: " + sphero.getName());

					mRobots.put(sphero.getName(), sphero);

					// for (int i = 0; i < 3; i++) {
					// mHandler.sendEmptyMessageDelayed(MSG_ROTATE, i * 1000);
					// }
					// BallMoverActivity.this.onConnected(sphero);
				}
				answerDeviceCount();
			}

			@Override
			public void onConnectionFailed(Robot robot) {
				msg("onConnectionFailed: " + robot.getName());
				answerDeviceCount();
			}

			@Override
			public void onDisconnected(Robot robot) {
				msg("onDisconnected: " + robot.getName());
				mRobots.remove(robot.getName());
				answerDeviceCount();
			}
		});

		mRobotMgr.addDiscoveryListener(new DiscoveryListener() {
			@Override
			public void onBluetoothDisabled() {
				msg("onBluetoothDisabled");
			}

			@Override
			public void discoveryComplete(List<Sphero> spheros) {
				msg("discoveryComplete: " + spheros);
			}

			@Override
			public void onFound(List<Sphero> spheros) {
				if (false) {
					msgLong("onFound: " + spheros);
					mRobotMgr.connect(spheros.iterator().next());
				} else {
					for (Sphero sphero : spheros) {
						msgLong("onFound: " + sphero);
						mRobotMgr.control(sphero);
						// mRobotMgr.endDiscovery();
						// break;
					}
					mRobotMgr.connectControlledRobots();
					answerDeviceCount();
				}
			}
		});

		mOscServer.addListener(new OscEventListener() {
			public void oscEvent(OscMessage m) {
				if (m.checkAddress(SharedConfig.MSG_DEVICE_QUERY)) {
					answerDeviceCount();
				} else if (m.checkAddress(SharedConfig.MSG_MOVE)) {
					float heading = m.get(0).floatValue();
					float velocity = m.get(1).floatValue();
					for (Sphero robot : mRobots.values()) {
						robot.drive(heading, velocity);
					}
				}
			}
		});

	}

	/** Called when the user comes back to this app */
	@Override
	protected void onResume() {
		super.onResume();
		onStartClick(null);
	}

	/** Called when the user presses the back or home button */
	@Override
	protected void onPause() {
		super.onPause();

		onStopClick(null);
	}

	private void onConnected(Sphero robot) {
		Log.d(TAG, "Connected On Thread: " + Thread.currentThread().getName());

		final SensorControl control = robot.getSensorControl();
		control.addSensorListener(new SensorListener() {
			@Override
			public void sensorUpdated(DeviceSensorsData sensorDataArray) {
				Log.d(TAG, sensorDataArray.toString());
			}
		}, SensorFlag.ACCELEROMETER_NORMALIZED, SensorFlag.GYRO_NORMALIZED);

		control.setRate(1);
		robot.enableStabilization(false);
		robot.drive(90, 0);
		robot.setBackLEDBrightness(.5f);

		robot.getCollisionControl().startDetection(255, 255, 255, 255, 255);
		robot.getCollisionControl().addCollisionListener(
				new CollisionListener() {
					public void collisionDetected(
							CollisionDetectedAsyncData collisionData) {
						Log.d(TAG, collisionData.toString());
					}
				});

		mRobotCfg = robot.getConfiguration();
		boolean preventSleepInCharger = mRobotCfg
				.isPersistentFlagEnabled(PersistentOptionFlags.PreventSleepInCharger);
		Log.d(TAG, "Prevent Sleep in charger = " + preventSleepInCharger);
		Log.d(TAG,
				"VectorDrive = "
						+ mRobotCfg
								.isPersistentFlagEnabled(PersistentOptionFlags.EnableVectorDrive));

		mRobotCfg.setPersistentFlag(
				PersistentOptionFlags.PreventSleepInCharger, false);
		mRobotCfg.setPersistentFlag(PersistentOptionFlags.EnableVectorDrive,
				true);

		Log.d(TAG,
				"VectorDrive = "
						+ mRobotCfg
								.isPersistentFlagEnabled(PersistentOptionFlags.EnableVectorDrive));
		Log.v(TAG, mRobotCfg.toString());
	}

	@Override
	public void setLayout(int layoutId) {
		// TODO Auto-generated method stub

	}
}
