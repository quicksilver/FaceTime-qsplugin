//
//  QSFacetimeAction.m
//  QSFacetime
//
//  Created by Rob McBroom on 2012/10/22.
//

#import "QSFacetimeAction.h"

@implementation QSQSFacetimeActionProvider

- (QSObject *)facetime:(QSObject *)dObject
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
        NSLog(@"unable to initiate FaceTime: %@", [dObject stringValue]);
        NSBeep();
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
