//
//  MetrixCordova.h
//  Metrix SDK
//
//  Created by Matin on 21th June 2022.
//

#import <Cordova/CDV.h>

@interface MetrixCordova : CDVPlugin

- (void)initialize:(CDVInvokedUrlCommand *)command;
- (void)setStore:(CDVInvokedUrlCommand *)command;
- (void)setDefaultTracker:(CDVInvokedUrlCommand *)command;
- (void)setAppSecret:(CDVInvokedUrlCommand *)command;

- (void)trackSimpleEvent:(CDVInvokedUrlCommand *)command;
- (void)trackCustomEvent:(CDVInvokedUrlCommand *)command;
- (void)trackSimpleRevenue:(CDVInvokedUrlCommand *)command;
- (void)setAttributionChangeListener:(CDVInvokedUrlCommand *)command;
- (void)setSessionNumberListener:(CDVInvokedUrlCommand *)command;
- (void)setSessionIdListener:(CDVInvokedUrlCommand *)command;
- (void)setUserIdListener:(CDVInvokedUrlCommand *)command;

- (void)setPushToken:(CDVInvokedUrlCommand *)command;
- (void)setShouldLaunchDeeplink:(CDVInvokedUrlCommand *)command;
- (void)setDeeplinkResponseListener:(CDVInvokedUrlCommand *)command;

@end

@import Metrix;

@implementation MetrixCordova

NSString* attributionCallbackId;
NSString* sessionIdCallbackId;
NSString* sessionNumberCallbackId;
NSString* userIdCallbackId;

- (void)initialize:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* appId = [command.arguments objectAtIndex:0];

    if (appId != nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [MetrixClient initializeWithMetrixAppId:appId];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"AppId was null"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setStore:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* store = [command.arguments objectAtIndex:0];

    if (store != nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [MetrixClient setStoreWithStoreName:store];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Store was null"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setDefaultTracker:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* token = [command.arguments objectAtIndex:0];

    if (token != nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [MetrixClient setDefaultTrackerWithTrackerToken:token];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Tracker token was null"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setAppSecret:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSNumber* secretId = [command.arguments objectAtIndex:0];
    NSNumber* info1 = [command.arguments objectAtIndex:1];
    NSNumber* info2 = [command.arguments objectAtIndex:2];
    NSNumber* info3 = [command.arguments objectAtIndex:3];
    NSNumber* info4 = [command.arguments objectAtIndex:4];

    if (secretId != nil && info1 != nil && info2 != nil && info3 != nil && info4 != nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [MetrixClient setAppSecretWithSecretId:[secretId integerValue] info1:[info1 integerValue] info2:[info2 integerValue] info3:[info3 integerValue] info4:[info4 integerValue]];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Null app secret info was received"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)trackSimpleEvent:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* slug = [command.arguments objectAtIndex:0];

    if (slug != nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [MetrixClient newEventWithSlug:slug];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"slug was null"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)trackCustomEvent:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* slug = [command.arguments objectAtIndex:0];
    NSDictionary * attributes  = [command.arguments objectAtIndex:1];

    if (slug != nil && attributes != nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [MetrixClient newEventWithSlug:slug attributes:attributes];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"slug was null"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)addUserDefaultAttributes:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSDictionary * attributes  = [command.arguments objectAtIndex:0];

    if (attributes != nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [MetrixClient addUserAttributesWithUserAttrs:attributes];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"slug was null"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)trackSimpleRevenue:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* slug = [command.arguments objectAtIndex:0];
    NSNumber* amount  = [command.arguments objectAtIndex:1];
    NSString* currency = [command.arguments objectAtIndex:2];

    int cr = RevenueCurrencyIRR;
    if ([currency  isEqual: @"USD"]) {
        cr = RevenueCurrencyUSD;
    } else if ([currency  isEqual: @"EUR"]) {
        cr = RevenueCurrencyEUR;
    }
    
    if (slug != nil && amount != nil && currency != nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [MetrixClient newRevenueWithSlug:slug revenue:[amount doubleValue] currency:cr];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Null parameter was recieved"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)trackFullRevenue:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* slug = [command.arguments objectAtIndex:0];
    NSNumber* amount  = [command.arguments objectAtIndex:1];
    NSString* currency = [command.arguments objectAtIndex:2];
    NSString* orderId = [command.arguments objectAtIndex:3];

    int cr = RevenueCurrencyIRR;
    if ([currency  isEqual: @"USD"]) {
        cr = RevenueCurrencyUSD;
    } else if ([currency  isEqual: @"EUR"]) {
        cr = RevenueCurrencyEUR;
    }
    
    if (slug != nil && amount != nil && currency != nil && orderId != nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [MetrixClient newRevenueWithSlug:slug revenue:[amount doubleValue] currency:cr orderId:orderId];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Null parameter was recieved"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setAttributionChangeListener:(CDVInvokedUrlCommand*)command
{
    attributionCallbackId = command.callbackId;
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    
    [MetrixClient setOnAttributionChangedListener:^(AttributionData *data) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:[self getAttributionInfoObject:data]];
        if ([data.attributionStatusRaw  isEqual: @"NOT_ATTRIBUTED_YET"]) {
            [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        } else {
            [pluginResult setKeepCallback:[NSNumber numberWithBool:NO]];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:attributionCallbackId];
    }];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setSessionNumberListener:(CDVInvokedUrlCommand*)command
{
    sessionNumberCallbackId = command.callbackId;
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    
    [MetrixClient setSessionNumberListener:^(NSInteger num) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:(int)num];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:sessionNumberCallbackId];
    }];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setSessionIdListener:(CDVInvokedUrlCommand*)command
{
    sessionIdCallbackId = command.callbackId;
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    
    [MetrixClient setSessionIdListener:^(NSString* sessionId) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:sessionId];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:sessionIdCallbackId];
    }];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setUserIdListener:(CDVInvokedUrlCommand*)command
{
    userIdCallbackId = command.callbackId;
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    
    [MetrixClient setUserIdListener:^(NSString* userId) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:userId];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:userIdCallbackId];
    }];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (NSDictionary *)getAttributionInfoObject:(AttributionData *)data {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [self addValueOrEmpty:dictionary key:@"trackerToken" value:data.trackerToken];
    [self addValueOrEmpty:dictionary key:@"acquisitionAd" value:data.acquisitionAd];
    [self addValueOrEmpty:dictionary key:@"acquisitionAdSet" value:data.acquisitionAdSet];
    [self addValueOrEmpty:dictionary key:@"acquisitionCampaign" value:data.acquisitionCampaign];
    [self addValueOrEmpty:dictionary key:@"acquisitionSource" value:data.acquisitionSource];
    [self addValueOrEmpty:dictionary key:@"acquisitionSubId" value:data.acquisitionSubId];
    [self addValueOrEmpty:dictionary key:@"attributionStatus" value:data.attributionStatusRaw];
    
    return dictionary;;
}

- (void)addValueOrEmpty:(NSMutableDictionary *)dictionary
                    key:(NSString *)key
                  value:(NSObject *)value {
    if (nil != value) {
        [dictionary setObject:[NSString stringWithFormat:@"%@", value] forKey:key];
    } else {
        [dictionary setObject:@"" forKey:key];
    }
}

// Android specific methods (ignored)
- (void)setPushToken:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

// Android specific methods (ignored)
- (void)setShouldLaunchDeeplink:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

// Android specific methods (ignored)
- (void)setDeeplinkResponseListener:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end