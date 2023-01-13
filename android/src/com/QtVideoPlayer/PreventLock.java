package com.QtVideoPlayer;
import org.qtproject.qt.android.bindings.QtActivity;
import android.os.Bundle;
import android.util.Log;

public class PreventLock extends QtActivity {

    public static int counter = 0;
    public int id;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        this.id = counter;
        Log.d("Something", "Created PreventLockJavaClass object with id: " + this.id);
        counter++;
        super.onCreate(savedInstanceState);
    }

    public void preventLock(boolean flag) {
        setTurnScreenOn(flag);
        Log.d("Something", "State changed to: " + flag);
    }

    public String sayHello() {
        return "NativePickerJavaClass object number: " + id + " say hello :)";
    }

    public static double multiply(double a, double b) {
        return  a * b;
    }
}
