//
//  NFDatabaseManager.h
//  WeatherTestApp
//
//  Created by Narek Fidanyan on 27.9.17.
//  Copyright © 2017 Narek Fidanyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFCityRealmModel.h"

@interface NFDatabaseManager : NSObject

+ (NFDatabaseManager *)sharedInstance;

- (void)addCity:(NFCityRealmModel*)city;
- (void)cleanDB;

@end
