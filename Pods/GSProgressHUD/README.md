# GSProgressHUD

GSProgressHUD is a simple lightweight progress HUD for displaying information to the user.

![Screenshot1](https://dl.dropboxusercontent.com/u/7865025/github/GSProgressHUD/Screen%20Shot%202014-02-17%20at%2012.49.51.png)
![Screenshot2](https://dl.dropboxusercontent.com/u/7865025/github/GSProgressHUD/Screen%20Shot%202014-02-17%20at%2012.50.14.png)


## Get started

- [Download GSProgressHUD](https://github.com/GaSaMedia/GSProgressHUD/archive/master.zip)

#### Podfile

```ruby
platform :ios
pod "GSProgressHUD"
```

## Requirements

GSProgressHUD requires Xcode 4/5, targeting iOS 5.0 and above.

## Basic usage

#### Show GSProgressHUD in current view
```objective-c
[GSProgressHUD show];
```

```objective-c
[GSProgressHUD showImage:[UIImage imageNamed:@"check"] withStatus:@"Working..."];
```

#### Hide GSProgressHUD
```objective-c
if ([GSProgressHUD isVisible]) {
  [GSProgressHUD dismiss];
}
```

#### Pop (show/wait/hide) image with text
```objective-c
[GSProgressHUD popImage:[UIImage imageNamed:@"check"] withStatus:@"Working..."];
```

## Credits

GSProgressHUD is partly based upon [SVProgressHUD](https://github.com/samvermette/SVProgressHUD).

## Contact

Follow GaSa Media on Twitter [@gasamedia](https://twitter.com/gasamedia)

## License

GSProgressHUD is available under the MIT license. See the LICENSE file for more info.
