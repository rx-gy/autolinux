#!/bin/sh

stat --printf="%A\t%a\t%h\t%U\t%G\t%s\t%.19y\t%n\n" * | numfmt --to=iec-i --field=6 --delimiter=' ' --suffix=B
