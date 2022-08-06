package ir.metrix.cordova;

import java.util.Map;
import java.util.HashMap;
import java.util.Iterator;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;
import ir.metrix.AttributionData;

public class MetrixCordovaUtils {
    // iOS only
    public static final String COMMAND_INITIALIZE = "initialize";
    public static final String COMMAND_SET_STORE = "seStore";
    public static final String COMMAND_SET_APP_SECRET = "setAppSecret";
    public static final String COMMAND_SET_DEFAULT_TRACKER = "setDefaultTracker";

    public static final String COMMAND_SET_PUSH_TOKEN = "setPushToken";
    public static final String COMMAND_SET_ATTRIBUTION_CHANGE_LISTENER = "setAttributionChangeListener";
    public static final String COMMAND_GET_SESSION_NUMBER = "setSessionNumberListener";
    public static final String COMMAND_TRACK_SIMPLE_EVENT = "trackSimpleEvent";
    public static final String COMMAND_TRACK_CUSTOM_EVENT = "trackCustomEvent";
    public static final String COMMAND_TRACK_FULL_REVENUE = "trackFullRevenue";
    public static final String COMMAND_TRACK_SIMPLE_REVENUE = "trackSimpleRevenue";
    public static final String COMMAND_ADD_USER_DEFAULT_ATTRIBUTES = "addUserDefaultAttributes";
    public static final String COMMAND_SET_DEEPLINK_RESPONSE_CALLBACK = "setDeeplinkResponseListener";
    public static final String COMMAND_SET_USER_ID_LISTENER = "setUserIdListener";
    public static final String COMMAND_GET_SESSION_ID = "setSessionIdListener";
    public static final String COMMAND_SET_SHOULD_LAUNCH_DEEPLINK = "setShouldLaunchDeeplink";

    public static Map<String, String> jsonObjectToStringMap(JSONObject jsonObject) throws JSONException {
        Map<String, String> map = new HashMap<String, String>(jsonObject.length());
        @SuppressWarnings("unchecked")
        Iterator<String> jsonObjectIterator = jsonObject.keys();

        while (jsonObjectIterator.hasNext()) {
            String key = jsonObjectIterator.next();
            map.put(key, jsonObject.get(key).toString());
        }

        return map;
    }

    public static Map<String, String> getAttributionMap(AttributionData AttributionData) {
        Map<String, String> map = new HashMap<String, String>();
        if (AttributionData.getAcquisitionAd() != null) {
            map.put("acquisitionAd", AttributionData.getAcquisitionAd());
        }
        if (AttributionData.getAcquisitionAdSet() != null) {
            map.put("acquisitionAdSet", AttributionData.getAcquisitionAdSet());
        }
        if (AttributionData.getAcquisitionCampaign() != null) {
            map.put("acquisitionCampaign ", AttributionData.getAcquisitionCampaign());
        }
        if (AttributionData.getAcquisitionSource() != null) {
            map.put("acquisitionSource", AttributionData.getAcquisitionSource());
        }
        if (AttributionData.getAcquisitionSubId() != null) {
            map.put("acquisitionSubId", AttributionData.getAcquisitionSubId());
        }
        if (AttributionData.getAttributionStatus() != null) {
            map.put("attributionStatus", AttributionData.getAttributionStatus().name());
        }

        return map;
    }
}