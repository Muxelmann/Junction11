//
//  ShoutboxViewController.m
//  junction11
//
//  Created by Maximilian Zangs on 29.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "ShoutboxViewController.h"
#import "CustomButtons.h"

#define MAX_CHARACTERS_IN_MESSAGE 200

@interface ShoutboxViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextView *message;
@property (weak, nonatomic) IBOutlet UILabel *codeShould;
@property (weak, nonatomic) IBOutlet UILabel *codeIs;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *shoutButton;
@property (weak, nonatomic) IBOutlet UILabel *charCounter;

@property (strong, nonatomic) Shoutbox *shoutbox;

@end

@implementation ShoutboxViewController
@synthesize message = _message;
@synthesize userName = _userName;
@synthesize codeShould = _codeShould;
@synthesize codeIs = _codeIs;
@synthesize slider = _slider;
@synthesize shoutbox = _shoutbox;
@synthesize charCounter = _charCounter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Setup shoutbox object
    self.shoutbox = [[Shoutbox alloc] init];
    [CustomButtons makeOverlayWithColor:[UIColor blueColor] toView:self.view];
    
    // Setup view
    self.view.backgroundColor = [UIColor clearColor];
    self.slider.continuous = YES;
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 9;
    self.slider.value = 5;
    
    self.message.text = @"";
    self.charCounter.text = [NSString stringWithFormat:@"%i", MAX_CHARACTERS_IN_MESSAGE];

    self.codeShould.textColor = [UIColor whiteColor];
    self.codeShould.font = [UIFont boldSystemFontOfSize:15];
    self.codeShould.text = [NSString stringWithFormat:@"%i", [self.shoutbox getCode]];
    self.codeIs.textColor = [UIColor whiteColor];
    self.codeIs.font = [UIFont boldSystemFontOfSize:15];
    self.codeIs.text = @"5";
    
    self.userName.textColor = [UIColor whiteColor];
    [CustomButtons makeHollowView:self.userName];
    
    [self.shoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.shoutButton setTitle:@"Shout" forState:UIControlStateNormal];
    [CustomButtons makeButtonGlossy:self.shoutButton];
    self.shoutButton.backgroundColor = [UIColor colorWithRed:.8 green:.0 blue:.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)codeUpdate:(id)sender
{
    self.codeIs.text = [NSString stringWithFormat:@"%i", (NSInteger)
                        self.slider.value];
    if ([self.codeIs.text intValue] == [self.codeShould.text integerValue]) {
        self.shoutButton.backgroundColor = [UIColor colorWithRed:.1 green:.6 blue:.1 alpha:1.0];
    } else {
        self.shoutButton.backgroundColor = [UIColor colorWithRed:.8 green:.0 blue:.0 alpha:1.0];
    }
}

- (IBAction)pushShout:(id)sender
{
    if ([self.codeIs.text intValue] == [self.codeShould.text integerValue]) {
        self.shoutButton.backgroundColor = [UIColor colorWithRed:.0 green:.4 blue:.0 alpha:1.0];
    } else {
        self.shoutButton.backgroundColor = [UIColor colorWithRed:.6 green:.0 blue:.0 alpha:1.0];
    }
}

- (IBAction)shout:(id)sender
{
    if ([self.codeIs.text intValue] == [self.codeShould.text integerValue] && self.message.text.length > 0 && self.message.text.length <= MAX_CHARACTERS_IN_MESSAGE) {
        BOOL success = [self.shoutbox shoutMessage:self.message.text byUser:self.userName.text WithCode:(NSInteger)self.slider.value];
        if (success) {
            self.codeShould.text = [NSString stringWithFormat:@"%i", [self.shoutbox getCode]];
            self.message.text = @"";
            NSLog(@"SUCCESS");
        }
        if ([self.message isFirstResponder])
            [self.message resignFirstResponder];
    }
    
    // Reset button color immediately
    if ([self.codeIs.text intValue] == [self.codeShould.text integerValue]) {
        self.shoutButton.backgroundColor = [UIColor colorWithRed:.1 green:.6 blue:.1 alpha:1.0];
    } else {
        self.shoutButton.backgroundColor = [UIColor colorWithRed:.8 green:.0 blue:.0 alpha:1.0];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    } else if (textView.text.length - range.length + text.length <= MAX_CHARACTERS_IN_MESSAGE) {
        self.charCounter.text = [NSString stringWithFormat:@"%i", MAX_CHARACTERS_IN_MESSAGE - (textView.text.length - range.length + text.length)];
        return YES;
    }
    
    return NO;
}

@end
