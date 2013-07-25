# mrk.sed

sed script to parse mrk markup

## Supported Syntax

### Headers

mrk supports two styles of headers:

#### Underlined

    This is a h1 header
    ===================

    This is a h2 header
    --------

    This is a h3 header
    ~~~~~~~~~~~~~~~~~~~~~~

#### Surrounded (with optional closing)

    = This is a h1 Header =

    == This is a h2 Header

    === This is a h3 Header ======

### Emphasis

    *bold*
    ~italic~
    $monospace$
    _underlined_
    -strikeout-

### Images

    [image.png]
    [image.gif]
    [image.jpeg]
    [image.JPG]

### Links

    http://anonymous.link
    [Named Link http://named.link]
    [InternalLink]
    [#Label]
