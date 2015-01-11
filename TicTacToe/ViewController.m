//
//  ViewController.m
//  TicTacToe
//
//  Created by Gabriel Borri de Azevedo on 1/9/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIAlertViewDelegate, UIGestureRecognizerDelegate>
// Labels
@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelThree;
@property (weak, nonatomic) IBOutlet UILabel *labelFour;
@property (weak, nonatomic) IBOutlet UILabel *labelFive;
@property (weak, nonatomic) IBOutlet UILabel *labelSix;
@property (weak, nonatomic) IBOutlet UILabel *labelSeven;
@property (weak, nonatomic) IBOutlet UILabel *labelEight;
@property (weak, nonatomic) IBOutlet UILabel *labelNine;

@property (weak, nonatomic) IBOutlet UILabel *eachPlayerLabel;

@property NSMutableArray *labelsArray; // array with all labels
@property NSMutableSet *usedXLabelsArray; //used labels during game
@property NSMutableSet *usedOLabelsArray; //used labels during game

@property NSSet *winArray; // array of (winning position) arrays
@property NSSet *winArray1;
@property NSSet *winArray2;
@property NSSet *winArray3;
@property NSSet *winArray4;
@property NSSet *winArray5;
@property NSSet *winArray6;
@property NSSet *winArray7;
@property NSSet *winArray8;


@property (weak, nonatomic) IBOutlet UILabel *labelX;
@property (weak, nonatomic) IBOutlet UILabel *labelO;

@property CGPoint labelXOriginalCenter;
@property CGPoint labelOOriginalCenter;


@property int i;

@property (weak, nonatomic) IBOutlet UILabel *whichPlayerLabel;

@property BOOL player1; //players

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startGame];
    [self createWinningArray];
}

-(void)startGame
{
    self.labelOne.text = @"";
    self.labelTwo.text = @"";
    self.labelThree.text = @"";
    self.labelFour.text = @"";
    self.labelFive.text = @"";
    self.labelSix.text = @"";
    self.labelSeven.text = @"";
    self.labelEight.text = @"";
    self.labelNine.text = @"";

    self.usedXLabelsArray = [[NSMutableSet alloc] init];
    self.usedOLabelsArray = [[NSMutableSet alloc] init];

    self.labelsArray = [[NSMutableArray alloc] initWithObjects:self.labelOne, self.labelTwo, self.labelThree, self.labelFour, self.labelFive, self.labelSix, self.labelSeven, self.labelEight, self.labelNine, nil]; //allocation all labels in one single array
    self.player1 = TRUE; // Player 1 starts

    self.labelXOriginalCenter = self.labelX.center;
    self.labelOOriginalCenter = self.labelO.center;

    self.labelX.enabled = TRUE;
    self.labelO.enabled = FALSE;

    self.eachPlayerLabel.text = @"Player 1 Starts";
}

-(void)createWinningArray
{
    self.winArray1 = [[NSSet alloc] initWithObjects:@"1",@"2",@"3",nil];
    self.winArray2 = [[NSSet alloc] initWithObjects:@"4",@"5",@"6",nil];
    self.winArray3 = [[NSSet alloc] initWithObjects:@"7",@"8",@"9",nil];
    self.winArray4 = [[NSSet alloc] initWithObjects:@"1",@"4",@"7",nil];
    self.winArray5 = [[NSSet alloc] initWithObjects:@"2",@"5",@"8",nil];
    self.winArray6 = [[NSSet alloc] initWithObjects:@"3",@"6",@"9",nil];
    self.winArray7 = [[NSSet alloc] initWithObjects:@"1",@"5",@"9",nil];
    self.winArray8 = [[NSSet alloc] initWithObjects:@"3",@"5",@"7",nil];

    self.winArray = [[NSSet alloc]initWithObjects:self.winArray1, self.winArray2, self.winArray3, self.winArray4, self.winArray5, self.winArray6, self.winArray7, self.winArray8, nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self startGame];
    }
}

- (IBAction)panHandler:(UIPanGestureRecognizer *)gesture
{
    CGPoint touchPoint = [gesture locationInView:self.view];
    UILabel *foundLabel = [self findLabelUsingPoint:touchPoint]; // call findLabelUsingPoint and pass point to it
    if (self.player1)
    {
        self.labelX.center = touchPoint;
        if (gesture.state == UIGestureRecognizerStateEnded)
        {
            if (CGRectContainsPoint(foundLabel.frame, touchPoint))
            {
                foundLabel.text = @"X"; // set label's text to X
                self.eachPlayerLabel.text = @"Player 2 Turn";
                self.player1 = FALSE;  // make player 2's turn
                [self.usedXLabelsArray addObject:[NSString stringWithFormat:@"%ld", (long)foundLabel.tag]];
                self.labelO.enabled = TRUE;
                self.labelX.enabled = FALSE;
            }
            [UIView animateWithDuration:.5 animations:^{
                [self restoreLabelOptions:self.labelX];
            }];
        }
    }
    else
    {
        self.labelO.center = touchPoint;
        if (gesture.state == UIGestureRecognizerStateEnded)
        {
            if (CGRectContainsPoint(foundLabel.frame, touchPoint))
            {
                foundLabel.text = @"O"; // set label's text to X
                self.eachPlayerLabel.text = @"Player 1 Turn";
                self.player1 = TRUE;  // make player 2's turn
                [self.usedOLabelsArray addObject:[NSString stringWithFormat:@"%ld", (long)foundLabel.tag]];
                self.labelO.enabled = FALSE;
                self.labelX.enabled = TRUE;
}
                [UIView animateWithDuration:.5 animations:^{
                    [self restoreLabelOptions:self.labelO];
                }];
        }
    }
    [self gameResult];
}

-(UILabel *)findLabelUsingPoint:(CGPoint) point
{
    UILabel *foundLabel;
    for (UILabel *label in self.labelsArray) // go in each label inside labelsArray
    {
        if (CGRectContainsPoint(label.frame, point)) // if the touched point is inside the label's frame
        {
            foundLabel = label; // assign label to foundLabel
        }
    }
    return foundLabel; // return foundLabel to onLabelTapped
}

-(void)restoreLabelOptions:(UILabel *)label
{
    if (self.player1)
    {
        label.center = self.labelXOriginalCenter;
    }
    else
    {
        label.center = self.labelOOriginalCenter;
    }
}

-(void)gameResult
{
    UIAlertView *winAlert = [UIAlertView new];
    [winAlert addButtonWithTitle:@"New Game"];
    winAlert.delegate = self;
    for (NSSet *winningSet in self.winArray)
    {
        if ([winningSet isSubsetOfSet:self.usedXLabelsArray]) // label in usedLabel ?
        {
            winAlert.title = @"Player 1 Won!";
            [winAlert show];
        }
        else if ([winningSet isSubsetOfSet:self.usedOLabelsArray])
        {
            winAlert.title = @"Player 2 Won!";
            [winAlert show];
        }
        else if (self.usedOLabelsArray.count >= 5 || self.usedXLabelsArray.count >= 5)
        {
            winAlert.title = @"Cat's!";
            [winAlert show];
        }
    }
}

@end
