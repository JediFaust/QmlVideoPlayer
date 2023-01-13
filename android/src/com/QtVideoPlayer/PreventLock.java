package com.QtVideoPlayer;
import org.qtproject.qt.android.bindings.QtActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.WindowManager;
import android.app.Activity;

public class PreventLock extends QtActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    public void preventLock(boolean flag) {
        runOnUiThread(() -> {
            if (flag) { getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON); }
            else { getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON); }
        });

        Log.d("JavaLog", "LockFlag changed to: " + flag);
    }
}


