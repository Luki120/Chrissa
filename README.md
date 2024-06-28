# Chrissa

* Straightforward weather framework built using Combine. It works by enabling location access on SpringBoard, therefore there's no need to open the weather app as the data refreshes instantly :tm:

## Usage

* Compile the project, run `make clean do` & everything will be done automatically
* Import Chrissa in your project `import Chrissa`
* Add the framework to your Makefile `TWEAK_EXTRA_FRAMEWORKS = Chrissa`
* Make Chrissa a dependency of your tweak in the control file `Depends: me.luki.chrissa`

---

Chrissa exposes two functions for you to use, the latter one is recommended only for objc compatibility. Check the [examples](./Examples) to see how to use them & their documentation
```swift
public func fetchWeather<T: Codable>(expecting type: T.Type = Weather.self) throws -> AnyPublisher<T, Error>

@objc
public func fetchWeather(completion: @escaping (Weather, String) -> Void) throws
```

## Socials

* [Twitter](https://twitter.com/Lukii120)

## Contributing

* Contributions are more than welcomed, but should follow this etiquette:

	* If you're a contributor with write access to this repository, you **should NOT** push to main branch, preferably push to a new one and *then* create the PR.
	* Keep commit titles short and then explain them in comments or preferably in the commit's description.
	* Push small commits (e.g if you changed 2 directories, commit one directory, then commit the other one and only THEN push)

## LICENSE

* [Mozilla Public License 2.0](https://www.mozilla.org/en-US/MPL/2.0/)

## Assets LICENSE

* Under no means shall the visual assets of this repository – i.e., all photo-, picto-, icono-, and videographic material – (if any) be altered and/or redistributed for any independent commercial or non-commercial intent beyond its original function in this project. Permissible usage of such content is restricted solely to its express application in this repository and any forks that retain the material in its original, unaltered form only.
