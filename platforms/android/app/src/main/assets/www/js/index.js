
var app = {
    // Application Constructor
    initialize: function() {
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    },

    // deviceready Event Handler
    //
    // Bind any cordova events here. Common events are:
    // 'pause', 'resume', etc.
    onDeviceReady: function() {
        this.receivedEvent('deviceready');
        this.initMetrix();
    },

    initMetrix: function () {
        Metrix.setOnAttributionChangedListener(function(attribution) {
            console.log("[MetrixExample]: Attribution callback received.");
            console.log("[MetrixExample]: acquisitionAd = " + attribution.acquisitionAd);
            console.log("[MetrixExample]: acquisitionAdSet = " + attribution.acquisitionAdSet);
            console.log("[MetrixExample]: acquisitionCampaign = " + attribution.acquisitionCampaign);
            console.log("[MetrixExample]: acquisitionSource = " + attribution.acquisitionSource);
            console.log("[MetrixExample]: attributionStatus = " + attribution.attributionStatus);
        });

        Metrix.setPushToken("token");

        Metrix.setShouldLaunchDeeplink(true);
        Metrix.setOnDeeplinkResponseListener(function(deeplink) {
            console.log("[MetrixExample]: Deeplink callback received. deeplink: " + deeplink);
        });

        var attributes = {};
        attributes['first'] = 'Ken';
        attributes['last'] = 'Adams';
        Metrix.addUserAttributes(attributes);

        var btnTrackSimpleEvent = document.getElementById("btnSendEvent");
        var btnTrackFeaturedEvent = document.getElementById("btnSendEventWithAttributes");
        
        var btnSendSimpleRevenue = document.getElementById("btnSendSimpleRevenue");
        var btnSendFullRevenue = document.getElementById("btnSendFullRevenue");
        
        btnTrackSimpleEvent.addEventListener('click', function() {
            Metrix.newEvent("nkrza")
        }, false);

        btnTrackFeaturedEvent.addEventListener('click', function() {
            var attributes = {};
            attributes['first_name'] = 'Ali';
            attributes['last_name'] = 'Bagheri';
            attributes['manufacturer'] = 'Nike';
            attributes['product_name'] = 'shirt';
            attributes['type'] = 'sport';
            attributes['size'] = 'large';
            Metrix.newEvent("qqwnq", attributes)
        }, false);

        btnSendSimpleRevenue.addEventListener('click', function() {
            Metrix.newRevenue('ftlrc', 3200.55);
        }, false);

        btnSendFullRevenue.addEventListener('click', function() {
            Metrix.newRevenue('zpfll', 35500.155, 0, '150');
        }, false);

        var sessionNum = document.getElementById("sessionNum");
        var sessionId = document.getElementById("sessionId");

        Metrix.setSessionIdListener(function(id) {
            sessionId.innerHTML = "Session id is: " + id
        });

        Metrix.setSessionNumberListener(function(num) {
            sessionNum.innerHTML = "Session number is: " + num
        });

        var userId = document.getElementById("userId");

        Metrix.setUserIdListener(function(metrixUserId) {
            userId.innerHTML = "User id is: " + metrixUserId
        });
    },

    // Update DOM on a Received Event
    receivedEvent: function(id) {
        console.log('[MetrixExample]: Received Event: ' + id);

        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');
    }
};

app.initialize();