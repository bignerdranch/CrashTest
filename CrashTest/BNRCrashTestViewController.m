//
//  BNRFirstViewController.m
//  JTBDynamicsDemos
//
//  Copyright 2013 Big Nerd Ranch, LLC.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//


#import "BNRCrashTestViewController.h"

@interface BNRCrashTestViewController ()

@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (strong, nonatomic) UIDynamicItemBehavior *item1DIB;
@property (strong, nonatomic) UIDynamicItemBehavior *item2DIB;

@property (weak, nonatomic) IBOutlet UIView *item1;
@property (weak, nonatomic) IBOutlet UIView *item2;

@property (weak, nonatomic) IBOutlet UISlider *elasticity1Slider;
@property (weak, nonatomic) IBOutlet UISlider *friction1Slider;
@property (weak, nonatomic) IBOutlet UISlider *resistance1Slider;
@property (weak, nonatomic) IBOutlet UISlider *density1Slider;
@property (weak, nonatomic) IBOutlet UISwitch *rotation1Switch;

@property (weak, nonatomic) IBOutlet UISlider *elasticity2Slider;
@property (weak, nonatomic) IBOutlet UISlider *friction2Slider;
@property (weak, nonatomic) IBOutlet UISlider *resistance2Slider;
@property (weak, nonatomic) IBOutlet UISlider *density2Slider;
@property (weak, nonatomic) IBOutlet UISwitch *rotation2Switch;

@property (nonatomic, assign) CGRect startRect1;
@property (nonatomic, assign) CGRect startRect2;

@end

@implementation BNRCrashTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.item1DIB = [[UIDynamicItemBehavior alloc] initWithItems:@[self.item1]];
    [self.animator addBehavior:self.item1DIB];
    self.item2DIB = [[UIDynamicItemBehavior alloc] initWithItems:@[self.item2]];
    [self.animator addBehavior:self.item2DIB];
    
    // Add collision behavior
    UICollisionBehavior *collider = [[UICollisionBehavior alloc] initWithItems:@[self.item1, self.item2]];
    collider.collisionMode = UICollisionBehaviorModeItems;
    [self.animator addBehavior:collider];

    
    self.startRect1 = self.item1.frame;
    self.startRect2 = self.item2.frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startCrash:(id)sender
{
    // Add an quick push to the views
    UIPushBehavior *push1 = [[UIPushBehavior alloc] initWithItems:@[self.item1] mode:UIPushBehaviorModeInstantaneous];
    push1.angle = 0.0;
    push1.magnitude = 3.0;
    [self.animator addBehavior:push1];
    
    UIPushBehavior *push2 = [[UIPushBehavior alloc] initWithItems:@[self.item2] mode:UIPushBehaviorModeInstantaneous];
    push2.angle = M_PI;
    push2.magnitude = 3.0;
    [self.animator addBehavior:push2];
}

- (IBAction)updateDIBs:(id)sender {
    self.item1DIB.resistance = self.resistance1Slider.value;
    self.item1DIB.elasticity = self.elasticity1Slider.value;
    self.item1DIB.friction = self.friction1Slider.value;
    self.item1DIB.density = self.density1Slider.value;
    self.item1DIB.allowsRotation = self.rotation1Switch.isOn;

    self.item2DIB.resistance = self.resistance2Slider.value;
    self.item2DIB.elasticity = self.elasticity2Slider.value;
    self.item2DIB.friction = self.friction2Slider.value;
    self.item2DIB.density = self.density2Slider.value;
    self.item2DIB.allowsRotation = self.rotation2Switch.isOn;
}

- (IBAction)reset:(id)sender {
    
    self.item1.frame = self.startRect1;
    self.item1.transform = CGAffineTransformIdentity;
    CGPoint vel = [self.item1DIB linearVelocityForItem:self.item1];
    [self.item1DIB addLinearVelocity:CGPointMake(-vel.x, -vel.y) forItem:self.item1];

    [self.animator updateItemUsingCurrentState:self.item1];
    
    self.item2.frame = self.startRect2;
    self.item2.transform = CGAffineTransformIdentity;
    vel = [self.item2DIB linearVelocityForItem:self.item2];
    [self.item2DIB addLinearVelocity:CGPointMake(-vel.x, -vel.y) forItem:self.item2];
    [self.animator updateItemUsingCurrentState:self.item2];
}

@end
