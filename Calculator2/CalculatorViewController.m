//
//  CalculatorViewController.m
//  Calculator2
//
//  Created by Pamamarch on 28/08/2013.
//  Copyright (c) 2013 Finger Flick Games. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *calculatorBrain;
@property (nonatomic, strong) NSDictionary * testDisplayValues;

@end

@implementation CalculatorViewController



-(CalculatorBrain *)calculatorBrain
{
    if(!_calculatorBrain) _calculatorBrain = [[CalculatorBrain alloc] init];
    return _calculatorBrain;
}

- (void)appendToHistory:(NSString *)text
{
    self.history.text = [self.history.text stringByReplacingOccurrencesOfString:@"=" withString:@""];
    
    self.history.text = [self.history.text stringByAppendingString:text];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateCalculatedDisplay {
    
//    [self displayVariableValueWithVariables:self.testDisplayValues];
    id result = [CalculatorBrain runProgram:self.calculatorBrain.program withVariables:self.testDisplayValues];
    if([result isKindOfClass:[NSNumber class]]) self.display.text = [NSString stringWithFormat:@"%g",[result doubleValue]];
    else if ([result isKindOfClass:[NSString class]]) self.display.text = [NSString stringWithFormat:@"%@", result];
    self.history.text = [CalculatorBrain descriptionOfProgram:self.calculatorBrain.program];
}

- (IBAction)testVariablesPressed:(UIButton *)sender {
    
    if([[sender currentTitle] isEqualToString:@"Test1"]){
        
        self.testDisplayValues = @{@"x":@(5.0), @"y":@(10.0), @"z":@(25.0)};
        
    } else if([[sender currentTitle] isEqualToString:@"Test2"]){
        
        self.testDisplayValues = nil;
        
    } else if([[sender currentTitle] isEqualToString:@"Test3"]) {
        
        self.testDisplayValues = @{@"x":@(-2.0), @"y":@(0.0), @"z":@(7.5)};
        
    } else if([[sender currentTitle] isEqualToString:@"Test4"]) {
        
        self.testDisplayValues = @{@"x":@(6.5),@"y":@(12.75), @"z":@(5.0)};
    }
    
    [self updateCalculatedDisplay];

}



- (IBAction)variablePressed:(UIButton *)sender {
    
    // the variable was pressed!
    if(self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    [self.calculatorBrain pushVariable:[sender currentTitle]];
    //self.history.text = [CalculatorBrain descriptionOfProgram:[self.calculatorBrain program]];
    [self updateCalculatedDisplay];
}

- (IBAction)digitPressed:(UIButton *)sender {
    
    NSString* digit = sender.currentTitle;
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    
}


/*
-(void)displayVariableValueWithVariables:(NSDictionary *)valueDict {
    
    
    self.variableDisplay.text = @"";
    NSSet* variablesInProgram = [CalculatorBrain variablesUsedInProgram:self.calculatorBrain.program];
    
    // If the dictionary is nil, and there are variables in the program, set their values to 0!
    if(!valueDict){
        for( id items in variablesInProgram) {
            NSString * values = [NSString stringWithFormat:@"%@ = 0  ", items];
            self.variableDisplay.text = [self.variableDisplay.text stringByAppendingString:values];
            
        }
    }
    
    // If the dictionary is not nil, then for the variables in the program, display their values!
    for(id items in valueDict) {
        
        if ([items isKindOfClass:[NSString class]] && [variablesInProgram containsObject:items]){
            NSString * values = [NSString stringWithFormat:@"%@ = %@  ", items, [valueDict objectForKey:items]];
            self.variableDisplay.text = [self.variableDisplay.text stringByAppendingString:values];
                                 
        }
    }
    
}
 
*/

- (IBAction)operationPressed:(UIButton *)sender {
    
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    //[self appendToHistory:[[sender currentTitle] stringByAppendingString:@" ="]];
    [self.calculatorBrain pushOperation:[sender currentTitle]];
   // self.display.text = [NSString stringWithFormat:@"%g",result];
    
    [self updateCalculatedDisplay];
    
}

- (IBAction)enterPressed {
    
    [self.calculatorBrain pushOperand:[self.display.text doubleValue]];
    //[self appendToHistory:[self.display.text stringByAppendingString:@" "]];
    self.history.text = [CalculatorBrain descriptionOfProgram:[self.calculatorBrain program]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
}

- (IBAction)pointPressed {
    
    // If the user has not entered the decimal yet, then we will add the point
    // else we will ignore the button Press. Also if it's the first thing the
    // user presses, we will add a 0 automatically before a decimal
    if (!self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = @"0.";
        self.userIsInTheMiddleOfEnteringANumber = YES;
    } else {
        NSRange range = [self.display.text rangeOfString:@"."];
        if (range.location == NSNotFound){
            self.display.text = [self.display.text stringByAppendingString:@"."];
        }
    }

}

- (IBAction)backSpacePressed {
    
    // remove the text of self.displat by 1 using substring
    
    self.display.text = [self.display.text substringToIndex:([self.display.text length] - 1)];
        
    if ([self.display.text isEqualToString:@""] ||
        [self.display.text isEqualToString:@"-"]){
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
   
}


- (IBAction)undoPressed {
    
    if(self.userIsInTheMiddleOfEnteringANumber) {
        [self backSpacePressed];
    } else {
        [self.calculatorBrain undo];
        [self updateCalculatedDisplay];
        
    }
}

- (IBAction)plusMinusPressed:(UIButton *)sender {
    
    if ([self userIsInTheMiddleOfEnteringANumber]) {
        
//        NSString * plusMinus = [NSString stringWithFormat:@"%g",([self.display.text doubleValue] * -1)];
        
        NSNumber *plusMinus = @([self.display.text doubleValue] * -1);
        self.display.text = [plusMinus stringValue];
        
    } else {
        
        [self operationPressed:sender];
    }
}

- (IBAction)clearPresses {
    
    [self.calculatorBrain reset];
    self.display.text = @"0";
    self.history.text = @"";
    self.testDisplayValues = nil;
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

////////////////////////  Assignment 3 Onwards Code

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([[sender currentTitle] isEqualToString:@"Graph"])
    {
        [segue.destinationViewController setGraphViewProgramStack:self.calculatorBrain.program];
    }
}



@end
