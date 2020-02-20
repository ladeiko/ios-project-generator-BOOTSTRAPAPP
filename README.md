# BOOTSTRAPAPP

## Project structure

* [BOOTSTRAPAPP](BOOTSTRAPAPP) - contains all resources, source code, icons.
 * [BOOTSTRAPAPP/Icon/AppIcon.png](BOOTSTRAPAPP/Icon/AppIcon.png) - application icon, all sizes will be generated automatically, just place your icon here.
 * [BOOTSTRAPAPP](BOOTSTRAPAPP) - contains all resources, source code, icons.
* [BOOTSTRAPAPPTests](BOOTSTRAPAPPTests) - contains all unit tests code.
* [BOOTSTRAPAPPUITests](BOOTSTRAPAPPUITests) - contains all UI tests code.
* [External](External) - external code.
 * [External/Submodules](External/Submodules) - external code included as git submodules.
 *  [External/ThirdParty](External/ThirdParty) - external code included as source code.
*  [Scripts](Scripts) - helper scripts for building, compiling code and resources.
*  [Templates](Templates) - folder is generated automatically and contains generamba templates.

## Configuration

### Common constants for Debug & Release
* [BOOTSTRAPAPP/Sources/Config/Common.swift](BOOTSTRAPAPP/Sources/Config/Common.swift)

### Constants for Debug
* [BOOTSTRAPAPP/Sources/Config/Debug.swift](BOOTSTRAPAPP/Sources/Config/Debug.swift)

### Constants for Release
* [BOOTSTRAPAPP/Sources/Config/Release.swift](BOOTSTRAPAPP/Sources/Config/Release.swift)

## Code Generator

Just open terminal in project folder and type
```
./generator
```

## Testing

### From terminal

Open terminal in project folder and run:

```
./generator test
```

### From Xcode

Open project Xcode workspace and press keys *Cmd+U*

## License

See [LICENSE](LICENSE)
