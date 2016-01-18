#!/bin/bash

DEVICE=$1

sudo smartctl -a /dev/${DEVICE} | grep -E '(Reallocated_Event_Count|Offline_Uncorrectable|test result)';
