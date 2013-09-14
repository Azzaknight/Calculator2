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
-(void)pushVariable:(NSString *)variable;
-(void)pushOperation:(NSString *)operation;
-(void)reset;
-(void)undo;

@property (readonly) id program;

+(id) runProgram:(id) program;
+(NSString *) descriptionOfProgram:(id) program;

// Assignment 2

+(id) runProgram:(id)program withVariables:(NSDictionary *)variableValues;

+(NSSet *) variablesUsedInProgram:(id)program ;

@end
