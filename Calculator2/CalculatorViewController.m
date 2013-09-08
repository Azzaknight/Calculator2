//
//  CalculatorViewController.m
//  Calculator2
//
//  Created by Pamamarch on 28/08/2013.
//  Copyright (c) 2013 Finger Flick Games. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *calculatorBrain;

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

- (IBAction)digitPressed:(UIButton *)sender {
    
    NSString* digit = sender.currentTitle;
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    
}

- (IBAction)operationPressed:(UIButton *)sender {
    
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    [self appendToHistory:[[sender currentTitle] stringByAppendingString:@" ="]];
    double result = [self.calculatorBrain performOperation:[sender currentTitle]];
    self.display.text = [NSString stringWithFormat:@"%g",result];
    
    
}

- (IBAction)enterPressed {
    
    [self.calculatorBrain pushOperand:[self.display.text doubleValue]];
    [self appendToHistory:[self.display.text stringByAppendingString:@" "]];
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
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

@end
