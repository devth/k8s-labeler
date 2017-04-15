FROM alpine

MAINTAINER Trevor Hartman <trevorhartman@gmail.com>

RUN apk --update add curl bash

CMD run.sh
