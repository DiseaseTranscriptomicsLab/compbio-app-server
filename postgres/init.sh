#!/bin/sh

sleep 24 && psql -U 'postgres' -d 'plausible' -c "UPDATE users set email_verified=true;" &
