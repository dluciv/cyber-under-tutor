#!/usr/bin/python3

import yaml
import anybadge
import sys

score = float(sys.argv[1])
cclog = sys.stdin.read()

report = {
  'score'  : score,
  'message': cclog
}

score_promille = str(round(score * 1000))

with open(sys.argv[2] + '.yml', 'w', encoding='utf-8' ) as y:
  yaml.dump(report, y)

badge = anybadge.Badge('Кибердядька', score_promille, thresholds={0: 'red', 500: 'orange', 750: 'yellow', 900: 'green'}, value_suffix='‰', num_padding_chars=1)
badge.write_badge(sys.argv[2] + '.svg')
