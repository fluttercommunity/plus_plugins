// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
#import "./include/share_plus/FPPSharePlusPlugin.h"
#import "LinkPresentation/LPLinkMetadata.h"
#import "LinkPresentation/LPMetadataProvider.h"

static NSString *const PLATFORM_CHANNEL = @"dev.fluttercommunity.plus/share";

static UIViewController *RootViewController(void) {
  if (@available(iOS 13, *)) { // UIApplication.keyWindow is deprecated
    NSSet *scenes = [[UIApplication sharedApplication] connectedScenes];
    for (UIScene *scene in scenes) {
      if ([scene isKindOfClass:[UIWindowScene class]]) {
        NSArray *windows = ((UIWindowScene *)scene).windows;
        for (UIWindow *window in windows) {
          if (window.isKeyWindow) {
            return window.rootViewController;
          }
        }
      }
    }
    return nil;
  } else {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
  }
}

static UIViewController *
TopViewControllerForViewController(UIViewController *viewController) {
  if (viewController.presentedViewController) {
    return TopViewControllerForViewController(
        viewController.presentedViewController);
  }
  if ([viewController isKindOfClass:[UINavigationController class]]) {
    return TopViewControllerForViewController(
        ((UINavigationController *)viewController).visibleViewController);
  }
  return viewController;
}

static NSDictionary *activityTypes;

static void initializeActivityTypeMapping(void) {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSMutableDictionary *originalTypes =
        [[NSMutableDictionary alloc] initWithDictionary:@{
          @"postToFacebook" : UIActivityTypePostToFacebook,
          @"postToTwitter" : UIActivityTypePostToTwitter,
          @"postToWeibo" : UIActivityTypePostToWeibo,
          @"message" : UIActivityTypeMessage,
          @"mail" : UIActivityTypeMail,
          @"print" : UIActivityTypePrint,
          @"copyToPasteboard" : UIActivityTypeCopyToPasteboard,
          @"assignToContact" : UIActivityTypeAssignToContact,
          @"saveToCameraRoll" : UIActivityTypeSaveToCameraRoll,
          @"addToReadingList" : UIActivityTypeAddToReadingList,
          @"postToFlickr" : UIActivityTypePostToFlickr,
          @"postToVimeo" : UIActivityTypePostToVimeo,
          @"postToTencentWeibo" : UIActivityTypePostToTencentWeibo,
          @"airDrop" : UIActivityTypeAirDrop,
          @"openInIBooks" : UIActivityTypeOpenInIBooks,
          @"markupAsPDF" : UIActivityTypeMarkupAsPDF,
        }];

    if (@available(iOS 15.4, *)) {
      originalTypes[@"sharePlay"] = UIActivityTypeSharePlay;
    }

    if (@available(iOS 16.0, *)) {
      originalTypes[@"collaborationInviteWithLink"] =
          UIActivityTypeCollaborationInviteWithLink;
    }

    if (@available(iOS 16.0, *)) {
      originalTypes[@"collaborationCopyLink"] =
          UIActivityTypeCollaborationCopyLink;
    }
    if (@available(iOS 16.4, *)) {
      originalTypes[@"addToHomeScreen"] = UIActivityTypeAddToHomeScreen;
    }
    activityTypes = originalTypes;
  });
}

static NSArray<UIActivityType> *
activityTypesForStrings(NSArray<NSString *> *activityTypeStrings) {
  if (activityTypeStrings == nil || activityTypeStrings.count == 0) {
    return nil;
  }
  initializeActivityTypeMapping();
  NSMutableArray<UIActivityType> *result = [NSMutableArray array];

  for (NSString *key in activityTypeStrings) {
    UIActivityType mapped = activityTypes[key];
    if (mapped) {
      [result addObject:mapped];
    }
  }

  return [result copy];
}

@interface SharePlusData : NSObject <UIActivityItemSource>

@property(readonly, nonatomic, copy) NSString *subject;
@property(readonly, nonatomic, copy) NSString *text;
@property(readonly, nonatomic, copy) NSString *path;
@property(readonly, nonatomic, copy) NSString *mimeType;

- (instancetype)initWithSubject:(NSString *)subject
                           text:(NSString *)text NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFile:(NSString *)path
                    mimeType:(NSString *)mimeType NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFile:(NSString *)path
                    mimeType:(NSString *)mimeType
                     subject:(NSString *)subject NS_DESIGNATED_INITIALIZER;

- (instancetype)init
    __attribute__((unavailable("Use initWithSubject:text: instead")));

@end

@implementation SharePlusData

- (instancetype)init {
  [super doesNotRecognizeSelector:_cmd];
  return nil;
}

- (instancetype)initWithSubject:(NSString *)subject text:(NSString *)text {
  self = [super init];
  if (self) {
    _subject = [subject isKindOfClass:NSNull.class] ? @"" : subject;
    _text = text;
  }
  return self;
}

- (instancetype)initWithFile:(NSString *)path mimeType:(NSString *)mimeType {
  self = [super init];
  if (self) {
    _path = path;
    _mimeType = mimeType;
  }
  return self;
}

- (instancetype)initWithFile:(NSString *)path
                    mimeType:(NSString *)mimeType
                     subject:(NSString *)subject {
  self = [super init];
  if (self) {
    _path = path;
    _mimeType = mimeType;
    _subject = [subject isKindOfClass:NSNull.class] ? @"" : subject;
  }
  return self;
}

- (id)activityViewControllerPlaceholderItem:
    (UIActivityViewController *)activityViewController {
  return [self
      activityViewController:activityViewController
         itemForActivityType:@"dev.fluttercommunity.share_plus.placeholder"];
}

- (id)activityViewController:(UIActivityViewController *)activityViewController
         itemForActivityType:(UIActivityType)activityType {
  if (!_path || !_mimeType) {
    return _text;
  }

  // If the shared file is an image return an UIImage for the placeholder
  // to show a preview.
  if ([activityType
          isEqualToString:@"dev.fluttercommunity.share_plus.placeholder"] &&
      [_mimeType hasPrefix:@"image/"]) {
    UIImage *image = [UIImage imageWithContentsOfFile:_path];
    return image;
  }

  // Return an NSURL for the real share to conserve the file name
  NSURL *url = [NSURL fileURLWithPath:_path];
  return url;
}

- (NSString *)activityViewController:
                  (UIActivityViewController *)activityViewController
              subjectForActivityType:(UIActivityType)activityType {
  return _subject;
}

- (UIImage *)activityViewController:
                 (UIActivityViewController *)activityViewController
      thumbnailImageForActivityType:(UIActivityType)activityType
                      suggestedSize:(CGSize)suggestedSize {
  if (!_path || !_mimeType || ![_mimeType hasPrefix:@"image/"]) {
    return nil;
  }

  UIImage *image = [UIImage imageWithContentsOfFile:_path];
  return [self imageWithImage:image scaledToSize:suggestedSize];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
  UIGraphicsBeginImageContext(newSize);
  [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

- (LPLinkMetadata *)activityViewControllerLinkMetadata:
    (UIActivityViewController *)activityViewController
    API_AVAILABLE(macos(10.15), ios(13.0), watchos(6.0)) {
  LPLinkMetadata *metadata = [[LPLinkMetadata alloc] init];

  if ([_subject length] > 0) {
    metadata.title = _subject;
  } else if ([_text length] > 0) {
    metadata.title = _text;
  }

  if (_path) {
    NSString *extesnion = [_path pathExtension];

    unsigned long long rawSize = (
        [[[NSFileManager defaultManager] attributesOfItemAtPath:_path
                                                          error:nil] fileSize]);
    NSString *readableSize = [NSByteCountFormatter
        stringFromByteCount:rawSize
                 countStyle:NSByteCountFormatterCountStyleFile];

    NSString *description = @"";

    if (![extesnion isEqualToString:@""]) {
      description =
          [description stringByAppendingString:[extesnion uppercaseString]];
      description = [description stringByAppendingString:@" • "];
      description = [description stringByAppendingString:readableSize];
    } else {
      description = [description stringByAppendingString:readableSize];
    }

    // https://stackoverflow.com/questions/60563773/ios-13-share-sheet-changing-subtitle-item-description
    metadata.originalURL = [NSURL fileURLWithPath:description];
    if (_mimeType && [_mimeType hasPrefix:@"image/"]) {
      UIImage *image = [UIImage imageWithContentsOfFile:_path];
      metadata.imageProvider = [[NSItemProvider alloc]
          initWithObject:[self imageWithImage:image
                                 scaledToSize:CGSizeMake(120, 120)]];
    }
  }

  return metadata;
}

@end

@implementation FPPSharePlusPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *shareChannel =
      [FlutterMethodChannel methodChannelWithName:PLATFORM_CHANNEL
                                  binaryMessenger:registrar.messenger];

  [shareChannel setMethodCallHandler:^(FlutterMethodCall *call,
                                       FlutterResult result) {
    NSDictionary *arguments = [call arguments];
    NSNumber *originX = arguments[@"originX"];
    NSNumber *originY = arguments[@"originY"];
    NSNumber *originWidth = arguments[@"originWidth"];
    NSNumber *originHeight = arguments[@"originHeight"];
    NSArray *excludedActivityTypeStrings =
        arguments[@"excludedCupertinoActivities"];
    NSArray<UIActivityType> *excludedActivityTypes =
        activityTypesForStrings(excludedActivityTypeStrings);

    CGRect originRect = CGRectZero;
    if (originX && originY && originWidth && originHeight) {
      originRect =
          CGRectMake([originX doubleValue], [originY doubleValue],
                     [originWidth doubleValue], [originHeight doubleValue]);
    }

    if ([@"share" isEqualToString:call.method]) {
      NSString *shareText = arguments[@"text"];
      NSArray *paths = arguments[@"paths"];
      NSArray *mimeTypes = arguments[@"mimeTypes"];
      NSString *uri = arguments[@"uri"];

      // Use title field for consistency with Android.
      // Subject field should only be used on email subjects.
      NSString *shareTitle = arguments[@"title"];
      if (!shareTitle) {
        // fallback to be backwards compatible with the subject field.
        shareTitle = arguments[@"subject"];
      }

      // Check if text provided is valid
      if (shareText && shareText.length == 0) {
        result([FlutterError errorWithCode:@"error"
                                   message:@"Non-empty text expected"
                                   details:nil]);
        return;
      }

      // Check if title provided is valid
      if (shareTitle && shareTitle.length == 0) {
        result([FlutterError errorWithCode:@"error"
                                   message:@"Non-empty title expected"
                                   details:nil]);
        return;
      }

      // Check if uri provided is valid
      if (uri && uri.length == 0) {
        result([FlutterError errorWithCode:@"error"
                                   message:@"Non-empty uri expected"
                                   details:nil]);
        return;
      }

      // Check if files provided are valid
      if (paths) {
        // If paths provided, it should not be empty
        if (paths.count == 0) {
          result([FlutterError errorWithCode:@"error"
                                     message:@"Non-empty paths expected"
                                     details:nil]);
          return;
        }

        // If paths provided, paths should not be empty
        for (NSString *path in paths) {
          if (path.length == 0) {
            result([FlutterError errorWithCode:@"error"
                                       message:@"Each path must not be empty"
                                       details:nil]);
            return;
          }
        }

        if (mimeTypes && mimeTypes.count != paths.count) {
          result([FlutterError
              errorWithCode:@"error"
                    message:@"Paths and mimeTypes should have same length"
                    details:nil]);
          return;
        }
      }

      // Check if root view controller is valid
      UIViewController *rootViewController = RootViewController();
      if (!rootViewController) {
        result([FlutterError errorWithCode:@"error"
                                   message:@"No root view controller found"
                                   details:nil]);
        return;
      }
      UIViewController *topViewController =
          TopViewControllerForViewController(rootViewController);

      if (uri) {
        [self shareUri:uri
            excludedActivityTypes:excludedActivityTypes
                   withController:topViewController
                         atSource:originRect
                         toResult:result];
      } else if (paths) {
        [self shareFiles:paths
                     withMimeType:mimeTypes
                      withSubject:shareTitle
                         withText:shareText
            excludedActivityTypes:excludedActivityTypes
                   withController:rootViewController
                         atSource:originRect
                         toResult:result];
      } else if (shareText) {
        [self shareText:shareText
                          subject:shareTitle
            excludedActivityTypes:excludedActivityTypes
                   withController:rootViewController
                         atSource:originRect
                         toResult:result];
      } else {
        result([FlutterError errorWithCode:@"error"
                                   message:@"No share content provided"
                                   details:nil]);
      }
    } else {
      result(FlutterMethodNotImplemented);
    }
  }];
}

+ (void)share:(NSArray *)shareItems
              withSubject:(NSString *)subject
    excludedActivityTypes:(NSArray<UIActivityType> *)excludedActivityTypes
           withController:(UIViewController *)controller
                 atSource:(CGRect)origin
                 toResult:(FlutterResult)result {
  UIActivityViewController *activityViewController =
      [[UIActivityViewController alloc] initWithActivityItems:shareItems
                                        applicationActivities:nil];

  activityViewController.excludedActivityTypes = excludedActivityTypes;

  // Force subject when sharing a raw url or files
  if (![subject isKindOfClass:[NSNull class]]) {
    [activityViewController setValue:subject forKey:@"subject"];
  }

  activityViewController.popoverPresentationController.sourceView =
      controller.view;
  BOOL isCoordinateSpaceOfSourceView =
      CGRectContainsRect(controller.view.frame, origin);

  // Check if this is actually an iPad
  BOOL isIpad = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);

  // Before Xcode 26 hasPopoverPresentationController is true for iPads and false for iPhones.
  // Since Xcode 26 is true both for iPads and iPhones, so additional check was added above.
  BOOL hasPopoverPresentationController =
      [activityViewController popoverPresentationController] != NULL;
  if (isIpad && hasPopoverPresentationController &&
      (!isCoordinateSpaceOfSourceView || CGRectIsEmpty(origin))) {
    NSString *sharePositionIssue = [NSString
        stringWithFormat:
            @"sharePositionOrigin: argument must be set, %@ must be non-zero "
            @"and within coordinate space of source view: %@",
            NSStringFromCGRect(origin),
            NSStringFromCGRect(controller.view.bounds)];

    result([FlutterError errorWithCode:@"error"
                               message:sharePositionIssue
                               details:nil]);
    return;
  }

  if (!CGRectIsEmpty(origin)) {
    activityViewController.popoverPresentationController.sourceRect = origin;
  }

  activityViewController.completionWithItemsHandler =
      ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems,
        NSError *activityError) {
        if (completed) {
          result(activityType);
        } else {
          result(@"");
        }
      };

  [controller presentViewController:activityViewController
                           animated:YES
                         completion:nil];
}

+ (void)shareUri:(NSString *)uri
    excludedActivityTypes:(NSArray<UIActivityType> *)excludedActivityTypes
           withController:(UIViewController *)controller
                 atSource:(CGRect)origin
                 toResult:(FlutterResult)result {
  NSURL *data = [NSURL URLWithString:uri];
  [self share:@[ data ]
                withSubject:nil
      excludedActivityTypes:excludedActivityTypes
             withController:controller
                   atSource:origin
                   toResult:result];
}

+ (void)shareText:(NSString *)shareText
                  subject:(NSString *)subject
    excludedActivityTypes:(NSArray<UIActivityType> *)excludedActivityTypes
           withController:(UIViewController *)controller
                 atSource:(CGRect)origin
                 toResult:(FlutterResult)result {
  NSObject *data = [[SharePlusData alloc] initWithSubject:subject
                                                     text:shareText];
  [self share:@[ data ]
                withSubject:subject
      excludedActivityTypes:excludedActivityTypes
             withController:controller
                   atSource:origin
                   toResult:result];
}

+ (void)shareFiles:(NSArray *)paths
             withMimeType:(NSArray *)mimeTypes
              withSubject:(NSString *)subject
                 withText:(NSString *)text
    excludedActivityTypes:(NSArray<UIActivityType> *)excludedActivityTypes
           withController:(UIViewController *)controller
                 atSource:(CGRect)origin
                 toResult:(FlutterResult)result {
  NSMutableArray *items = [[NSMutableArray alloc] init];

  for (int i = 0; i < [paths count]; i++) {
    NSString *path = paths[i];
    NSString *mimeType = mimeTypes[i];
    [items addObject:[[SharePlusData alloc] initWithFile:path
                                                mimeType:mimeType
                                                 subject:subject]];
  }
  if (text != nil) {
    NSObject *data = [[SharePlusData alloc] initWithSubject:subject text:text];
    [items addObject:data];
  }

  [self share:items
                withSubject:subject
      excludedActivityTypes:excludedActivityTypes
             withController:controller
                   atSource:origin
                   toResult:result];
}

@end
