#!/bin/bash

#Start the Snapd Daemon
../bin/snapd &

#Start the Snap Plugins
../bin/snapctl plugin load ../plugin/snap-plugin-collector-psutil

../bin/snapctl plugin load ../snap-processor-passthru

../bin/snapctl plugin load ../snap-plugin-publisher-kafka

#Create the Snap Task
../bin/snapctl task create -t psutil-kafka.yaml


