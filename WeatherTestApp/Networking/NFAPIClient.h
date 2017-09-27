//
//  NFAPIClient.h
//  WeatherTestApp
//
//  Created by Narek Fidanyan on 27.9.17.
//  Copyright © 2017 Narek Fidanyan. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface NFAPIClient : AFHTTPSessionManager

+ (instancetype)clientWithBaseURL:(NSString *)urlString;

@end
