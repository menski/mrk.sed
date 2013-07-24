# if empty line handle paragraph
/^\s*$/ {
  b para
}

# put first line in hold buffer
1h
# else append to hold buffer
1!H
# if last line handle paragraph
$ b para
# else continue with next line
b

:heading1
  # remove trailing space and =
  s!\s*=\+\s*$!!
  # replace with html tags h1 h2 h3
  s!^\s*=\s*\([^=]\+\)$!<h1>\1</h1>!
  s!^\s*==\s*\([^=]\+\)$!<h2>\1</h2>!
  s!^\s*===\s*\([^=]\+\)$!<h3>\1</h3>!
  b markup

:heading2
  s!^\s*\(.*\)\n\s*===\+\s*$!<h1>\1</h1>!
  s!^\s*\(.*\)\n\s*---\+\s*$!<h2>\1</h2>!
  s!^\s*\(.*\)\n\s*~~~\+\s*$!<h3>\1</h3>!
  b markup

# handle paragraph
:para
  # get hold buffer
  x
  # if hold buffer empty skip
  /^\s*$/ {
    p
    n
    x
    b
  }
  # else handle markup
  b markup

:markup
  # found heading starting with =
  /^\s*=/ b heading1
  # found heading underlined = - ~
  /\n\s*\(===\+\|---\+\|~~~\+\)/ b heading2
  p
  # get next line if not last
  $! n
  x
  $! p
