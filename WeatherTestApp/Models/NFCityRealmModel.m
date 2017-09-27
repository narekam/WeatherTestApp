//
//  NFCityExtendedModel.m
//  WeatherTestApp
//
//  Created by Narek Fidanyan on 27.9.17.
//  Copyright © 2017 Narek Fidanyan. All rights reserved.
//

#import "NFCityRealmModel.h"
#import "CityModel.h"

@implementation NFCityRealmModel

+ (NSString *)primaryKey {
    return @"name";
}

- (void)fetchFromCityModel:(CityModel *)city {
    self.name = city.name;
    self.tempreture = city.currentTemp;
    self.weatherDesc = city.currentWeatherDesc;
}

@end
