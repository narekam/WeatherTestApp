//
//  CityModel.m
//  WeatherTestApp
//
//  Created by Narek Fidanyan on 27.9.17.
//  Copyright © 2017 Narek Fidanyan. All rights reserved.
//

#import "CityModel.h"
#import "NFCityRealmModel.h"

@implementation CityModel

- (void)fetchFromRealmCityModel:(NFCityRealmModel *)RLMcity {
    self.currentTemp = RLMcity.tempreture;
    self.currentWeatherDesc = RLMcity.weatherDesc;
}

@end
