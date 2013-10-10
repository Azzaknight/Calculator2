//
//  GraphView.h
//  Calculator2
//
//  Created by Pamamarch on 09/10/2013.
//  Copyright (c) 2013 Finger Flick Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphView : UIView

@property (nonatomic) CGPoint myGraphOrigin;
@property (nonatomic) CGFloat myGraphScale;

-(void)taps:(UITapGestureRecognizer *) gesture;
-(void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
