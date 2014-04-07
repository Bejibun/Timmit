//
//  MainViewController.h
//  Project1
//
//  Created by Frans Kurniawan on 2/23/14.
//  Copyright (c) 2014 Frans Kurniawan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "JsonData.h"

@interface MainViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    JsonData *jsonData;
}


@property (strong, nonatomic) IBOutlet UIButton *taxBtn;
@property (strong, nonatomic) IBOutlet UIButton *tipBtn;
@property (strong, nonatomic) IBOutlet UIButton *discBtn;
@property (strong, nonatomic) IBOutlet UIButton *totalBtn;
@property (strong, nonatomic) IBOutlet UIButton *tenPercent;
@property (strong, nonatomic) IBOutlet UIButton *fifteenPercent;
@property (strong, nonatomic) IBOutlet UIButton *eighteenPercent;


@property (strong, nonatomic) IBOutlet UIView *tipView;
@property (strong, nonatomic) IBOutlet UIView *discView;

@property (strong, nonatomic) IBOutlet UIPickerView *itemPicker;

@property (strong, nonatomic) NSArray *itemListArr;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *taxView;
@property (strong, nonatomic) IBOutlet UIView *locationView;


@property (strong, nonatomic) IBOutlet UILabel *item1;
@property (strong, nonatomic) IBOutlet UILabel *item2;
@property (strong, nonatomic) IBOutlet UILabel *item3;
@property (strong, nonatomic) IBOutlet UILabel *item4;
@property (strong, nonatomic) IBOutlet UILabel *item5;
@property (strong, nonatomic) IBOutlet UILabel *item6;

@property (strong, nonatomic) IBOutlet UITextField *item1Text;
@property (strong, nonatomic) IBOutlet UITextField *item2Text;
@property (strong, nonatomic) IBOutlet UITextField *item3Text;
@property (strong, nonatomic) IBOutlet UITextField *item4Text;
@property (strong, nonatomic) IBOutlet UITextField *item5Text;
@property (strong, nonatomic) IBOutlet UITextField *item6Text;
@property (strong, nonatomic) IBOutlet UITextField *totalResult;

@property (strong, nonatomic) IBOutlet UITextField *digitState;

@property (strong, nonatomic) IBOutlet UITextField *totalPeople;
@property (strong, nonatomic) IBOutlet UITextField *totalNoTax;
@property (strong, nonatomic) IBOutlet UITextField *totalWithTax;
@property (strong, nonatomic) IBOutlet UITextField *tipAmount;
@property (strong, nonatomic) IBOutlet UITextField *finalAmount;

@property (strong, nonatomic) JsonData *jsonData;

//location
@property (strong, nonatomic) IBOutlet UITextField *latitude;
@property (strong, nonatomic) IBOutlet UITextField *longitude;
@property (strong, nonatomic) IBOutlet UITextView *addressTextField;


- (IBAction)taxBtnClicked:(id)sender;
- (IBAction)tipBtnClicked:(id)sender;
- (IBAction)totalBtnClicked:(id)sender;
- (IBAction)tenClicked:(id)sender;
- (IBAction)fifteenClicked:(id)sender;
- (IBAction)eighteenClicked:(id)sender;
- (IBAction)getCurrentLocation:(id)sender;
- (IBAction)resetCurrentLocation:(id)sender;


- (NSMutableArray *)parseJSONStates;
- (NSMutableArray *)parseJSONSalesTax;
- (NSMutableArray *)parseJSONAdminArea;
- (BOOL)validateItem:(NSString *) itemValue;
- (BOOL)validateState:(NSString *) stateValue;

@end
