<p align="center">
  <img src="Demo/banner.png" height="100px"/>
</p>

A mac touchbar application similar to google chrome's Dino runner. Includes tracking highscores through the machine's local storage. Can be built into a complete app.

Scores are tracked as a time counter. The longer you survive, the higher your score will be. If your score breaks the highscore, you update the highscore which is visible when the app starts up again.

| Menu                 |
| -------------------- |
|![Menu](Demo/menu.png)|

| Gameplay                      |
| ----------------------------- |
|![Demo Gif](Demo/bananaMan.gif)|

## Getting Started

### Prerequisites

* A Mac computer
* Ensure you have the latest version of Xcode.
* A Macbook pro with a touchbar is <b>not</b> needed! You can simulate a touchbar window in Xcode by going to
<br>`Window -> Show Touch Bar`
* If you are using the physical touchbar, ensure that in `System Preferences -> Keyboard -> Touch Bar Shows` is set to either `App Controls` or `App Controls with Control Strip`. This will enable your Mac to show app specific touchbar features, which is required for the BananaMan app.

### Installing

* Clone this repo.

```
git clone https://github.com/jacobsteves/BananaMan.git
```

* Open `BananaMan/BananaMan` in Xcode, clean and build and you're ready to go!

## Built With

* [Xcode](https://developer.apple.com/xcode/) - Xcode, mac development IDE
* [SpriteKit](https://developer.apple.com/documentation/spritekit) - Sprite framework
* [Swift4](https://swift.org/blog/swift-4-0-released/) - Language

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/jacobsteves/BananaMan/tags).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
