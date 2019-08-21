#!/bin/bash -e

find /etc/my_init.d/pre-run -type f -executable -exec '{}' ';'
