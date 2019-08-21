#!/bin/bash -e

find /etc/my_init.d/post-run -type f -executable -exec '{}' ';'
