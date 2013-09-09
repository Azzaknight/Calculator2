//
//  CalculatorBrain.m
//  Calculator2
//
//  Created by Pamamarch on 28/08/2013.
//  Copyright (c) 2013 Finger Flick Games. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain ()

@property (nonatomic, strong) NSMutableArray *programStack;

@end

@implementation CalculatorBrain

-(NSMutableArray *)programStack
{
    if(!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

-(void)pushOperand:(double)operand{
    // pushOperand gives us a double but the Array stores only Objects.
    // so have to wrap the operand in an NSNumber
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
    
}


-(double)performOperation:(NSString *)operation{
    
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgam:self.program];
}


/*
    double result = 0;
    
    if ([operation  isEqualToString: @"+"]){
        result = [self popOperand] + [self popOperand];
    } else if ([operation isEqualToString:@"*"]) {
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"-"]) {
        result = ([self popOperand] - [self popOperand]) * -1;
    } else if ([operation isEqualToString:@"/"]) {
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand] / divisor;
    } else if ([operation isEqualToString:@"sin"]) {
        result = sin([self popOperand]);
    } else if ([operation isEqualToString:@"cos"]) {
        result = cos([self popOperand]);
    } else if ([operation isEqualToString:@"√"]) {
        result = sqrt([self popOperand]);
    } else if ([operation isEqualToString:@"π"]) {
        result = M_PI;
    } else if ([operation isEqualToString:@"±"]) {
        result = ([self popOperand] * -1);
    }
    
    //push the result back onto the stack
    [self pushOperand:result];
    
    return result;
    
}
 
 */


-(void)reset {
    
    // have to clear the operand stack
    [self.programStack removeAllObjects];
}

-(id) program {
    
    return [self.programStack copy];
}

+(double)popOperandOffStack:(NSMutableArray *)stack {
    
    double result = 0;
    
    // pop operand off the stack
    // if it's an operation, then recursively evaluate
    
    return result;
}


+(double) runProgam:(id)program {
    
    return [self popOperandOffStack:[program mutableCopy]];
}

+(NSString *)descriptionOfProgram:(id)program {
    
    return @"To do this in the homework";
}


@end
