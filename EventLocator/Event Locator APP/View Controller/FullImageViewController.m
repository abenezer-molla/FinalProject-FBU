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

@end
