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

### Lists

  mrk supports two types of lists: enumerate and bullets. The idention
  rule is 2 spaces. And the supported maximal indetion level is 4, which
  equals 8 spaces.

    1. list item 1
    2. list item 2
      1. sub list item 1
        12. sub sub list item 1
      8. sub really long
         list item 2
        0. sub sub list item 2
    3. list item 3

    - bullet item 1
    - bullet item 2
      - sub bullet item 1
      - sub bullet item 2
        - a long but unindented
    sub sub bullet item 1
    - bullet item 3
