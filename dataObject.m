//
//  dataObject.m
//  fooderV2
//
//  Created by Backman on 2015/11/17.
//  Copyright © 2015年 Backman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dataObject.h"


@implementation dataObject
static dataObject *instance = nil;




+(dataObject *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [dataObject new];
            
           
            instance.ansFooders= [NSMutableDictionary new];
            
            instance.ansRS = [NSMutableDictionary   new];
        }
    }
    return instance;
}

@end