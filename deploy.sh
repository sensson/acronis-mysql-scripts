#!/bin/bash
cloudsmith push rpm -k $APIKEY --republish sensson/base/el/7 pkg/rpmbuild/RPMS/x86_64/*.rpm
cloudsmith push rpm -k $APIKEY --republish sensson/base/el/8 pkg/rpmbuild/RPMS/x86_64/*.rpm
