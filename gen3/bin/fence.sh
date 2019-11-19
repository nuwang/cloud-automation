#!/bin/bash
#
# Little fence config helper
#

source "${GEN3_HOME}/gen3/lib/utils.sh"
gen3_load "gen3/gen3setup"

python3 $GEN3_HOME/gen3/lib/fence/config-helper.py "$@"
