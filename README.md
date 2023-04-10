![Nitroxomat][Nitroxomat-logo]

[![badge-language]][swift.org]

# Nitroxomat

Simple app that shows relation between maximum ppO2, breathing gas mix
and maximum depth.


## A Thousand Words ..

![Nitroxomat Screenshot](images/screenshot-222x480.png "Nitroxomat Screenshot")


## Issues

There are some issues to resove:
1. With Xcode 14.2 the mechanism to write the `Info.plist` file and
   use it does not work: the version stays on 1.0. With Xcode 13.2.1
   it works as excpected. Is the `Info.plist` file not copied?

Other have the same problem [Xcode 14 and missing sync with
CFBundleVersion edit in Info.plist during
Build/Archive](https://stackoverflow.com/questions/73906151/xcode-14-and-missing-sync-with-cfbundleversion-edit-in-info-plist-during-build-a)
and [How to update MARKETING_VERSION and CFBundleVersion from plist
file?](https://stackoverflow.com/questions/73630297/how-to-update-marketing-version-and-cfbundleversion-from-plist-file).

[Xcode 13 Missing Info.plist](https://useyourloaf.com/blog/xcode-13-missing-info.plist/) gives some info on what might be going on.

In [How to stop Xcode 11 from changing CFBundleVersion and
CFBundleShortVersionString to $(CURRENT_PROJECT_VERSION) and
$(MARKETING_VERSION)?](https://stackoverflow.com/questions/58235419/how-to-stop-xcode-11-from-changing-cfbundleversion-and-cfbundleshortversionstrin)
the same script mechanism is used in a `Build/Pre-action` in `Scheme`.


## License

![License](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png)
This work is licensed under a [Creative Commons Attribution-Non Commercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/).

[Nitroxomat-logo]: https://raw.githubusercontent.com/borisboesler/Nitroxomat/main/ReadMeImages/Nitroxomat-logo.png

[swift.org]: https://swift.org/
[license]: http://creativecommons.org/licenses/by-nc-sa/4.0/


[badge-language]: https://img.shields.io/badge/Swift-4.x%20%7C%205.x-orange.svg?style=flat
