//
//  FullImageViewController.m
//  Event Locator APP
//
//  Created by abenezermolla on 7/15/21.
//

#import "FullImageViewController.h"

@interface FullImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *fullImageView;


@end

@implementation FullImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fullImageView.image = self.fullImage;
    // Do any additional setup after loading the view.
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
