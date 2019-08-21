#!/bin/bash -e

find /etc/my_init.d/run_last -type f -executable -exec '{}' ';'
