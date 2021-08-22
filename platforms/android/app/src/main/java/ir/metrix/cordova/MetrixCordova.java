package ir.metrix.cordova;

import java.util.Map;
import android.net.Uri;
import android.util.Log;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.apache.cordova.PluginResult.Status;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.os.Bundle;
import android.app.Application;
import static ir.metrix.cordova.MetrixCordovaUtils.*;
import ir.metrix.AttributionData;
import ir.metrix.messaging.RevenueCurrency;

public class MetrixCordova extends CordovaPlugin {

    private boolean shouldLaunchDeeplink = true;
    private CallbackContext attributionCallbackContext;
    private CallbackContext deeplinkCallbackContext;
    private CallbackContext userIdCallbackContext;
    private CallbackContext getSessionNumCallbackContext;
    private CallbackContext getSessionIdCallbackContext;

    @Override
    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
        if (action.equals(COMMAND_SET_ATTRIBUTION_CHANGE_LISTENER)) {
            attributionCallbackContext = callbackContext;
            setAttributionListener();
        } else if (action.equals(COMMAND_SET_PUSH_TOKEN)) {
            String token = args.getString(0);
            ir.metrix.Metrix.setPushToken(token);
        } else if (action.equals(COMMAND_GET_SESSION_NUMBER)) {
            getSessionNumCallbackContext = callbackContext;
            getSessionNum();
        } else if (action.equals(COMMAND_TRACK_SIMPLE_EVENT)) {
            String slug = args.getString(0);
            ir.metrix.Metrix.newEvent(slug);
        } else if (action.equals(COMMAND_TRACK_CUSTOM_EVENT)) {
            sendCustomEvent(args);
        } else if (action.equals(COMMAND_TRACK_SIMPLE_REVENUE)) {
            trackSimpleRevenue(args);
        } else if (action.equals(COMMAND_TRACK_FULL_REVENUE)) {
            trackFullRevenue(args);
        } else if (action.equals(COMMAND_SET_DEEPLINK_RESPONSE_CALLBACK)) {
            deeplinkCallbackContext = callbackContext;
            setDeeplinkListener();
        } else if (action.equals(COMMAND_ADD_USER_DEFAULT_ATTRIBUTES)) {
            addUserAttributes(args);
        } else if (action.equals(COMMAND_SET_USER_ID_LISTENER)) {
            userIdCallbackContext = callbackContext;
            setUserIdListener();
        } else if (action.equals(COMMAND_GET_SESSION_ID)) {
            getSessionIdCallbackContext = callbackContext;
            getSessionId();
        } else if (action.equals(COMMAND_SET_SHOULD_LAUNCH_DEEPLINK)) {
            shouldLaunchDeeplink = args.getBoolean(0);
        } else {
            callbackContext.error("\"" + action + "\" is not a recognized action.");
            return false;
        }
        return true;
    }

    private void getSessionNum() {
        if (getSessionNumCallbackContext != null) {
            final int sessionNum = ir.metrix.Metrix.getSessionNum();
            PluginResult pluginResult = new PluginResult(Status.OK, sessionNum);
            pluginResult.setKeepCallback(true);
            getSessionNumCallbackContext.sendPluginResult(pluginResult);
        }
    }

    private void getSessionId() {
        if (getSessionIdCallbackContext != null) {
            final String sessionId = ir.metrix.Metrix.getSessionId();
            PluginResult pluginResult = new PluginResult(Status.OK, sessionId);
            pluginResult.setKeepCallback(true);
            getSessionIdCallbackContext.sendPluginResult(pluginResult);
        }
    }
 
    private void setAttributionListener() {
        if (attributionCallbackContext != null) {
            ir.metrix.Metrix.setOnAttributionChangedListener(new ir.metrix.OnAttributionChangeListener() {
                @Override
                public void onAttributionChanged(AttributionData attributionData) {
                    JSONObject attributionJsonData = new JSONObject(getAttributionMap(attributionData));
                    PluginResult pluginResult = new PluginResult(Status.OK, attributionJsonData);
                    pluginResult.setKeepCallback(true);
                    attributionCallbackContext.sendPluginResult(pluginResult);
                }
            });
        }
    }
 
    private void setUserIdListener() {
        if (userIdCallbackContext != null) {
            ir.metrix.Metrix.setUserIdListener(new ir.metrix.UserIdListener() {
                @Override
                public void onUserIdReceived(String metrixUserId) {
                    PluginResult pluginResult = new PluginResult(Status.OK, metrixUserId);
                    pluginResult.setKeepCallback(true);
                    userIdCallbackContext.sendPluginResult(pluginResult);
                }
            });
        }
    }
 
    private void setDeeplinkListener() {
        if (deeplinkCallbackContext != null) {
            ir.metrix.Metrix.setOnDeeplinkResponseListener(new ir.metrix.OnDeeplinkResponseListener() {
                @Override
                public boolean launchReceivedDeeplink(Uri deeplink) {
                    PluginResult pluginResult = new PluginResult(Status.OK, deeplink.toString());
                    pluginResult.setKeepCallback(true);
                    deeplinkCallbackContext.sendPluginResult(pluginResult);

                    return MetrixCordova.this.shouldLaunchDeeplink;
                }
            });
        }
    }
 
    private void sendCustomEvent(final JSONArray args) throws JSONException {
        String slug = args.getString(0);
        String attributesJson = args.getString(1);
        Map<String, String> attributes = jsonObjectToStringMap(new JSONObject(attributesJson));
        ir.metrix.Metrix.newEvent(slug, attributes);
    }

    private void addUserAttributes(final JSONArray args) throws JSONException {
        String attributesJson = args.getString(0);
        Map<String, String> attributes = jsonObjectToStringMap(new JSONObject(attributesJson));
        ir.metrix.Metrix.addUserAttributes(attributes);
    }

    private void trackSimpleRevenue(final JSONArray args) throws JSONException {
        String slug = args.getString(0);
        Double amount = args.getDouble(1);
        RevenueCurrency currency = RevenueCurrency.valueOf(args.getString(2));
        ir.metrix.Metrix.newRevenue(slug, amount, currency);
    }

    private void trackFullRevenue(final JSONArray args) throws JSONException {
        String slug = args.getString(0);
        Double amount = args.getDouble(1);
        RevenueCurrency currency = RevenueCurrency.valueOf(args.getString(2));
        String orderId = args.getString(3);
        ir.metrix.Metrix.newRevenue(slug, amount, currency, orderId);
    }
}