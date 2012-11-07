//
//  QSFacetimeAction.m
//  QSFacetime
//
//  Created by Rob McBroom on 2012/10/22.
//

#import "QSFacetimeAction.h"

@implementation QSQSFacetimeActionProvider

- (QSObject *)startFaceTimeWith:(QSObject *)dObject
{
    NSString *contactString = nil;
    NSURL *facetimeURL = nil;
    if ([[dObject primaryType] isEqualToString:QSContactPhoneType]) {
        NSString *phoneNumber = [dObject objectForType:QSContactPhoneType];
        // remove non-numeric characters
        NSCharacterSet *nonNumeric = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        contactString = [[phoneNumber componentsSeparatedByCharactersInSet:nonNumeric] componentsJoinedByString:@""];
    } else if ([dObject containsType:QSEmailAddressType]) {
        // this could be a literal e-mail address or a contact
        // for the latter, it's unlikely to do what you want, but it's something
        contactString = [dObject objectForType:QSEmailAddressType];
    }
    if (contactString) {
        facetimeURL = [NSURL URLWithString:[NSString stringWithFormat:@"facetime://%@", contactString]];
    }
    if (facetimeURL) {
        [[NSWorkspace sharedWorkspace] openURL:facetimeURL];
    } else {
        NSString *localizedErrorFormat = NSLocalizedStringFromTableInBundle(@"Unable to initiate FaceTime with %@", nil, [NSBundle bundleForClass:[self class]], nil);
        NSString *localizedTitle = NSLocalizedStringFromTableInBundle(@"Quicksilver FaceTime Error", nil, [NSBundle bundleForClass:[self class]], nil);
        NSString *errorMessage = [NSString stringWithFormat:localizedErrorFormat, [dObject displayName]];
        QSShowNotifierWithAttributes([NSDictionary dictionaryWithObjectsAndKeys:@"QSFaceTimeFailed", QSNotifierType, [QSResourceManager imageNamed:@"AlertStopIcon"], QSNotifierIcon, localizedTitle, QSNotifierTitle, errorMessage, QSNotifierText, nil]);
    }
    return nil;
}

- (NSArray *)validActionsForDirectObject:(QSObject *)dObject indirectObject:(QSObject *)iObject
{
    if ([dObject count] == 1) {
        return [NSArray arrayWithObject:@"QSFacetimeAction"];
    }
    return nil;
}

@end
