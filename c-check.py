#!/usr/bin/env python3

import yaml
import anybadge
import sys
from xml.dom.minidom import parseString

cc_lines = int(sys.argv[2])
cc_lines_per_msg = int(sys.argv[3])

cc_xml = sys.stdin.read()
cc_dom = parseString(cc_xml)
cc_msgs = sum(len(cc_dom.getElementsByTagName(t)) for t in ['error', 'warning', 'style', 'portability'])

cc_score = 1.0 - cc_msgs * cc_lines_per_msg / max(cc_lines, 1)

tot_score = cc_score
tot_msgs  = cc_msgs
tot_lines = cc_lines

report = {
  'tot_score': tot_score,
  'cc_messages': cc_msgs
  'cc_report': cc_xml
}

with open(sys.argv[1] + '.yml', 'w', encoding='utf-8' ) as y:
  yaml.dump(report, y)

score_promille = str(round(tot_score * 100))
badge = anybadge.Badge('Кибердядька', score_promille, thresholds={0: 'red', 50: 'orange', 90: 'yellow', sys.maxsize: 'green'}, value_suffix='%', num_padding_chars=1)
badge.write_badge(sys.argv[1] + '.svg', overwrite=True)

print(f"Messages: {tot_msgs}")
print(f"Penalty: {1-tot_score}")
print(f"Scope:   {tot_score}")

print(f"::set-output name=tot-lines::{tot_lines}")
print(f"::set-output name=tot-msgs::{tot_msgs}")
print(f"::set-output name=tot-score::{tot_score}")
