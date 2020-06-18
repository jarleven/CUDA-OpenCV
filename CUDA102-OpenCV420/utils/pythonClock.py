import sys
import random
import argparse
import numpy as np


def preamble(fo):
    """The SVG preamble and styles."""

    print('<?xml version="1.0" encoding="utf-8"?>\n'

    '<svg xmlns="http://www.w3.org/2000/svg"\n' + ' '*5 +
       'xmlns:xlink="http://www.w3.org/1999/xlink" width="{}" height="{}" >'
            .format(width, height), file=fo)

    print("""
        <defs>
        <style type="text/css"><![CDATA[""", file=fo)

    print('circle {fill:none; stroke-width: 2px; stroke: #000;}', file=fo)
    print('circle.centre-circ {fill:#000;}', file=fo)
    print('line {stroke-width: 2px; stroke: #000;}', file=fo)
    print('text {dominant-baseline: middle; text-anchor:middle;'
          '      font-family:Arial,Helvetica;font-size: 20pt;'
          '      font-weight: bold;}', file=fo)
    print('text.min-labels {font-size: 14pt; font-weight: normal;}', file=fo)
    print('line.mn-hand {stroke-width: 4px; stroke: #f00;}', file=fo)
    print('line.hr-hand {stroke-width: 12px; stroke: #000;}', file=fo)

    print("""]]></style>
    </defs>""", file=fo)

def make_clock_face(fo, cx, cy, r):
    """Make the clock face, with numbers and ticks."""

    print('<circle cx="{}" cy="{}" r="{}"/>'.format(cx, cy, r), file=fo)

    def add_tick(x, y, length):
        """Add a tickmark of specifed length at position (x, y)."""

        x1, y1 = (r-length)*x + cx, (r-length)*y + cy
        x2, y2 = r*x + cx, r*y + cy
        print('<line x1="{}" y1="{}" x2="{}" y2="{}"/>'.format(x1,y1,x2,y2),
              file=fo)
    hr = -1
    for mn in range(60):
        th = np.pi/30 * mn - np.pi/3
        x, y = np.cos(th), np.sin(th)
        if mn // 5 > hr:
            # This tick is an hour tick so it's a bit longer
            hr += 1 
            xt, yt = (r-40)*x + cx, (r-40)*y + cy
            print('<text x="{}" y="{}">{}</text>'.format(xt,yt,str(hr+1)),
                  file=fo)
            if min_ticks and min_ticklabels:
                xt, yt = (r+20)*x + cx, (r+20)*y + cy
                print('<text x="{}" y="{}" class="min-labels">{}</text>'
                      .format(xt,yt,str((hr+1)*5 % 60)), file=fo)
            add_tick(x, y, 20)
            continue
        if min_ticks:
            # A regular minute tick
            add_tick(x, y, 10)
    print('<circle cx="{}" cy="{}" r="10" class="centre-circ"/>'
                                            .format(cx, cy), file=fo)


def add_clock_hands(fo, cx, cy, r, time):
    """Add the clock hands indicating the provided time."""

    hr, mn = [int(f) for f in time.split(':')]
    assert 0 < hr <= 12
    assert 0 <= mn < 60

    def hand_line(x2, y2, cls):
        print('<line x1="{}" y1="{}" x2="{}" y2="{}" class="{}"/>'.format(
            cx, cy, x2, y2, cls), file=fo)

    # minutes
    th = np.pi/30 * mn - np.pi/2
    x, y = np.cos(th), np.sin(th)
    x2, y2 = r*0.7*x + cx, r*0.7*y + cy
    hand_line(x2, y2, 'mn-hand')

    # hours
    th = np.pi/6 * hr - np.pi/2 + mn / 60 * np.pi / 6
    x, y = np.cos(th), np.sin(th)
    x2, y2 = r*0.5*x + cx, r*0.5*y + cy
    hand_line(x2, y2, 'hr-hand')

def add_clock(cx, cy, r, time):
    """Add a clock indicating the given time centred at cx,cy."""

    add_clock_hands(fo, cx, cy, r, time)
    make_clock_face(fo, cx, cy, r)


parser = argparse.ArgumentParser(description='Create clock faces to help'
    ' learning the time.')
parser.add_argument('n', help='The number of clocks to draw',
    default=1, type=int, )
parser.add_argument('-d', help='The number of clocks to draw',
    default=1, type=int, )
parser.add_argument('-T', '--no-minute-ticks', dest='no_min_ticks',
    help='Suppress minute tick marks around the inside of the clock',
    default=False, action='store_true')
parser.add_argument('-L', '--no-minute-ticklabels', dest='no_min_ticklabels',
    help='Suppress minute tick labels around the outside of the clock',
    default=False, action='store_true')
args = parser.parse_args()
min_ticks = not args.no_min_ticks
min_ticklabels = not args.no_min_ticklabels
n = args.n
#assert n in (1, 2, 4, 6)
#ncols = 1
#if n > 2:
#    ncols = 2
#nrows = n // ncols

hr = args.n
mn = args.d

#times = get_random_times(n, difficulty)



ncols=1
nrows=1

#hr = 12
#mn = 55

times = []
times.append('{}:{}'.format(hr,mn))



# We've got the parameters: los geht's!
width = 800
height = 800 * nrows // ncols
cwidth = cheight = width // ncols
r = cwidth * 0.4
with open('/home/jarleven/time.svg', 'w') as fo:
    preamble(fo)
    for i, time in enumerate(times):
        print('{:2d}:{:02d}'.format(*[int(s) for s in time.split(':')]))
        cy = (i // ncols) * cwidth + cwidth // 2
        cx = (i % ncols) * cheight + cheight // 2
        add_clock(cx, cy, r, time)
    print('</svg>', file=fo)

