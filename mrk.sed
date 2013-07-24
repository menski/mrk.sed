# if empty line handle paragraph
/^\s*$/ {
  b para
}

# put first line into the hold buffer
1h
# else append to hold buffer
1!H
# if last line handle paragraph
$ b para
# else continue with next line
b

:heading_starting
  # remove trailing space and =
  s!\s*=\+\s*$!!
  # replace with html tags h1 h2 h3
  s!^\s*=\s*\([^=]\+\)$!<h1>\1</h1>!
  s!^\s*==\s*\([^=]\+\)$!<h2>\1</h2>!
  s!^\s*===\s*\([^=]\+\)$!<h3>\1</h3>!
  # continue processing markup
  b markup

:heading_underline
  # replace with html tags h1 h2 h3
  s!^\s*\(.*\)\n\s*===\+\s*$!<h1>\1</h1>!
  s!^\s*\(.*\)\n\s*---\+\s*$!<h2>\1</h2>!
  s!^\s*\(.*\)\n\s*~~~\+\s*$!<h3>\1</h3>!
  # continue processing markup
  b markup

# handle paragraph
:para
  # get hold buffer
  x
  # if hold buffer empty skip
  /^\s*$/ {
    # print empty line
    p
    # get next line line
    n
    # put it into the hold buffer
    h
    # continue with next line
    b
  }
  # else handle markup
  b markup

:markup
  # found heading starting with =
  /^\s*=/ b heading_starting
  # found heading underlined = - ~
  /\n\s*\(===\+\|---\+\|~~~\+\)/ b heading_underline
  p
  # quit if last line
  $ q
  # get next line if not last
  n
  # exchange line with hold buffer
  x
  # print former hold buffer
  p
