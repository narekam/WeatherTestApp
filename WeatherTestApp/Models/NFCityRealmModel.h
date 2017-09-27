//
//  NFCityExtendedModel.h
//  WeatherTestApp
//
//  Created by Narek Fidanyan on 27.9.17.
//  Copyright © 2017 Narek Fidanyan. All rights reserved.
//

#import <Realm/Realm.h>
@class CityModel;

@interface NFCityRealmModel : RLMObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *tempreture;
@property (nonatomic, retain) NSString *weatherDesc;

- (void)fetchFromCityModel:(CityModel *)city;

@end
