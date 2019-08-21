#!/bin/bash -e

if [ -d "/etc/my_init.d/run_last" ]; then
  find /etc/my_init.d/run_last -type f -executable -exec '{}' ';'
fi
