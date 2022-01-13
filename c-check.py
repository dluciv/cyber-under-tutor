#!/usr/bin/env python3

import yaml
import sys
from xml.dom.minidom import parseString

cc_lines = int(sys.argv[2])
cc_lines_per_msg = int(sys.argv[3])

with open(sys.argv[4], encoding='utf-8') as xf:
  cc_xml = xf.read()
with open(sys.argv[5], encoding='utf-8') as lf:
  cc_log = lf.read()

cc_dom = parseString(cc_xml)
cc_msgs = sum(len(cc_dom.getElementsByTagName(t)) for t in ['error', 'warning', 'style', 'portability'])

cc_score = 1.0 - cc_msgs * cc_lines_per_msg / max(cc_lines, 1)

tot_score = cc_score
tot_msgs  = cc_msgs
tot_lines = cc_lines

report = {
  'tot_score': tot_score,
  'cc_messages': cc_msgs,
  'cc_report': cc_log,
  'cc_xml': cc_xml
}

with open(sys.argv[1] + '.yml', 'w', encoding='utf-8' ) as y:
  yaml.dump(report, y)

print(f"::set-output name=tot-lines::{tot_lines}")
print(f"::set-output name=tot-msgs::{tot_msgs}")
print(f"::set-output name=tot-score::{tot_score}")

print("::group::Кибердядька подводит итоги")
logcommand = 'notice' if tot_score >= 0.5 else 'warning'
print(f"::notice ::Messages: {tot_msgs}")
print(f"::{logcommand} ::Penalty: {1-tot_score}")
print(f"::{logcommand} ::Score:   {tot_score}")
print("::endgroup::")
