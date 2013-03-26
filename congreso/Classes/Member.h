//
//  Member.h
//  congreso
//
//  Created by Christian Roman on 18/03/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class State;

@interface Member : NSObject

@property (nonatomic, assign) int ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSString *header;
@property (nonatomic, strong) State *state;
@property (nonatomic, strong) NSString *party;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *substitute;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSArray *phones;
@property (nonatomic, strong) NSString *curul;
@property (nonatomic, assign) int kind;
@property (nonatomic, assign) int id_alt;
@property (nonatomic, strong) NSArray *commissions;
@property (nonatomic, strong) UIImage *uiimage;

@end
