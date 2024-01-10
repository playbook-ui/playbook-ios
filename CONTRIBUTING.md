# 📘 Contributing to Playbook 📘

Thanks for your interest in Playbook.  
There are a few things you need to know to smoothly incorporate your opinions or codes.  

## 📝 Open Issue

When you found a bug or having a feature request, search for the issue from the existing and feel free to open the issue after making sure it's not already reported.  
Please include as much information as possible in the issue template.  
Screenshots are a great clue to understanding your issue.
If you know exactly how to fix the bug you report or implement the feature you propose, please pull request instead of opening an issue.  

## 🚀 Pull Request

We are highly welcome to your pull request.  
If you want to add a new feature, let's discuss about it on issue ahead.  

### Getting Started

To run project, install dependencies and open workspace as following commands.  

```bash
$ git clone https://github.com/playbook-ui/playbook-ios.git
$ cd playbook-ios
$ open Example/PlaybookExample.xcodeproj
```

### Lint & Format & Project Generation

We are using [swift-format](https://github.com/apple/swift-format) to do lint and format our codes, and using [XcodeGen](https://github.com/yonaskolb/XcodeGen).  

When you finished writing codes to contribute, please format, lint your code and re-generate a Xcode project with the following command before submitting a pull request.

```sh
make all & make lint
```

### Test

All codes in the master must pass all tests.  
If you change the code or add new features, please add tests corresponding to your implementation.  

### Documentation

Please write the document using [Xcode markup](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/) to the code you added.  
Documentation template is inserted automatically by using Xcode shortcut **⌥⌘/**.  
Our document style is different from the template a little. The example is below.  

```swift
/// The example class for documentation.
final class Foo {
    /// A property value.
    let prop: Int

    /// Create a new foo with a param.
    ///
    /// - Parameters:
    ///   -  param: An Int value for prop.
    init(param: Int) {
        prop = param
    }

    /// Returns a string value concatenating `param1` and `param2`.
    ///
    /// - Parameters:
    ///   - param1: An Int value for prefix.
    ///   - param2: A String value for suffix.
    ///
    /// - Returns: A string concatenating given params.
    func bar(param1: Int, param2: String) -> String {
        return "\(param1)" + param2
    }
}
```

## [Developer's Certificate of Origin 1.1](https://elinux.org/Developer_Certificate_Of_Origin)
By making a contribution to this project, I certify that:

(a) The contribution was created in whole or in part by me and I
    have the right to submit it under the open source license
    indicated in the file; or

(b) The contribution is based upon previous work that, to the best
    of my knowledge, is covered under an appropriate open source
    license and I have the right under that license to submit that
    work with modifications, whether created in whole or in part
    by me, under the same open source license (unless I am
    permitted to submit under a different license), as indicated
    in the file; or

(c) The contribution was provided directly to me by some other
    person who certified (a), (b) or (c) and I have not modified
    it.

(d) I understand and agree that this project and the contribution
    are public and that a record of the contribution (including all
    personal information I submit with it, including my sign-off) is
    maintained indefinitely and may be redistributed consistent with
    this project or the open source license(s) involved.
