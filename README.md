<p align="center">
<img src = "Doc/FITSToolBanner@0.5x.png" alt="FitsTool">
</p>

<p align="center">
<a href="LICENSE">
<img src="https://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
</a>
<a href="https://swift.org">
<img src="https://img.shields.io/badge/swift-5.2-brightgreen.svg" alt="Swift 5.2">
</a>
</p>

A simple commad line tool to read FITS files

## Description

FITSTool is a command line tool to read, manipulate and write files conforming to the [FITS 4.0](https://fits.gsfc.nasa.gov/fits_standard.html) file format, commonly used to store astronomical data. 

| ![FITSCore](Doc/FITSCore128.png) | ![FITSCore](Doc/FITSKit128.png) | ![FITSCore](Doc/FITSTool128.png) |
| :---------------------------------------: | :---------------------------------------: | :---------------------------------------: | 
| [**FITSCore**](https://github.com/brampf/fitscore) | [**FITSKit**](https://github.com/brampf/fitskit) | [**FITSTool**](https://github.com/brampf/fitstool) |
|  Fits file format read & write  | Image rendering & manipulation | Command line tool |
|  macOS, iOS & Linux | iOS / macCatalyst | Linux |

## Documentation

### Usage

```
OVERVIEW: A Swift command-line tool to process FITS files

USAGE: fitstool <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  search (default)        Search through all headers.
  plot                    Plot headers and (optional) tables to stdout.
  verify                  Verify FITS files according to the 4.0 starndard.

  See 'fitstool help <subcommand>' for detailed help.
```

#### fitstool search
```
OVERVIEW: Search through all headers.

USAGE: fitstool search [<term>] [-v] [-r] [<path> ...]

ARGUMENTS:
  <term>                  The string to search for 
  <path>                  The path to the FITS file(s) 

OPTIONS:
  -v                      Show extra logging for debugging purposes 
  -r                      Recursive traversion through directories 
  -h, --help              Show help information.
```

#### fitstool plot
```
OVERVIEW: Plot headers and (optional) tables to stdout.

USAGE: fitstool plot [-t] [-v] [-r] [<path> ...]

ARGUMENTS:
  <path>                  The path to the FITS file(s) 

OPTIONS:
  -t                      Plot content of tables 
  -v                      Show extra logging for debugging purposes 
  -r                      Recursive traversion through directories 
  -h, --help              Show help information.
  
  ```

#### fitstool verify
```
OVERVIEW: Verify FITS files according to the 4.0 starndard.

USAGE: fitstool verify [-v] [-r] [<path> ...]

ARGUMENTS:
  <path>                  The path to the FITS file(s) 

OPTIONS:
  -v                      Show extra logging for debugging purposes 
  -r                      Recursive traversion through directories 
  -h, --help              Show help information.


```


## License

MIT license; see [LICENSE](LICENSE.md).
(c) 2020
