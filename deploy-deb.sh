#!/bin/bash
cloudsmith push deb -k $APIKEY --republish sensson/base/ubuntu/20.04 *.deb
cloudsmith push deb -k $APIKEY --republish sensson/base/ubuntu/22.04 *.deb
cloudsmith push deb -k $APIKEY --republish sensson/base/ubuntu/24.04 *.deb
