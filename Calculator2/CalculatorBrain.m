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


-(void)reset {
    
    // have to clear the operand stack
    [self.programStack removeAllObjects];
}

-(id) program {
    
    return [self.programStack copy];
}

+(double)popOperandOffStack:(NSMutableArray *)stack {
    
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        return [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        
        NSString * operation = topOfStack;
        
        if ([operation  isEqualToString: @"+"]){
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            result = ([self popOperandOffStack:stack] - [self popOperandOffStack:stack]) * -1;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffStack:stack];
            if (divisor) result = [self popOperandOffStack:stack] / divisor;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"√"]) {
            result = sqrt([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        } else if ([operation isEqualToString:@"±"]) {
            result = ([self popOperandOffStack:stack] * -1);
        }
        
    }
    
    return result;
}


+(double) runProgam:(id)program {
    
    NSMutableArray * stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    return [self popOperandOffStack:stack];
}

+(NSString *)descriptionOfProgram:(id)program {
    
    return @"To do this in the homework";
}


@end
