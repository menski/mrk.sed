#!/bin/sed -nf

# if empty line handle block
/^\s*$/ {
  b block
}

# put first line into the hold buffer
1h
# else append to hold buffer
1!H
# if last line handle block
$ b block
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

:image
  s!\[\([^]]\+\)\]!<img src="\1"/>!
  b markup

:enumerate
  # remove line break for multi line items
  s!\n\s*\([^ 0-9]\)! \1!g
  # replace leading spaces by count
  s!\(^\|\n\)\([0-9]\)!\10 \2!g
  s!\(^\|\n\) \{2\}\([0-9]\)!\12 \2!g
  s!\(^\|\n\) \{4\}\([0-9]\)!\14 \2!g
  s!\(^\|\n\) \{6\}\([0-9]\)!\16 \2!g
  s!\(^\|\n\) \{8\}\([0-9]\)!\18 \2!g
  # add opening ol tags
  s!\(^\|\n\)\(0 [^\n]\+\)\(\n2 \)!\1\2\n<ol>\3!g
  s!\(^\|\n\)\(2 [^\n]\+\)\(\n4 \)!\1\2\n<ol>\3!g
  s!\(^\|\n\)\(4 [^\n]\+\)\(\n6 \)!\1\2\n<ol>\3!g
  s!\(^\|\n\)\(6 [^\n]\+\)\(\n8 \)!\1\2\n<ol>\3!g
  # add closing ol tags
  s!\(^\|\n\)\(8 [^\n]\+\)\(\n6 \)!\1\2\n</ol>\3!g
  s!\(^\|\n\)\(8 [^\n]\+\)\(\n4 \)!\1\2\n</ol>\n</ol>\3!g
  s!\(^\|\n\)\(8 [^\n]\+\)\(\n2 \)!\1\2\n</ol>\n</ol>\n</ol>\3!g
  s!\(^\|\n\)\(8 [^\n]\+\)\(\n0 \)!\1\2\n</ol>\n</ol>\n</ol>\n</ol>\3!g
  s!\(^\|\n\)\(4 [^\n]\+\)\(\n2 \)!\1\2\n</ol>\3!g
  s!\(^\|\n\)\(4 [^\n]\+\)\(\n0 \)!\1\2\n</ol>\n</ol>\3!g
  s!\(^\|\n\)\(2 [^\n]\+\)\(\n0 \)!\1\2\n</ol>\3!g
  # surround with li elements
  s!\(^\|\n\)[0-8] [0-9]\+\.\s*\([^\n]\+\)!\1<li>\2</li>!g
  # surround whole list with ol tags
  s!^\(.*\)$!<ol>\n\1\n</ol>!
  b markup

:itemize
  # remove line break for multi line items
  s!\n\s*\([^- ]\)! \1!g
  # replace leading spaces by count
  s!\(^\|\n\)-!\10-!g
  s!\(^\|\n\) \{2\}-!\12-!g
  s!\(^\|\n\) \{4\}-!\14-!g
  s!\(^\|\n\) \{6\}-!\16-!g
  s!\(^\|\n\) \{8\}-!\18-!g
  # add opening ul tags
  s!\(^\|\n\)\(0-[^\n]\+\)\(\n2-\)!\1\2\n<ul>\3!g
  s!\(^\|\n\)\(2-[^\n]\+\)\(\n4-\)!\1\2\n<ul>\3!g
  s!\(^\|\n\)\(4-[^\n]\+\)\(\n6-\)!\1\2\n<ul>\3!g
  s!\(^\|\n\)\(6-[^\n]\+\)\(\n8-\)!\1\2\n<ul>\3!g
  # add closing ul tags
  s!\(^\|\n\)\(8-[^\n]\+\)\(\n6-\)!\1\2\n</ul>\3!g
  s!\(^\|\n\)\(8-[^\n]\+\)\(\n4-\)!\1\2\n</ul>\n</ul>\3!g
  s!\(^\|\n\)\(8-[^\n]\+\)\(\n2-\)!\1\2\n</ul>\n</ul>\n</ul>\3!g
  s!\(^\|\n\)\(8-[^\n]\+\)\(\n0-\)!\1\2\n</ul>\n</ul>\n</ul>\n</ul>\3!g
  s!\(^\|\n\)\(4-[^\n]\+\)\(\n2-\)!\1\2\n</ul>\3!g
  s!\(^\|\n\)\(4-[^\n]\+\)\(\n0-\)!\1\2\n</ul>\n</ul>\3!g
  s!\(^\|\n\)\(2-[^\n]\+\)\(\n0-\)!\1\2\n</ul>\3!g
  # surround with li elements
  s!\(^\|\n\)[0-8]-\s*\([^\n]\+\)!\1<li>\2</li>!g
  # surround whole list with ul tags
  s!^\(.*\)$!<ul>\n\1\n</ul>!
  b markup

# handle block
:block
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
  # transform heading starting with =
  /^\s*=/ b heading_starting
  # transform heading underlined = - ~
  /\n\s*\(===\+\|---\+\|~~~\+\)/ b heading_underline
  # transform bold
  s!\*\([^\*]*\)\*!<b>\1</b>!g
  # transform italic
  s!\~\([^\~]*\)\~!<i>\1</i>!g
  # transform monospace
  s!\$\([^\$]*\)\$!<code>\1</code>!g
  # transform underline
  s!_\([^_]*\)_!<u>\1</u>!g
  # transform strikeout
  s!-\(\S[^-]*\)-!<del>\1</del>!g
  # transform images
  /\[[^]]\+.\(png\|jpg\|jpeg\|gif\)\]/I b image
  # transform link
  s!\[\(.\+\)\s\(\w\+://\S\+\)\]!<a href="\2">\1</a>!g
  s!\(^\|\s\)\(\w\+://\S\+\)\($\|\s\)!<a href="\2">\2</a>!g
  s!\(\S\+\)\s\[\#\([^]]\+\)\]!<a id="\2">\1</a>!g
  s!\(\S\+\)\s\[\([^]]\+\)\]!<a href="#\2">\1</a>!g
  # transform list
  /^[0-9]\+\.\s/ b enumerate
  /^-\s/ b itemize

  # add paragraph tag if not a header
  /^\s*<\(h\|ol\|ul\)/ !{
    i <p>
    a </p>
  }
  p
  # quit if last line
  $ q
  # get next line if not last
  n
  # exchange line with hold buffer
  x
  # print former hold buffer
  p
  # if last line parse block
  $ b block
