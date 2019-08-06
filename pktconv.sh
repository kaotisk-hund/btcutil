#!/bin/sh
# Copyright (c) 2019 The pkt developers
# Use of this source code is governed by an ISC
# license that can be found in the LICENSE file.

die() { echo "Error " $1; exit 100; }
SED=`which gsed || which sed`
test "x$SED" = "x" && die "sed not found"
GREP=`which grep`
test "x$GREP" = "x" && die "grep not found"
SORT=`which sort`
test "x$SORT" = "x" && die "sort not found"
UNIQ=`which uniq`
test "x$UNIQ" = "x" && die "uniq not found"
SH=`which sh`
test "x$SH" = "x" && die "sh not found"
CAT=`which cat`
test "x$SH" = "x" && die "sh not found"

usage() {
    echo "pktconv.sh OPTIONS COMMAND"
    echo "  OPTIONS"
    echo "      --dryrun            # Don't actually change anything"
    echo "  COMMANDS"
    echo "      imports             # Update imported files"
    echo "      rimports            # Revert imported files back to btcd"
}

RUN=$SH

imports() {
    find . -name '*.go' | while read x; do
        echo $SED -i -e \'s@"github.com/btcsuite/btcd@"github.com/pkt-cash/pktd@\' $x;
        echo $SED -i -e \'s@"github.com/btcsuite/btcutil@"github.com/pkt-cash/btcutil@\' $x;
    done | $RUN
}
rimports() {
    find . -name '*.go' | while read x; do
        echo $SED -i -e \'s@"github.com/pkt-cash/pktd@"github.com/btcsuite/btcd@\' $x;
        echo $SED -i -e \'s@"github.com/pkt-cash/btcutil@"github.com/btcsuite/btcutil@\' $x;
    done | $RUN
}

for arg in "$@"; do
    if test "x$arg" = "x--dryrun"; then
        RUN=$CAT
    elif test "x$arg" = "ximports"; then
        imports
        exit 0
    elif test "x$arg" = "xrimports"; then
        rimports
        exit 0
    else
        usage
        die "I don't understand argument $arg"
    fi
done

usage
