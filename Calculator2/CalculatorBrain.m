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


-(void)pushOperation:(NSString *)operation{
    
    [self.programStack addObject:operation];
}


-(void)undo {
  
    if([self.programStack lastObject]) [self.programStack removeLastObject];
}

-(void)reset {
    
    // have to clear the operand stack
    [self.programStack removeAllObjects];
}

-(id) program {
    
    return [self.programStack copy];
}

+(id)popOperandOffStack:(NSMutableArray *)stack {
    
    id result;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        return topOfStack;
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        
        NSString * operation = topOfStack;
        
        
        if([self isNoOperandOperation:topOfStack]) result = @(M_PI);
        
        else if([self isOneOperandOperation:topOfStack]){
            
            id operand = [self popOperandOffStack:stack];
            if([operand isKindOfClass:[NSNumber class]]){
                
                if ([operation isEqualToString:@"sin"]) result = @(sin([operand doubleValue]));
                else if ([operation isEqualToString:@"cos"]) result = @(cos([operand doubleValue]));
                else if ([operation isEqualToString:@"±"]) result = @([operand doubleValue] * -1);
                else if ([operation isEqualToString:@"√"]) {
                    if([operand doubleValue] >= 0) result = @(sqrt([operand doubleValue]));
                    else result = @"err √ of -ve number!";
                }
            } else result = @"insufficient operand";
        } else if ([self isTwoOperandOperation:topOfStack]){
            
            id firstOperand = [self popOperandOffStack:stack];
            id secondOperand = [self popOperandOffStack:stack];
            
            if([firstOperand isKindOfClass:[NSNumber class]] && [secondOperand isKindOfClass:[NSNumber class]]) {
                
                if ([operation isEqualToString:@"+"]) result = @([firstOperand doubleValue] + [secondOperand doubleValue]);
                else if ([operation isEqualToString:@"*"]) result = @([firstOperand doubleValue] * [secondOperand doubleValue]);
                else if ([operation isEqualToString:@"-"]) result = @([secondOperand doubleValue] - [firstOperand doubleValue]);
                else if ([operation isEqualToString:@"/"]) {
                    if ([firstOperand doubleValue] != 0) result = @([secondOperand doubleValue] / [firstOperand doubleValue]);
                    else result = @"divide by zero!";
                }
            } else result = @"insufficient operand";
        }
    }
    
    return result;
}

+(BOOL) isOperation:(NSString*)operation {
    
    return ([self isTwoOperandOperation:operation] ||
    [self isOneOperandOperation:operation] ||
    [self isNoOperandOperation:operation]);
}

+(BOOL) isTwoOperandOperation:(NSString *) operation {
    
    NSArray *operationList = @[@"+", @"-", @"*", @"/"];
    NSSet *operationSet = [NSSet setWithArray:operationList];
    return [operationSet containsObject:operation];
}

+(BOOL) isOneOperandOperation:(NSString *) operation {
    
    NSArray *operationList = @[@"sin", @"cos", @"√", @"±"];
    NSSet *operationSet = [NSSet setWithArray:operationList];
    return [operationSet containsObject:operation];
}

+(BOOL) isNoOperandOperation:(NSString *) operation {
    
    NSArray *operationList = @[@"π"];
    NSSet *operationSet = [NSSet setWithArray:operationList];
    return [operationSet containsObject:operation];
}



+(NSSet *) variablesUsedInProgram:(id)program {
    
   // NSMutableArray * variableList = [@[] mutableCopy];
    NSMutableSet * variableList = [NSMutableSet set];
    NSArray *programStack = [program copy];
    
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



+(id) runProgram:(id)program {
    
    return [self runProgram:program withVariables:nil];
    
}


+(id) runProgram:(id)program withVariables:(NSDictionary *)variableValues {
    
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
        
        NSSet* var = [self variablesUsedInProgram:program];
        
        if(var){
            
            for(int i=0; i < [program count]; i++) {
                if([var containsObject:stack[i]]) {
                    
                    NSNumber *item_to_replace = [variableValues objectForKey:stack[i]];
                    if(!item_to_replace) item_to_replace = @(0.0);//[NSNumber numberWithDouble:0.0];
                    
                    [stack replaceObjectAtIndex:i withObject:item_to_replace];
                    
                }
            }
        }
        NSLog(@"%@",[self descriptionOfProgram:program]);
        return [self popOperandOffStack:stack];
        
    }
    return 0;
}

+(NSString *) suppressBrackets:(NSString *)expression {
    
    NSString * description = expression;
    
    if([description hasPrefix:@"("] && [description hasSuffix:@")"]){
        
        description = [description substringFromIndex:1];
        description = [description substringToIndex:[description length]-1];
    }
    
    NSRange openBracket = [description rangeOfString:@"("];
    NSRange closeBracket = [description rangeOfString:@")"];
    
    if(openBracket.location <= closeBracket.location) return description;
    else return expression;
    
}

+(NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack {
    
    NSString *description;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if([topOfStack isKindOfClass:[NSNumber class]]){
        return [topOfStack description];
    }
    
    if ([topOfStack isKindOfClass:[NSString class]]){
        
        if([self isTwoOperandOperation:topOfStack]) {
            // Either it's TwoOperandOperation
            
            NSString* secondOperand = [self descriptionOfTopOfStack:stack];
            NSString* firstOperand = [self descriptionOfTopOfStack:stack];
            
            NSSet * higherOrder = [NSSet setWithObjects:@"*",@"/", nil];
            if([higherOrder containsObject:topOfStack]){
                description = [NSString stringWithFormat:@"%@ %@ %@",firstOperand,topOfStack, secondOperand];
            } else {
            description = [NSString stringWithFormat:@"(%@ %@ %@)",[self suppressBrackets:firstOperand],topOfStack, [self suppressBrackets:secondOperand]];
            }
            
        } else if ([self isOneOperandOperation:topOfStack]) {
            // Or a One operand operation
            
            NSString* operand = [self descriptionOfTopOfStack:stack];
            description = [NSString stringWithFormat:@"(%@(%@))", topOfStack, [self suppressBrackets:operand]];
        }else {
            // Else it's a NoOperandOperation or Variable
            // In which case we return it as it is.
            description = topOfStack;
        }
    }
    
    return description;
}


+(NSString *)descriptionOfProgram:(id)program {
    
    
    if([program isKindOfClass:[NSArray class]]){
        
        NSMutableArray *stack = [program mutableCopy];
        NSMutableArray *expressions = [NSMutableArray array];
        
        while ([stack count] > 0){
            [expressions addObject:[self suppressBrackets:[self descriptionOfTopOfStack:stack]]];
        }
        
        return [expressions componentsJoinedByString:@","];
        
    } else {
     
        return @"error";
    }

}


@end
