/*
 QSViewController.m
 QuickSketch
 
 Copyright (c) 2013 Thomas DiZoglio. All rights reserved.
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 If you happen to meet one of the copyright holders in a bar you are obligated
 to buy them one pint of beer.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
*/

#import "QSViewController.h"

@interface QSViewController ()

@end

@implementation QSViewController

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    canvasView = (DrawingCanvasView *)self.view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [canvasView eraseCanvas];
    }
}

- (IBAction)eraserButtonActionUp:(id)sender
{
    
    [canvasView setStrokeColor:[UIColor whiteColor]];
    [canvasView setPathLineWidth:8.0];
}

- (IBAction)blackMarkerButtonActionUp:(id)sender
{

    [canvasView setStrokeColor:[UIColor blackColor]];
    [canvasView setPathLineWidth:2.0];
}

- (IBAction)redMarkerButtonActionUp:(id)sender
{

    [canvasView setStrokeColor:[UIColor redColor]];
    [canvasView setPathLineWidth:2.0];
}

- (IBAction)blueMarkerButtonActionUp:(id)sender
{

    [canvasView setStrokeColor:[UIColor blueColor]];
    [canvasView setPathLineWidth:2.0];
}

- (IBAction)yellowMarkerButtonActionUp:(id)sender {

    [canvasView setStrokeColor:[UIColor yellowColor]];
    [canvasView setPathLineWidth:2.0];
}


- (IBAction)cameraRollButtonActionUp:(id)sender
{
}

- (IBAction)emailButtonActionUp:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setSubject:@"Check out this image!"];
        
        // Set up recipients
        // NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
        // NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
        // NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
        
        // [picker setToRecipients:toRecipients];
        // [picker setCcRecipients:ccRecipients];
        // [picker setBccRecipients:bccRecipients];
        
        // Attach an image to the email
        UIImage *coolImage = [canvasView writeCanvasToJPG];
        if (coolImage == nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Problem converting Worksheet canvas to JPG." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        NSData *myData = UIImagePNGRepresentation(coolImage);
        [picker addAttachmentData:myData mimeType:@"image/png" fileName:@"coolImage.png"];
        
        // Fill out the email body text
        NSString *emailBody = @"My cool image is attached";
        [picker setMessageBody:emailBody isHTML:NO];
        [self presentModalViewController:picker animated:YES];
        
        picker = nil;
        
        /*
         MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
         mailViewController.mailComposeDelegate = self;
         [mailViewController setSubject:@\"Subject Goes Here.\"];
         [mailViewController setMessageBody:@\"Your message goes here.\" isHTML:NO];
         
         [self presentModalViewController:mailViewController animated:YES];
         mailViewController = nil;
         */
    }
    else {
        
        NSLog(@"Device is unable to send email in its current state.");
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

@end
