//
//  LFSSetTextField.m
//  TestFeel
//
//  Created by app on 2023/2/22.
//
#define kPlaceholderFontSize 12
#define kPlaceholderHeight 15

#import "LFSSetTextField.h"

@interface LFSSetTextField()<UITextFieldDelegate>

@end

@implementation LFSSetTextField

-(instancetype)init {
    if (self) {
        self = [super init];
        [self initialization];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame {
    if (self) {
        self = [super initWithFrame:frame];
        [self initialization];
    }
    return self;
}

#pragma mark  Intialization method
-(void)initialization{
    //1. Placeholder Color.
     if (_placeHolderColor == nil){
         _placeHolderColor = [UIColor lightGrayColor];
     }
    self.borderStyle = UITextBorderStyleNone;
    self.font = [UIFont boldSystemFontOfSize:16];
    self.textColor = [UIColor blackColor];
    self.textAlignment = NSTextAlignmentCenter;
    self.clearsOnBeginEditing = YES; //当编辑时清空
    self.keyboardType = UIKeyboardTypeNumberPad;
   
//    self.delegate = self;
   
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"开始编辑");
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"结束编辑");
}
//键盘右下角return键
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"触发");
    return YES;
}
#pragma mark  Set Placeholder Text On Label
-(void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    if (![placeholder isEqualToString:@""]) {
        self.labelPlaceholder.text = placeholder;
    }
    
}

#pragma mark  UITextField End Editing.
-(void)textFieldDidEndEditing {
    
//    [self floatTheLabel];
    
}
-(void)textFieldDidBeginEditing{
    
}

#pragma mark  UITextField Responder Overide
-(BOOL)becomeFirstResponder {

    BOOL result = [super becomeFirstResponder];
    [self textFieldDidBeginEditing];
    return result;
}

-(BOOL)resignFirstResponder {

    BOOL result = [super resignFirstResponder];
    [self textFieldDidEndEditing];
    return result;
}
@end
