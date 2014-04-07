//
//  MainViewController.m
//  Project1
//
//  Created by Frans Kurniawan on 2/23/14.
//  Copyright (c) 2014 Frans Kurniawan. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize taxBtn,tipBtn,discBtn,taxView,tipView,discView,itemPicker,itemListArr,scrollView,item1,item2,item3,item4,item5,item6,item1Text,item2Text,item3Text,item4Text,item5Text,item6Text,totalBtn,totalResult,jsonData,digitState,totalNoTax,totalWithTax,totalPeople,tenPercent,eighteenPercent,fifteenPercent,tipAmount,finalAmount,latitude,longitude,addressTextField,locationView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Ez-Cal";
    taxBtn.layer.cornerRadius = 6;
    tipBtn.layer.cornerRadius = 6;
    discBtn.layer.cornerRadius = 6;
    totalBtn.layer.cornerRadius = 6;
    [[taxBtn layer] setBorderWidth:2.0f];
    [[taxBtn layer] setBorderColor:[UIColor blueColor].CGColor];
    [[tipBtn layer] setBorderWidth:2.0f];
    [[tipBtn layer] setBorderColor:[UIColor blueColor].CGColor];
    [[discBtn layer] setBorderWidth:2.0f];
    [[discBtn layer] setBorderColor:[UIColor blueColor].CGColor];
    [[totalBtn layer] setBorderWidth:1.0f];
    [[totalBtn layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [[tenPercent layer] setBorderWidth:1.0f];
    [[tenPercent layer] setBorderColor:[UIColor blueColor].CGColor];
    [[fifteenPercent layer] setBorderWidth:1.0f];
    [[fifteenPercent layer] setBorderColor:[UIColor blueColor].CGColor];
    [[eighteenPercent layer] setBorderWidth:1.0f];
    [[eighteenPercent layer] setBorderColor:[UIColor blueColor].CGColor];
    
    taxView.hidden = YES;
    tipView.hidden = YES;
    discView.hidden = YES;
    scrollView.scrollEnabled = YES;
    itemPicker.delegate = self;
    itemPicker.dataSource = self;
    
    item1.hidden = NO;
    item2.hidden = YES;
    item3.hidden = YES;
    item4.hidden = YES;
    item5.hidden = YES;
    item6.hidden = YES;
    
    item1Text.hidden = NO;
    item2Text.hidden = YES;
    item3Text.hidden = YES;
    item4Text.hidden = YES;
    item5Text.hidden = YES;
    item6Text.hidden = YES;
    
    item1Text.keyboardType = UIKeyboardTypeDecimalPad;
    item2Text.keyboardType = UIKeyboardTypeDecimalPad;
    item3Text.keyboardType = UIKeyboardTypeDecimalPad;
    item4Text.keyboardType = UIKeyboardTypeDecimalPad;
    item5Text.keyboardType = UIKeyboardTypeDecimalPad;
    item6Text.keyboardType = UIKeyboardTypeDecimalPad;
    
    totalPeople.keyboardType = UIKeyboardTypeNumberPad;
    totalNoTax.keyboardType = UIKeyboardTypeDecimalPad;
    totalWithTax.keyboardType = UIKeyboardTypeDecimalPad;
    
    itemListArr = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6", nil];
    
    item1Text.delegate = self;
    item2Text.delegate = self;
    item3Text.delegate = self;
    item4Text.delegate = self;
    item5Text.delegate = self;
    item6Text.delegate = self;
    
    totalNoTax.delegate = self;
    totalPeople.delegate = self;
    totalResult.delegate = self;
    totalWithTax.delegate = self;
    
    scrollView.contentSize = CGSizeMake(taxView.frame.size.width, taxView.frame.size.height);
    locationManager = [[CLLocationManager alloc]init];
    geocoder = [[CLGeocoder alloc]init];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
        digitState.returnKeyType = UIReturnKeyDone;
        digitState.delegate = self;
    
}

-(void)dismissKeyboard {
    [item1Text resignFirstResponder];
    [item2Text resignFirstResponder];
    [item3Text resignFirstResponder];
    [item4Text resignFirstResponder];
    [item5Text resignFirstResponder];
    [item6Text resignFirstResponder];
    
    [digitState resignFirstResponder];
    
    [totalNoTax resignFirstResponder];
    [totalPeople resignFirstResponder];
    [totalResult resignFirstResponder];
    [totalWithTax resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    NSArray *stateList = [self parseJSONStates];
    NSArray *adminAreaList = [self parseJSONAdminArea];
    
    BOOL foundState = [stateList containsObject:digitState.text.uppercaseString];
    BOOL foundAdminArea = [adminAreaList containsObject:placemark.administrativeArea.uppercaseString];
    
    if ((foundAdminArea && [digitState.text isEqualToString:@""]) || (placemark.administrativeArea == nil && [self validateState:digitState.text] == true && foundState)) {
        digitState.backgroundColor = [UIColor colorWithRed:(152/255.0) green:(251/255.0) blue:(152/255.0) alpha:1.0];
    }
    else
    {
        digitState.backgroundColor = [UIColor whiteColor];
        UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Invalid State" message:@"Input a valid State and only 2 digits or GetCurrentLocation (Choose only 1)" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [sentAlertView show];
    }
    [digitState resignFirstResponder];
    
    [item1Text resignFirstResponder];
    [item2Text resignFirstResponder];
    [item3Text resignFirstResponder];
    [item4Text resignFirstResponder];
    [item5Text resignFirstResponder];
    [item6Text resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)taxBtnClicked:(id)sender
{
    [self dismissKeyboard];
    NSArray *stateList = [self parseJSONStates];
    NSArray *adminAreaList = [self parseJSONAdminArea];

    BOOL foundState = [stateList containsObject:digitState.text.uppercaseString];
    BOOL foundAdminArea = [adminAreaList containsObject:placemark.administrativeArea.uppercaseString];
    if ((foundAdminArea && [digitState.text isEqualToString:@""]) || (placemark.administrativeArea == nil && [self validateState:digitState.text] == true && foundState))
    {
        if (taxView.hidden == YES ) {
            taxView.hidden = NO;
            tipView.hidden = YES;
            discView.hidden = YES;
            locationView.hidden = YES;
        }
        
        else
        {
            taxView.hidden = YES;
            locationView.hidden = NO;
        }
    }
    else {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Invalid State" message:@"Input a valid State and only 2 digits or GetCurrentLocation (Choose only 1)" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [sentAlertView show];
        }
}

- (IBAction)tipBtnClicked:(id)sender
{
    [self dismissKeyboard];
    NSArray *stateList = [self parseJSONStates];
    NSArray *adminAreaList = [self parseJSONAdminArea];
    
    BOOL foundState = [stateList containsObject:digitState.text.uppercaseString];
    BOOL foundAdminArea = [adminAreaList containsObject:placemark.administrativeArea.uppercaseString];
    if ((foundAdminArea && [digitState.text isEqualToString:@""]) || (placemark.administrativeArea == nil && [self validateState:digitState.text] == true && foundState))
    {
        if (tipView.hidden == YES ) {
            tipView.hidden = NO;
            taxView.hidden = YES;
            discView.hidden = YES;
            locationView.hidden = YES;
        }
        
        else
        {
            tipView.hidden = YES;
            locationView.hidden = NO;
        }
    }
    
    else {
        UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Invalid State" message:@"Input a valid State and only 2 digits or GetCurrentLocation (Choose only 1)" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [sentAlertView show];
    }
}

- (NSMutableArray *)parseJSONStates{
    
    NSMutableArray *retval = [[NSMutableArray alloc]init];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"salestax"
                                                         ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:&error];
    
    for (JsonData *record in json) {
        
        jsonData = [[JsonData alloc]init];
        jsonData.state = [record valueForKey:@"State"];
        [retval addObject:jsonData.state];
        
    }
    
    return retval;
}

- (NSMutableArray *)parseJSONAdminArea{
    
    NSMutableArray *retval = [[NSMutableArray alloc]init];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"salestax"
                                                         ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:&error];
    
    for (NSDictionary *record in json) {
        
        jsonData = [[JsonData alloc]init];
        jsonData.adminArea = [record valueForKey:@"State"];
        [retval addObject:jsonData.adminArea];
        
    }
    
    return retval;
}

- (NSMutableArray *)parseJSONSalesTax{
    
    NSMutableArray *retval = [[NSMutableArray alloc]init];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"salestax"
                                                         ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:&error];
    
    for (NSMutableArray *record in json) {
        
        jsonData = [[JsonData alloc]init];
        if ([digitState.text isEqualToString:@""]) {
            if([[record valueForKey:@"State" ] isEqual: placemark.administrativeArea.uppercaseString])
            {
                jsonData.salesTax= [record valueForKey:@"Salestax"];
                [retval addObject:jsonData.salesTax];
            }
        }
        else{
            
            if([[record valueForKey:@"State" ] isEqual: digitState.text.uppercaseString])
            {
                jsonData.salesTax= [record valueForKey:@"Salestax"];
                [retval addObject:jsonData.salesTax];
            }
        }
    }
    
    return retval;
}

- (IBAction)totalBtnClicked:(id)sender
{
    NSArray *annoations;
    annoations = [self parseJSONSalesTax];
    jsonData.salesTax = annoations[0];
    
    if(item1Text.hidden == NO && item2Text.hidden == YES && item3Text.hidden == YES && item4Text.hidden == YES && item5Text.hidden == YES && item6Text.hidden == YES)
    {
        if ([self validateItem:item1Text.text] == false) {
        UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Item1 value is not recognized" message:@"Fill the empty or maximum 2 decimal points" delegate:nil cancelButtonTitle:@"Fix It" otherButtonTitles:nil];
        [sentAlertView show];
        }
        else
        {
            double sum;
            sum = (item1Text.text.doubleValue) * (1+[jsonData.salesTax doubleValue]);
            totalResult.text = [[NSString alloc]initWithFormat:@"%.2f",sum];
        }
    }
    else if (item1Text.hidden == NO && item2Text.hidden == NO && item3Text.hidden == YES && item4Text.hidden == YES && item5Text.hidden == YES && item6Text.hidden == YES)
    {
        if ([self validateItem:item1Text.text] == false) {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Item1 value is not recognized" message:@"Fill the empty or maximum 2 decimal points" delegate:nil cancelButtonTitle:@"Fix It" otherButtonTitles:nil];
            [sentAlertView show];
        }
        else if ([self validateItem:item2Text.text] == false) {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Item2 value is not recognized" message:@"Fill the empty or maximum 2 decimal points" delegate:nil cancelButtonTitle:@"Fix It" otherButtonTitles:nil];
            [sentAlertView show];
        }
        else
        {
            double sum;
            sum = (item1Text.text.doubleValue + item2Text.text.doubleValue) * (1+[jsonData.salesTax doubleValue]);
            totalResult.text = [[NSString alloc]initWithFormat:@"%.2f",sum];
        }
    }
    else if (item1Text.hidden == NO && item2Text.hidden == NO && item3Text.hidden == NO && item4Text.hidden == YES && item5Text.hidden == YES && item6Text.hidden == YES)
    {
        if ([self validateItem:item1Text.text] == false) {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Item1 value is not recognized" message:@"Fill the empty or maximum 2 decimal points" delegate:nil cancelButtonTitle:@"Fix It" otherButtonTitles:nil];
            [sentAlertView show];
        }
        else if ([self validateItem:item2Text.text] == false) {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Item2 value is not recognized" message:@"Fill the empty or maximum 2 decimal points" delegate:nil cancelButtonTitle:@"Fix It" otherButtonTitles:nil];
            [sentAlertView show];
        }
        else if ([self validateItem:item3Text.text] == false) {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Item3 value is not recognized" message:@"Fill the empty or maximum 2 decimal points" delegate:nil cancelButtonTitle:@"Fix It" otherButtonTitles:nil];
            [sentAlertView show];
        }
        else
        {
            double sum;
            sum = (item1Text.text.doubleValue + item2Text.text.doubleValue + item3Text.text.doubleValue) * (1+[jsonData.salesTax doubleValue]);
            totalResult.text = [[NSString alloc]initWithFormat:@"%.2f",sum];
        }
    }
    else if (item1Text.hidden == NO && item2Text.hidden == NO && item3Text.hidden == NO && item4Text.hidden == NO && item5Text.hidden == YES && item6Text.hidden == YES)
    {
        if ([self validateItem:item1Text.text] == false) {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Item1 value is not recognized" message:@"Fill the empty or maximum 2 decimal points" delegate:nil cancelButtonTitle:@"Fix It" otherButtonTitles:nil];
            [sentAlertView show];
        }
        else if ([self validateItem:item2Text.text] == false) {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Item2 value is not recognized" message:@"Fill the empty or maximum 2 decimal points" delegate:nil cancelButtonTitle:@"Fix It" otherButtonTitles:nil];
            [sentAlertView show];
        }
        else if ([self validateItem:item3Text.text] == false) {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Item3 value is not recognized" message:@"Fill the empty or maximum 2 decimal points" delegate:nil cancelButtonTitle:@"Fix It" otherButtonTitles:nil];
            [sentAlertView show];
        }
        else if ([self validateItem:item4Text.text] == false) {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Item4 value is not recognized" message:@"Fill the empty or maximum 2 decimal points" delegate:nil cancelButtonTitle:@"Fix It" otherButtonTitles:nil];
            [sentAlertView show];
        }
        else
        {
            double sum;
            sum = (item1Text.text.doubleValue + item2Text.text.doubleValue + item3Text.text.doubleValue + item4Text.text.doubleValue) * (1+[jsonData.salesTax doubleValue]);
            totalResult.text = [[NSString alloc]initWithFormat:@"%.2f",sum];
        }
    }
    else if (item1Text.hidden == NO && item2Text.hidden == NO && item3Text.hidden == NO && item4Text.hidden == NO && item5Text.hidden == NO && item6Text.hidden == YES)
    {
        if ([self validateItem:item1Text.text] == false) {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Item1 value is not recognized" message:@"Fill the empty or maximum 2 decimal points" delegate:nil cancelButtonTitle:@"Fix It" otherButtonTitles:nil];
            [sentAlertView show];
        }
        else if ([self validateItem:item2Text.text] == false) {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Item2 value is not recognized" message:@"Fill the empty or maximum 2 decimal points" delegate:nil cancelButtonTitle:@"Fix It" otherButtonTitles:nil];
            [sentAlertView show];
        }
        else if ([self validateItem:item3Text.text] == false) {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Item3 value is not recognized" message:@"Fill the empty or maximum 2 decimal points" delegate:nil cancelButtonTitle:@"Fix It" otherButtonTitles:nil];
            [sentAlertView show];
        }
        else if ([self validateItem:item4Text.text] == false) {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Item4 value is not recognized" message:@"Fill the empty or maximum 2 decimal points" delegate:nil cancelButtonTitle:@"Fix It" otherButtonTitles:nil];
            [sentAlertView show];
        }
        else if ([self validateItem:item5Text.text] == false) {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Item5 value is not recognized" message:@"Fill the empty or maximum 2 decimal points" delegate:nil cancelButtonTitle:@"Fix It" otherButtonTitles:nil];
            [sentAlertView show];
        }
        else
        {
            double sum;
            sum = (item1Text.text.doubleValue + item2Text.text.doubleValue + item3Text.text.doubleValue + item4Text.text.doubleValue + item5Text.text.doubleValue) * (1+[jsonData.salesTax doubleValue]);
            totalResult.text = [[NSString alloc]initWithFormat:@"%.2f",sum];
        }
    }
    else if (item1Text.hidden == NO && item2Text.hidden == NO && item3Text.hidden == NO && item4Text.hidden == NO && item5Text.hidden == NO && item6Text.hidden == NO)
    {
        if ([self validateItem:item1Text.text] == false) {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Item1 value is not recognized" message:@"Fill the empty or maximum 2 decimal points" delegate:nil cancelButtonTitle:@"Fix It" otherButtonTitles:nil];
            [sentAlertView show];
        }
        else if ([self validateItem:item2Text.text] == false) {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Item2 value is not recognized" message:@"Fill the empty or maximum 2 decimal points" delegate:nil cancelButtonTitle:@"Fix It" otherButtonTitles:nil];
            [sentAlertView show];
        }
        else if ([self validateItem:item3Text.text] == false) {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Item3 value is not recognized" message:@"Fill the empty or maximum 2 decimal points" delegate:nil cancelButtonTitle:@"Fix It" otherButtonTitles:nil];
            [sentAlertView show];
        }
        else if ([self validateItem:item4Text.text] == false) {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Item4 value is not recognized" message:@"Fill the empty or maximum 2 decimal points" delegate:nil cancelButtonTitle:@"Fix It" otherButtonTitles:nil];
            [sentAlertView show];
        }
        else if ([self validateItem:item5Text.text] == false) {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Item5 value is not recognized" message:@"Fill the empty or maximum 2 decimal points" delegate:nil cancelButtonTitle:@"Fix It" otherButtonTitles:nil];
            [sentAlertView show];
        }
        else if ([self validateItem:item6Text.text] == false) {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Item6 value is not recognized" message:@"Fill the empty or maximum 2 decimal points" delegate:nil cancelButtonTitle:@"Fix It" otherButtonTitles:nil];
            [sentAlertView show];
        }
        else
        {
            double sum;
            sum = (item1Text.text.doubleValue + item2Text.text.doubleValue + item3Text.text.doubleValue + item4Text.text.doubleValue + item5Text.text.doubleValue + item6Text.text.doubleValue) * (1+[jsonData.salesTax doubleValue]);
            totalResult.text = [[NSString alloc]initWithFormat:@"%.2f",sum];
        }
    }

}

- (IBAction)tenClicked:(id)sender
{
    NSArray *annoations;
    annoations = [self parseJSONSalesTax];
    jsonData.salesTax = annoations[0];
    
    [tenPercent setBackgroundColor:[UIColor blueColor]];
    [fifteenPercent setBackgroundColor:[UIColor lightGrayColor]];
    [eighteenPercent setBackgroundColor:[UIColor lightGrayColor]];
    
    if(![totalPeople.text isEqual: @""])
    {
        if (![totalNoTax.text  isEqual: @""] && [totalWithTax.text  isEqual: @""])
        {
            double sum;
            double sumWithTax;
            double finalResult;
            sumWithTax = totalNoTax.text.doubleValue * (1+[jsonData.salesTax doubleValue]);
            sum = ((sumWithTax / totalPeople.text.integerValue) * 0.1);
            finalResult = ((sumWithTax / totalPeople.text.integerValue) * 1.1);
            tipAmount.text = [[NSString alloc]initWithFormat:@"%.2f",sum];
            finalAmount.text = [[NSString alloc]initWithFormat:@"%.2f",finalResult];
        }
        else if (![totalWithTax.text  isEqual: @""] && [totalNoTax.text  isEqual: @""])
        {
            double sum;
            double finalResult;
            sum = ((totalWithTax.text.doubleValue / totalPeople.text.integerValue) * 0.1);
            finalResult = ((totalWithTax.text.doubleValue / totalPeople.text.integerValue) * 1.1);
            tipAmount.text = [[NSString alloc]initWithFormat:@"%.2f",sum];
            finalAmount.text = [[NSString alloc]initWithFormat:@"%.2f",finalResult];
        }
        else
        {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill in either one or both are empty" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [sentAlertView show];
        }
    }
    else
    {
        UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Invalid or empty" message:@"Please type a valid input for total people" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [sentAlertView show];
    }

}

- (IBAction)fifteenClicked:(id)sender
{
    NSArray *annoations;
    annoations = [self parseJSONSalesTax];
    jsonData.salesTax = annoations[0];
    
    [tenPercent setBackgroundColor:[UIColor lightGrayColor]];
    [fifteenPercent setBackgroundColor:[UIColor blueColor]];
    [eighteenPercent setBackgroundColor:[UIColor lightGrayColor]];
    
    if(![totalPeople.text isEqual: @""])
    {
        if (![totalNoTax.text  isEqual: @""] && [totalWithTax.text  isEqual: @""])
        {
            double sum;
            double sumWithTax;
            double finalResult;
            sumWithTax = totalNoTax.text.doubleValue * (1+[jsonData.salesTax doubleValue]);
            sum = ((sumWithTax / totalPeople.text.integerValue) * 0.15);
            finalResult = ((sumWithTax / totalPeople.text.integerValue) * 1.15);
            tipAmount.text = [[NSString alloc]initWithFormat:@"%.2f",sum];
            finalAmount.text = [[NSString alloc]initWithFormat:@"%.2f",finalResult];
        }
        else if (![totalWithTax.text  isEqual: @""] && [totalNoTax.text  isEqual: @""])
        {
            double sum;
            double finalResult;
            sum = ((totalWithTax.text.doubleValue / totalPeople.text.integerValue) * 0.15);
            finalResult = ((totalWithTax.text.doubleValue / totalPeople.text.integerValue) * 1.15);
            tipAmount.text = [[NSString alloc]initWithFormat:@"%.2f",sum];
            finalAmount.text = [[NSString alloc]initWithFormat:@"%.2f",finalResult];
        }
        else
        {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill in either one or both are empty" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [sentAlertView show];
        }
    }
    else
    {
        UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Invalid or empty" message:@"Please type a valid input for total people" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [sentAlertView show];
    }}

- (IBAction)eighteenClicked:(id)sender
{
    NSArray *annoations;
    annoations = [self parseJSONSalesTax];
    jsonData.salesTax = annoations[0];
    
    [tenPercent setBackgroundColor:[UIColor lightGrayColor]];
    [fifteenPercent setBackgroundColor:[UIColor lightGrayColor]];
    [eighteenPercent setBackgroundColor:[UIColor blueColor]];
    
    if(![totalPeople.text isEqual: @""])
    {
        if (![totalNoTax.text  isEqual: @""] && [totalWithTax.text  isEqual: @""])
        {
            double sum;
            double sumWithTax;
            double finalResult;
            sumWithTax = totalNoTax.text.doubleValue * (1+[jsonData.salesTax doubleValue]);
            sum = ((sumWithTax / totalPeople.text.integerValue) * 0.18);
            finalResult = ((sumWithTax / totalPeople.text.integerValue) * 1.18);
            tipAmount.text = [[NSString alloc]initWithFormat:@"%.2f",sum];
            finalAmount.text = [[NSString alloc]initWithFormat:@"%.2f",finalResult];
        }
        else if (![totalWithTax.text  isEqual: @""] && [totalNoTax.text  isEqual: @""])
        {
            double sum;
            double finalResult;
            sum = ((totalWithTax.text.doubleValue / totalPeople.text.integerValue) * 0.18);
            finalResult = ((totalWithTax.text.doubleValue / totalPeople.text.integerValue) * 1.18);
            tipAmount.text = [[NSString alloc]initWithFormat:@"%.2f",sum];
            finalAmount.text = [[NSString alloc]initWithFormat:@"%.2f",finalResult];
        }
        else
        {
            UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill in either one or both are empty" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [sentAlertView show];
        }
    }
    else
    {
        UIAlertView *sentAlertView = [[UIAlertView alloc] initWithTitle:@"Invalid or empty" message:@"Please type a valid input for total people" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [sentAlertView show];
    }
}

- (IBAction)currentLocation:(id)sender {
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return [itemListArr count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [itemListArr objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch(row)
    {
        case 0:
        {
            item1.hidden = NO;
            item2.hidden = YES;
            item3.hidden = YES;
            item4.hidden = YES;
            item5.hidden = YES;
            item6.hidden = YES;
            
            item1Text.hidden = NO;
            item2Text.hidden = YES;
            item3Text.hidden = YES;
            item4Text.hidden = YES;
            item5Text.hidden = YES;
            item6Text.hidden = YES;
            break;
        }
        case 1:
        {
            item1.hidden = NO;
            item2.hidden = NO;
            item3.hidden = YES;
            item4.hidden = YES;
            item5.hidden = YES;
            item6.hidden = YES;
            
            item1Text.hidden = NO;
            item2Text.hidden = NO;
            item3Text.hidden = YES;
            item4Text.hidden = YES;
            item5Text.hidden = YES;
            item6Text.hidden = YES;
            break;
        }
        case 2:
        {
            item1.hidden = NO;
            item2.hidden = NO;
            item3.hidden = NO;
            item4.hidden = YES;
            item5.hidden = YES;
            item6.hidden = YES;
            
            item1Text.hidden = NO;
            item2Text.hidden = NO;
            item3Text.hidden = NO;
            item4Text.hidden = YES;
            item5Text.hidden = YES;
            item6Text.hidden = YES;
            break;
        }
        case 3:
        {
            item1.hidden = NO;
            item2.hidden = NO;
            item3.hidden = NO;
            item4.hidden = NO;
            item5.hidden = YES;
            item6.hidden = YES;
            
            item1Text.hidden = NO;
            item2Text.hidden = NO;
            item3Text.hidden = NO;
            item4Text.hidden = NO;
            item5Text.hidden = YES;
            item6Text.hidden = YES;
            break;
        }
        case 4:
        {
            item1.hidden = NO;
            item2.hidden = NO;
            item3.hidden = NO;
            item4.hidden = NO;
            item5.hidden = NO;
            item6.hidden = YES;
            
            item1Text.hidden = NO;
            item2Text.hidden = NO;
            item3Text.hidden = NO;
            item4Text.hidden = NO;
            item5Text.hidden = NO;
            item6Text.hidden = YES;
            break;
        }
        case 5:
        {
            item1.hidden = NO;
            item2.hidden = NO;
            item3.hidden = NO;
            item4.hidden = NO;
            item5.hidden = NO;
            item6.hidden = NO;
            
            item1Text.hidden = NO;
            item2Text.hidden = NO;
            item3Text.hidden = NO;
            item4Text.hidden = NO;
            item5Text.hidden = NO;
            item6Text.hidden = NO;
            break;
        }
    }
}
-(void)getCurrentLocation:(id)sender
{
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    
}

- (IBAction)resetCurrentLocation:(id)sender
{
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager stopUpdatingLocation];
    
    latitude.text = @"";
    longitude.text = @"";
    addressTextField.text = @"";
//    locationManager = nil;
//    geocoder = nil;
//    placemark = nil;
}

- (BOOL)validateItem:(NSString *) itemValue
{
    NSString *itemRegex = @"^([0-9]{1,5})(\\.([0-9]{0,2})?)?$";
    NSPredicate *itemTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", itemRegex];
    return [itemTest evaluateWithObject:itemValue];
}

- (BOOL)validateState:(NSString *) stateValue
{
    NSString *itemRegex = @"[a-zA-Z]{2}";
    NSPredicate *itemTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", itemRegex];
    return [itemTest evaluateWithObject:stateValue];
}

#pragma mark - CCLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Failed to get your current location" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [errorAlert show];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    if(currentLocation != nil || [longitude.text isEqualToString:@""] || [latitude.text isEqualToString:@""] || [addressTextField.text isEqualToString:@""])
    {
        longitude.text = [NSString stringWithFormat:@"%.6f",currentLocation.coordinate.longitude];
        latitude.text = [NSString stringWithFormat:@"%.6f",currentLocation.coordinate.latitude];
    }
    
    //Geocoding get address
    [locationManager stopUpdatingLocation];
    
    NSLog(@"Resolving The Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found Placemarks: %@, error: %@", placemarks, error);
        if(error == nil && [placemarks count] > 0)
        {
            placemark = [placemarks lastObject];
            addressTextField.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",placemark.subThoroughfare,placemark.thoroughfare,placemark.postalCode, placemark.locality, placemark.administrativeArea,placemark.country];
        }
        else
        {
            NSLog(@"%@", error.debugDescription);
        }
    }];
}

@end
