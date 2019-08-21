#!/bin/bash -e

find /etc/my_init.d/run_first -type f -executable -exec '{}' ';'
