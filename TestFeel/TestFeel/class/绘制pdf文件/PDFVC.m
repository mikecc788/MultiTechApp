//
//  PDFVC.m
//  TestFeel
//
//  Created by app on 2023/4/4.
//

#import "PDFVC.h"
#import "CreatePDFImage.h"
#import "LFSPDFImage.h"
@interface PDFVC ()

@end

@implementation PDFVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 2.设置pdf文档存储的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *filePath = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.pdf",@"pdf"]];
    CreatePDFImage *create = [[CreatePDFImage alloc]initwithTitle:@"Report2"];
    [create CreatePdfFile:@[@"10",@"20",@"30",@"20"]];
    
    ///Users/feellife/Library/Developer/CoreSimulator/Devices/CFD80094-329C-4204-9271-FABF8B3DAEC2/data/Containers/Data/Application/BD0AF742-FD4B-48D5-A225-5FFB2F58E058/Documents/EcgImageView.pdf
    NSString *title = @"11213244Reader";
    if(title.length == 0 || title == nil){
        title = @"identifier";
    }
    [LFSPDFImage createPDFImageWithTitle:title pefArray:@[@(512),@(650),@(430)] saveToPath:filePath];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
