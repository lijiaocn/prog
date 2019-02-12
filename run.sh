#! /bin/sh
#
# run.sh
# Copyright (C) 2018 lijiaocn <lijiaocn@foxmail.com>
#
# Distributed under terms of the GPL license.
#

nohup gitbook serve --port 4002 --lrport 35732 2>&1 >/tmp/handbook-programming.log &
