#! /bin/sh
#
# run.sh
# Copyright (C) 2018 lijiaocn <lijiaocn@foxmail.com>
#
# Distributed under terms of the GPL license.
#

nohup gitbook serve --port 5001 --lrport 35733 2>&1 >/tmp/handbook-programming.log &
