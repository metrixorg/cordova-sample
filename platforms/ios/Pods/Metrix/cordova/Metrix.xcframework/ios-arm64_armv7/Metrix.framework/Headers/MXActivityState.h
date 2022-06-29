//
//  MXActivityState.h
//  Metrix
//
//  Created by Matin on 8/2/21.
//  Copyright © 2021 Metrix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXActivityState : NSObject <NSCoding>

@property (nonatomic, assign) int sessionCount;
@property (nonatomic, copy) NSString *userId;

@end
