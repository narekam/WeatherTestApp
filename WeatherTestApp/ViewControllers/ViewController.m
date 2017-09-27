//
//  ViewController.m
//  WeatherTestApp
//
//  Created by Narek Fidanyan on 27.9.17.
//  Copyright © 2017 Narek Fidanyan. All rights reserved.
//

#import "ViewController.h"
#import "CityModel.h"
#import "NetworkManager.h"
#import "NFDatabaseManager.h"
#import "NFCityRealmModel.h"

@interface ViewController () <UITextViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    CGFloat textViewSmallModeMultiplier;
    CGFloat textViewBigModeMultiplier;
    
    BOOL isTextViewBig;
    
    NSArray <CityModel *>*citiesDataSource;
    CityModel *tempCityForDequeue;
}

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init some vars
    textViewSmallModeMultiplier = 0.33f;
    textViewBigModeMultiplier = 0.66f;
    
    
    //
    citiesDataSource = [self parseDataFromJSON];
    [self.tableView reloadData];
    
    [self makeTextViewBigger:NO animated:NO];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource and related
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return citiesDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indentifier = @"CityTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    tempCityForDequeue = citiesDataSource[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", tempCityForDequeue.name, tempCityForDequeue.countryCode];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CityModel *tempCity = citiesDataSource[indexPath.row];
    [self displayCityInfo:tempCity];
    
    // Try to get city from DB
    NFCityRealmModel *RLMCity = [self getCityFromDB:tempCity];
    if (RLMCity) {
        [tempCity fetchFromRealmCityModel:RLMCity];
        [self displayCityInfo:tempCity];
    } else {
        // Get weather from net
        [[NetworkManager sharedManager] getWeatherForCity:tempCity withCompletion:^(id responseDict, NSData *responseData, NSError *error) {
            
            NSNumber *tempNumberValue = responseDict[@"main"][@"temp"];
            NSString *currentTemp = [NSString stringWithFormat:@"%@", tempNumberValue];
            
            NSArray *weatherArray = responseDict[@"weather"];
            NSString *currentWeatherDesc = weatherArray.firstObject[@"description"];
            
            tempCity.currentTemp = currentTemp;
            tempCity.currentWeatherDesc = currentWeatherDesc;
            
            [self displayCityInfo:tempCity];
            
            // Save in DB
            NFCityRealmModel *cityRlmModel = [NFCityRealmModel new];
            [cityRlmModel fetchFromCityModel:tempCity];
            [[NFDatabaseManager sharedInstance] addCity:cityRlmModel];
        }];
    }
}

- (NFCityRealmModel *)getCityFromDB:(CityModel *)city {
    NFCityRealmModel *RLMCity = [[NFCityRealmModel objectsWhere:@"name == %@", city.name] firstObject];
    return RLMCity;
}

- (void)displayCityInfo:(CityModel *)city {
    NSString *textViewText;
    
    if (city.currentTemp && city.currentWeatherDesc) {
        textViewText = [NSString stringWithFormat:@"%@, %@\n\nWeather - %@(F), %@\n\n%@", city.name, city.countryCode, city.currentTemp, city.currentWeatherDesc, city.desc];
    } else {
        textViewText = [NSString stringWithFormat:@"%@, %@\n\n%@", city.name, city.countryCode, city.desc];
    }
    
    self.textView.text = textViewText;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self makeTextViewBigger:!isTextViewBig animated:YES];
    
    return NO;
}

#pragma mark - Animation
- (void)makeTextViewBigger:(BOOL)bigger animated:(BOOL)animated {
    self.textView.userInteractionEnabled = NO;
    
    CGFloat multiplier = bigger ? textViewBigModeMultiplier : textViewSmallModeMultiplier;
    self.textViewHeightConstraint.constant = multiplier * self.view.frame.size.height;
    
    [UIView animateWithDuration:animated ? 0.3 : 0
                     animations:^{
                         [self.view layoutIfNeeded];
    }
                     completion:^(BOOL finished) {
                         isTextViewBig = bigger;
                         self.textView.userInteractionEnabled = YES;
    }];
}

#pragma mark - Other methods
- (NSArray *)parseDataFromJSON {
    NSArray *tempArray = [NSArray new];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *citiesDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    tempArray = [CityModel arrayOfModelsFromDictionaries:citiesDict[@"cities"] error:nil];
    
    return tempArray;
}

@end
