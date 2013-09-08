//
//  CalculatorBrain.h
//  Calculator2
//
//  Created by Pamamarch on 28/08/2013.
//  Copyright (c) 2013 Finger Flick Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

-(void)pushOperand:(double)operand;
-(double)performOperation:(NSString *)operation;
-(void)reset;

@end
