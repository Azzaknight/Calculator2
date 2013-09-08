//
//  CalculatorBrain.m
//  Calculator2
//
//  Created by Pamamarch on 28/08/2013.
//  Copyright (c) 2013 Finger Flick Games. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain ()

@property (nonatomic, strong) NSMutableArray *operandStack;

@end

@implementation CalculatorBrain

-(NSMutableArray *)operandStack
{
    if(!_operandStack) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

-(void)pushOperand:(double)operand{
    // pushOperand gives us a double but the Array stores only Objects.
    // so have to wrap the operand in an NSNumber
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
    
}

-(double)popOperand {
    NSNumber * result = [self.operandStack lastObject];
    if (result) {
        [self.operandStack removeLastObject];
    }
    
    return [result doubleValue];
    
}

-(double)performOperation:(NSString *)operation{
    
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

-(void)reset {
    
    // have to clear the operand stack
    [self.operandStack removeAllObjects];
}


@end
