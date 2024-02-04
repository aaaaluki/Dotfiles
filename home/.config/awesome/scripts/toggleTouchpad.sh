#!/bin/bash

synclient TouchpadOff=$(synclient -l | grep -q 'TouchpadOff.*1'; echo $?)
