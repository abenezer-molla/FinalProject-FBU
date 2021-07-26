//
//  PhotoMapViewController.m
//  Event Locator APP
//
//  Created by abenezermolla on 7/15/21.
//

#import "PhotoMapViewController.h"
#import "MapKit/MapKit.h"
#import "PhotoAnnotation.h"
#import "LocationTagViewController.h"
#import "FullImageViewController.h"


@interface PhotoMapViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) UIImage *selectedImage;

@end

@implementation PhotoMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MKCoordinateRegion sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1));
    [self.mapView setRegion:sfRegion animated:false];
    self.mapView.delegate = self;

    // Do any additional setup after loading the view.
}




- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if (annotationView == nil) {
    annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
    annotationView.canShowCallout = true;
    annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    }
    
    

    UIImageView *imageView = (UIImageView*)annotationView.leftCalloutAccessoryView;
    // imageView.image = [UIImage imageNamed:@"camera-icon"]; // remove this line

    // add these two lines below
    PhotoAnnotation *photoAnnotationItem = annotation; // refer to this generic annotation as our more specific PhotoAnnotation
    imageView.image = photoAnnotationItem.photo; // set the image into the callout imageview
    return annotationView;
 }



- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control{
 
    [self performSegueWithIdentifier:@"firstSegue" sender:nil];

}


- (IBAction)photoButtonOnMap:(id)sender {
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
    
    
}







- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    // Do something with the images (based on your use case)
    self.selectedImage = originalImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"tagSegue" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"tagSegue"]) {
            LocationTagViewController *vc = segue.destinationViewController;
            vc.delegate = self;
    } else if([segue.identifier isEqualToString:@"firstSegue"]) {
        
        
        FullImageViewController *vc2 = segue.destinationViewController;
        vc2.fullImage = self.selectedImage;
        
        // CONTINUE FROM THIS POINT!!
    
    }
}




- (void)locationsViewController:(LocationTagViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude {

    // Add a pin to the map
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);

    PhotoAnnotation *point = [[PhotoAnnotation alloc] init];
    point.coordinate = coordinate;
    point.photo = [self resizeImage:self.selectedImage withSize:CGSizeMake(50.0, 50.0)];
    [self.mapView addAnnotation:point];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];

    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;

    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

@end
