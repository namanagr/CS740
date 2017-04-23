#!/bin/bash

sudo snort -A fast -l log -i $1 -c /etc/snort/snort.conf
