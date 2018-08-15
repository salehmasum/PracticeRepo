//
//  UIViewController+XHPhoto.m

//  XHPhotoExample
//
//  Created by xiaohui on 16/6/6.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHPhoto

#import "UIViewController+XHPhoto.h"
#import "objc/runtime.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

#ifdef DEBUG
#define debugLog(...)    NSLog(__VA_ARGS__)
#else
#define debugLog(...)
#endif

#define XH_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define XH_IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

static  BOOL canEdit = NO;
static  BOOL tempCanEdit = NO;
static  char blockKey;
static  char tempBlockKey;

@interface UIViewController()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate>

@property (nonatomic,copy)photoBlock photoBlock;
@property (nonatomic,copy)photosBlock selectedPhotosBlock;

@end

@implementation UIViewController (XHPhoto)

#pragma mark-set
-(void)setPhotoBlock:(photoBlock)photoBlock
{
    objc_setAssociatedObject(self, &blockKey, photoBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void)setSelectedPhotosBlock:(photosBlock)selectedPhotosBlock
{
    objc_setAssociatedObject(self, &tempBlockKey, selectedPhotosBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark-get
- (photoBlock )photoBlock
{
    return objc_getAssociatedObject(self, &blockKey);
}
-(photosBlock)selectedPhotosBlock
{
    return objc_getAssociatedObject(self, &tempBlockKey);
}

- (void)showPhotoSourceType:(SourceType)sourceType photo:(photoBlock)block{
    [self showPhotoSourceType:sourceType canEdit:NO alerttitle:nil photo:block];
}
- (void)showPhotoSourceType:(SourceType)sourceType alerttitle:(NSString *)titleString photo:(photoBlock)block{
    [self showPhotoSourceType:sourceType canEdit:NO alerttitle:titleString photo:block];
}

- (void)showPhotoSourceType:(SourceType)sourceType canEdit:(BOOL)edit alerttitle:(NSString *)titleString photo:(photoBlock)block{
    if (titleString) {
        [self showSourceType:sourceType canEdit:edit alerttitle:titleString photo:block];
    }else{
        switch (sourceType) {
            case SourceTypeCamera:
                [self showCameraCanEdit:edit photo:block];
                break;
            case SourceTypePhotoLibrary:
                [self showPhotoLibraryCanEdit:edit photo:block];
                break;
            case SourceTypeCameraOrPhotoLibrary:
                [self showSourceType:sourceType canEdit:edit alerttitle:titleString photo:block];
                break;
                
            default:
                break;
        }
    }
    
}

- (void)showCanEdit:(BOOL)edit photo:(photoBlock)block{
    [self showSourceType:SourceTypeCameraOrPhotoLibrary canEdit:edit alerttitle:nil photo:block];
}


-(void)showSourceType:(SourceType)sourceType canEdit:(BOOL)edit alerttitle:(NSString *)titleString photo:(photoBlock)block{
    canEdit = edit;
    self.photoBlock = [block copy];
    __block typeof(self) weakeSelf = self;
    
   // NSString *titleString = @"This should be a picture of the carer";
    UIAlertController *alertController = [UIAlertController 
                                          alertControllerWithTitle:titleString 
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet]; 
    
    {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Cancel", @"password") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
    }
    
    if(sourceType==SourceTypeCamera || sourceType==SourceTypeCameraOrPhotoLibrary){
        UIAlertAction *takeAction = [UIAlertAction actionWithTitle:@"Take Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakeSelf showCameraCanEdit:edit photo:block];
        }];
     //   [takeAction setValue:COLOR_BLUE forKey:@"titleTextColor"];
        [alertController addAction:takeAction];
    }
    
    if(sourceType==SourceTypePhotoLibrary || sourceType==SourceTypeCameraOrPhotoLibrary){
        UIAlertAction *chooseAction = [UIAlertAction actionWithTitle:@"Choose Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {  
            [weakeSelf showPhotoLibraryCanEdit:edit photo:block];
        }]; 
     //   [chooseAction setValue:COLOR_BLUE forKey:@"titleTextColor"];
        [alertController addAction:chooseAction]; 
    }
    
    if (titleString) {
        //修改title
        NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:titleString];
        [alertControllerStr addAttribute:NSForegroundColorAttributeName value:TX_RGB(90, 90, 90) range:NSMakeRange(0, titleString.length)];
        [alertControllerStr addAttribute:NSFontAttributeName value:TX_BOLD_FONT(18) range:NSMakeRange(0, titleString.length)];
        [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    }
    
    //    //修改message
    //    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"提示内容"];
    //    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, 4)];
    //    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 4)];
    //    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    //iOS8.3

    
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}



-(void)showPhotoLibraryCanEdit:(BOOL)edit photo:(photoBlock)block
{
    canEdit = edit;
    self.photoBlock = [block copy];
    
    //权限
    if(![self authorWithType:1]) return;
    
    //相册
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = canEdit;
    imagePickerController.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
    
    
}
-(void)showPhotoLibraryCanSelected:(NSInteger)count SelectPhotos:(photosBlock)block{
    self.selectedPhotosBlock  = [block copy];
    
    //权限
    if(![self authorWithType:1]) return;
   
}

-(void)showCameraCanEdit:(BOOL)edit photo:(photoBlock)block
{
    canEdit = edit;
    self.photoBlock = [block copy];
    
    //权限
    if(![self authorWithType:0]) return;
    
    //相机
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = canEdit;
    //是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:NULL];
    } 
    
}
/**
 权限是否开启
 
 @param type 0相机,1相册
 @return 权限开启YES,否则NO
 */
-(BOOL)authorWithType:(NSInteger)type
{
    //权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
        NSString *photoType = type==0?@"Camera":@"Photos";
        NSString *message = [NSString stringWithFormat:@"Grant %@ access to your mobile %@ from \"Settings\"->\"Privacy\"->\"%@\"",kAPPNAME,photoType,photoType];
        __block typeof(self) weakeSelf = self;
        
        UIAlertController *alertController = [UIAlertController 
                                              alertControllerWithTitle:@"Warning" 
                                              message:message 
                                              preferredStyle:UIAlertControllerStyleAlert]; 
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Cancel", @"password") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"Setting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakeSelf goSystemSetting];
        }]; 
        [alertController addAction:cancelAction];
        [alertController addAction:settingAction]; 
        [self presentViewController:alertController animated:YES completion:nil];
        return NO;
    }
    return YES;
}



- (void)goSystemSetting{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak typeof(self) weakSelf= self;
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image;
        //是否要裁剪
        if ([picker allowsEditing]){
            
            //编辑之后的图像
            image = [info objectForKey:UIImagePickerControllerEditedImage];
            
        } else {
            
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        if(weakSelf.photoBlock)
        {
            weakSelf.photoBlock([self imageWithImageSimple:image scale:kIMAGEZOOMSCALE]);
        }
    }];
    
    
}

- (UIImage*)imageWithImageSimple:(UIImage*)image scale:(CGFloat)scale 
{ 
 //   return [self scaleImage:image toKb:10]; 
    
    CGSize imageSize = image.size;
    
    CGFloat maxSize = 1000;
    
    CGSize newSize = imageSize;
    if (imageSize.width>maxSize) {
        newSize = CGSizeMake(maxSize, imageSize.height*maxSize/imageSize.width); 
        imageSize = newSize;
    }
    if (imageSize.height>maxSize) {
        newSize = CGSizeMake(imageSize.width*maxSize/imageSize.height, maxSize);
        imageSize = newSize;
    }
    
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > 300*1024 && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    NSLog(@"当前大小:%fkb",(float)[imageData length]/1024.0f);
    image = [UIImage imageWithData:imageData];
    
 //   CGSize newSize = CGSizeMake(imageSize.width*scale, imageSize.height*scale);
    
    // Create a graphics image context 
    UIGraphicsBeginImageContext(newSize); 
    // Tell the old image to draw in this new context, with the desired 
    // new size 
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)]; 
    // Get the new image from the context 
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext(); 
    // End the context 
    UIGraphicsEndImageContext(); 
    // Return the new image. 
    return newImage;
}
-(UIImage *)scaleImage:(UIImage *)image toKb:(NSInteger)kb{
    
    if (!image) {
        return image;
    }
    if (kb<1) {
        return image;
    }
    
    kb*=1024;
    
    
    
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > kb && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    NSLog(@"当前大小:%fkb",(float)[imageData length]/1024.0f);
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
    
    
    
}

//保存图片
-(NSString *)saveImageDocuments:(UIImage *)image{
    //拿到图片
    UIImage *imagesave = image;
    NSString *path_sandox = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *fileName = [Util fileName];
    NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",fileName]];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    if ([UIImagePNGRepresentation(imagesave) writeToFile:imagePath atomically:YES]) {
        return imagePath;
    }else{
        return @"";
    }
}
@end
