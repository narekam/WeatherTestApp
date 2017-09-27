//
//  CityModel.h
//  WeatherTestApp
//
//  Created by Narek Fidanyan on 27.9.17.
//  Copyright © 2017 Narek Fidanyan. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@class NFCityRealmModel;

@interface CityModel : JSONModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *countryCode;
@property (strong, nonatomic) NSString *desc;

@property (strong, nonatomic) NSString <Optional>*currentTemp;
@property (strong, nonatomic) NSString <Optional>*currentWeatherDesc;

- (void)fetchFromRealmCityModel:(NFCityRealmModel *)RLMcity;

@end

