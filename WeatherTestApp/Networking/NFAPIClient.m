//
//  NFAPIClient.m
//  WeatherTestApp
//
//  Created by Narek Fidanyan on 27.9.17.
//  Copyright © 2017 Narek Fidanyan. All rights reserved.
//

#import "NFAPIClient.h"

@implementation NFAPIClient

static NSMutableDictionary *clients = nil;

+ (instancetype)clientWithBaseURL:(NSString *)urlString {
    // Check params
    if (!urlString) {
        return nil;
    }
    
    // Initiate clients dic
    if (!clients) {
        clients = [NSMutableDictionary dictionary];
    }
    
    NFAPIClient *client = clients[urlString];
    if (!client) {
        // Setup client
        client = [[NFAPIClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
        
        client.requestSerializer = [AFJSONRequestSerializer serializer];
        [client.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        client.responseSerializer = [AFJSONResponseSerializer serializer];
        
        // Keep client for future use
        [clients setObject:client forKey:urlString];
    }
    
    return client;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(nullable id)parameters
     constructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData> _Nonnull))block
                      progress:(void (^)(NSProgress *_Nonnull))downloadProgress
                       success:(void (^)(NSURLSessionDataTask *, id))success
                       failure:(nullable void (^)(NSURLSessionDataTask *_Nullable, NSError *_Nonnull))failure {
    
    NSLog(@"\n>>>>\nRequest: %s\nParams: %s\nRequest Date:%s\n>>>>\n",[[self.baseURL description] UTF8String],[[parameters description] UTF8String],[[[NSDate date] description] UTF8String]);
    
    
    NSURLSessionDataTask *task = [super POST:URLString
                                  parameters:parameters
                   constructingBodyWithBlock:block
                                    progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                                     success:^(NSURLSessionDataTask *operation, id responseObject) {

                                         NSHTTPURLResponse *response = ((NSHTTPURLResponse *)[operation response]);
                                         NSDictionary *headers = [response allHeaderFields];
                                         NSLog(@"RESPONSE HEADERS %@", headers);
                                                                                  
                                         NSLog(@"\n<<<<\nResponse: %s\nParams: %s\nResponse Date:%s\n<<<<\n",[[operation.originalRequest.URL description] UTF8String],[[parameters description] UTF8String],[[[NSDate date] description] UTF8String]);
                                         
                                         
                                         if (success) {
                                             success(task, responseObject);
                                         }
                                     } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                                         NSLog(@"\n<<<<\nResponse: %s\nParams: %s\nResponse Date:%s\n<<<<\n",[[operation.originalRequest.URL description] UTF8String],[[parameters description] UTF8String],[[[NSDate date] description] UTF8String]);
                                         failure (operation, error);
                                     }];
    
    return task;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(nullable id)parameters
                     progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                      success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    
    NSLog(@"\n>>>>\nRequest: %s\nParams: %s\nRequest Date:%s\n>>>>\n",[[self.baseURL description] UTF8String],[[parameters description] UTF8String],[[[NSDate date] description] UTF8String]);
    
    NSURLSessionDataTask *task = [super GET:URLString
                                 parameters:parameters
                                   progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        
                                        NSHTTPURLResponse *response = ((NSHTTPURLResponse *)[task response]);
                                        NSDictionary *headers = [response allHeaderFields];
                                        NSLog(@"RESPONSE HEADERS %@", headers);

                                        if (success) {
                                            success(task, responseObject);
                                        }
                                    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                                        NSLog(@"\n<<<<\nResponse: %s\nParams: %s\nResponse Date:%s\n<<<<\n",[[operation.originalRequest.URL description] UTF8String],[[parameters description] UTF8String],[[[NSDate date] description] UTF8String]);
                                        failure(operation, error);
                                    }];
    
    return task;
}

@end
