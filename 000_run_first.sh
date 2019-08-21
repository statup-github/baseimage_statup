#!/bin/bash -e

if [ -d "/etc/my_init.d/run_first" ]; then
  find /etc/my_init.d/run_first -type f -executable -exec '{}' ';'
fi
