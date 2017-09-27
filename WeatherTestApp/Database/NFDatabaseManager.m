//
//  NFDatabaseManager.m
//  WeatherTestApp
//
//  Created by Narek Fidanyan on 27.9.17.
//  Copyright © 2017 Narek Fidanyan. All rights reserved.
//

#import "NFDatabaseManager.h"
#import <Realm/Realm.h>

@interface NFDatabaseManager() {
    RLMRealm *_realm;
}

@end

@implementation NFDatabaseManager

+ (NFDatabaseManager *)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _realm = [RLMRealm defaultRealm];
}

#pragma mark - Methods
- (void)addCity:(NFCityRealmModel*)city {
    [_realm beginWriteTransaction];
    [_realm addOrUpdateObject:city];
    [_realm commitWriteTransaction];
}

- (void)cleanDB {
    [_realm beginWriteTransaction];
    [_realm deleteAllObjects];
    [_realm commitWriteTransaction];
}

@end
