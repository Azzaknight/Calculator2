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

-(void)pushVariable:(NSString *)variable {
    // Ignore the variable name if same as an operation
    if(![CalculatorBrain isOperation:variable]) {
        [self.programStack addObject:variable];
    }
}


-(double)performOperation:(NSString *)operation{
    
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
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
            double subtraend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtraend;
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

+(BOOL) isOperation:(NSString*)operation {
    
    NSArray *operationList = @[@"+", @"-", @"*", @"/", @"sin", @"cos", @"√", @"π", @"±"];
    NSSet *operationSet = [NSSet setWithArray:operationList];
    return [operationSet containsObject:operation];
    
}

+(NSSet *) variablesUsedInProgram:(id)program {
    
   // NSMutableArray * variableList = [@[] mutableCopy];
    NSMutableSet * variableList = [NSMutableSet set];
    NSArray *programStack = (NSArray*)program;
    
    for (id items in programStack) {
        if([items isKindOfClass:[NSString class]]) {
            if (![self isOperation:items]){
                NSLog(@"The name of the variable is %@", items);
                [variableList addObject:items];
            }
        }
    }
    
    
    NSLog(@"The items in the array %i", [variableList count]);
    if ([variableList count] != 0) {
        NSLog(@"I shouldnt reach here");
        return [variableList copy];
    } else return nil;
    
}



+(double) runProgram:(id)program {
    
    return [self runProgram:program withVariables:nil];
    
}


+(double) runProgram:(id)program withVariables:(NSDictionary *)variableValues {
    
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
        
        NSSet* var = [self variablesUsedInProgram:program];
        
        if(var){
            
            for(int i=0; i < [program count]; i++) {
                if([var containsObject:stack[i]]) {
                    [stack replaceObjectAtIndex:i withObject:[variableValues objectForKey:stack[i]]];
                    
                }
            }
        }
        return [self popOperandOffStack:stack];
    }
    return 0;
}


+(NSString *)descriptionOfProgram:(id)program {
    
    return @"To do this in the homework";
}


@end
