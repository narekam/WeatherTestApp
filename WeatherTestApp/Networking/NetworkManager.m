//
//  NetworkManager.m
//  WeatherTestApp
//
//  Created by Narek Fidanyan on 27.9.17.
//  Copyright © 2017 Narek Fidanyan. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworking.h"

#import "NFAPIClient.h"

@implementation NetworkManager

static NSString *BaseURL = @"https://api.openweathermap.org/data/2.5";
static NSString *APIKey = @"2c255e685acf51a6fbd9a0b4588bdbc9";



+ (NetworkManager *)sharedManager {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

#pragma mark - GET calls

//  http://api.openweathermap.org/data/2.5/weather?q=London&APPID=1111111111

- (NSURLSessionDataTask *)getWeatherForCity:(CityModel *)city withCompletion:(void (^) (id responseDict, NSData *responseData, NSError *error))completionBlock {
    NFAPIClient *client = [NFAPIClient clientWithBaseURL:BaseURL];
    
    NSDictionary *params = @{
                             @"q" : city.name,
                             @"APPID" : APIKey
                             };
    
    return [client GET:@"weather" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"Download Progres: %@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionBlock(responseObject, nil, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionBlock(nil, nil, error);
    }];
}

@end
