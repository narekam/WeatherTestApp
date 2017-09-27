//
//  NetworkManager.h
//  WeatherTestApp
//
//  Created by Narek Fidanyan on 27.9.17.
//  Copyright © 2017 Narek Fidanyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityModel.h"

@interface NetworkManager : NSObject
+ (NetworkManager *)sharedManager;

// GET calls
- (NSURLSessionDataTask *)getWeatherForCity:(CityModel *)city withCompletion:(void (^) (id responseDic, NSData *responseData, NSError *error))completionBlock;

@end
