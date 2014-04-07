//
//  JsonData.h
//  Project1
//
//  Created by Frans Kurniawan on 2/25/14.
//  Copyright (c) 2014 Frans Kurniawan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonData : NSObject
{
    NSMutableArray *state;
    NSMutableArray *adminArea;
    NSString *salesTax;
}

@property (nonatomic, copy) NSMutableArray *state;
@property (nonatomic, copy) NSMutableArray *adminArea;
@property (nonatomic, copy) NSString * salesTax;

@end
