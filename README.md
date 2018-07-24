# r-dyntrace

There will be three docker volumes:

- `r-cran-mirror` - CRAN mirror populated by `create-cran-mirror.sh` script
- `r-packages` - installed packages populated by `install-packages.sh` script
- `r-src-packages` - extracted sources of installed packages populated by `extract-package-sources.sh` script

The `run.sh` mounts all the volume into a disposable container.

## Usage

1. build the image

```sh
$ ./build.sh
```

R-dyntrace will be installed in `/`. Sources will be in `/R-dyntrace`.

2. create the `r-cran-mirror` volume, downloading all CRAN packages

```sh
$ ./create-cran-mirror.sh
```

The mirror will be in `/CRAN/src/contrib`.

3. install packages

```sh
$ ./install-packages.sh
```

The packages will be installed in `/R/installed`.

4. extract packages

```sh
$ ./extract-package-sources.sh
```

The sources will be in `/R/sources`.

5. run

```sh
$ ./run.sh
```

It will start R-dyntrace by default with `R_LIBS` set to `/R/installed`.
