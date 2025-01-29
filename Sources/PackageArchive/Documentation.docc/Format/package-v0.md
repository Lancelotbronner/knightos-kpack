# KnightOS Package v0

@Metadata {
	@TitleHeading("Specification")
}

Specification of the KnightOS package format version 0.

## Overview

### Preface

KnightOS packages contain a number of files and the paths they should be extracted to, as well as some metadata.

This document uses a similar format to the gzip specification.
That is:

In the diagrams below, a box like this:

```
+---+
|   | <-- the vertical bars might be missing
+---+
```

represents one byte; a box like this:

```
+==============+
|              |
+==============+
```

represents a variable number of bytes. 

### Header

The file begins with a short header, containing a magic number and the format version:

```
+======+---------+
| KPKG | Version |
+======+---------+
```

`KPKG` is ASCII-encoded.
The version is an unsigned 8-bit integer.
The current version is `0`.

### Metadata Section

This is followed by the metadata section.
It is a simple key-value pair system, with unsigned 8-bit integer keys.
Each key is followed by the length of the value, and then some key-specific value format follows for *VLEN* bytes.

```
+-----+-----+------+=======+
| LEN | Key | VLEN | Value | (more-->)
+-----+-----+------+=======+
```

The key/value pairs are repeated *LEN* times.
Keys from `0x00`-`0x7F` (inclusive) are reserved for future or current use, and keys from `0x80`-`0xFF` are available for arbitrary use.

#### Formally Specified Keys

The following keys are currently included in this specification:

- term `KEY_PKG_NAME` (`0x00`):

An ASCII string with the name of the package (i.e. "`corelib`").

- term `KEY_PKG_REPO` (`0x01`): 

An ASCII string with the name of the package repository (i.e. "`core`").

- term `KEY_PKG_DESCRIPTION` (`0x02`):
An ASCII string with the user-friendly package description.

- term `KEY_PKG_DEPS` (`0x03`):
	Lists packages that this package depends on:
  
	```
	+-----+=========+------+======+
	| LEN | VERSION | NLEN | NAME | (more-->)
	+-----+=========+------+======+
	```

  *LEN* is the total number of packages that this package depends on.
	The packager may choose to include additional packages in this same package file, to fulfill its dependencies.

	Each dependency is then listed with its full name (i.e. "`core/corelib`"), prefixed by the length *NLEN*.

	*VERSION* is the minimum version of this package required, as described below in the specification for `KEY_PKG_VERSION`.
	If the version is set to `0.0.0`, it is assumed that any version is acceptable.

- term `KEY_PKG_VERSION` (`0x04`):
	The package version takes the form of:
  
	```
	+-------+-------+-------+
	| MAJOR | MINOR | PATCH |
	+-------+-------+-------+
	```
  
	Packages are encouraged to use semantic versioning, by incrementing *MINOR* when new features are added, *MAJOR* when breaking changes are introduced, and *PATCH* for simple fixes.

- term `KEY_PKG_AUTHOR` (`0x05`): 
	The author of this software, as an ASCII string.

- term `KEY_PKG_MAINTAINER` (`0x06`):
	The author of the package (may be different from the author of the software), as an ASCII string.

- term `KEY_PKG_COPYRIGHT` (`0x07`):
	The license name or copyright, as an ASCII string.

- term `KEY_INFO_URL` (`0x08`):
	The fully qualified URL where information about this package may be obtained, usually the source code or documentation.
- term `KEY_CAPABILITIES` (`0x09`):
	Describes any device capabilities this package requires.
	For example, this package may require USB support.
	The format of this field is loosely specified -- there are just a list of strings provided in the config here.

	```
	+-----+------+======+
	| LEN | NLEN | NAME | (more-->)
	+-----+------+======+
	```

	*LEN* is the number of requirements.

	*NLEN* is the length of each requirement, which is followed by the requirement string.

	The following requirements are formally defined:

	- `color`: Requires a color display
	- `usb`: Requires a USB port
	- `clock`: Requires a real-time clock
	- `extraram`: Requires 8 pages of RAM

Prepending `KEY_PKG_REPO` to `KEY_PKG_NAME` gives you the full name of the package (i.e. "`core/corelib`").

### Files Section

Finally, a list of files included in this package follows.

First, a *LEN* byte with the total number
of files.
Then, a number of file entries follows:

```
+------+======+-------+======+======+======+---------+==========+
| PLEN | PATH | CTYPE | ULEN | FLEN | FILE | SUMTYPE | CHECKSUM | (more-->)
+------+======+-------+======+======+======+---------+==========+
```

The path is specified first, prefixed by the length of the path.
This is the full path the file should be written to on extraction.

*CTYPE* specifies the compression algorithm used.
Currently implemented algorithms include:

- term `COMPRESSION_UNCOMPRESSED` (`0x00`):
	This file is entirely uncompressed.

- term `COMPRESSION_RLE` (`0x01`):
	This file uses run-length-encoding, KnightOS format.

- term `COMPRESSION_PUCRUNCH` (`0x02`):
	This file uses Pucrunch.

The uncompressed length of the file follows (as a 24-bit unsigned integer, little endian), and then the length of the compressed data (same integer format), and the data itself.

The type of checksum used is next:

- term `SUM_NOSUM` (`0x00`):
	There is no checksum, and the *CHECKSUM* is 0 bytes.

- term `SUM_CRC16` (`0x01`):
	The checksum is a CRC-16 of this file.

- term `SUM_SHA1` (`0x02`):
	The checksum is the SHA-1 digest of this file.

- term `SUM_MD5` (`0x03`):
	The checksum is the MD5 digest of this file.

This is the last section included in the package.

### After installation

After install, a package stub is created in `/var/packages/` that takes this format:

1. The metadata from the original package
2. The file list, less the file contents (just the *PLEN* and *PATH* fields)

The information in the stub is sufficient to uninstall packages.
