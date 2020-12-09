#!/bin/sh
buildah bud --security-opt seccomp=unconfined --ulimit nofile=8192:8192 -t clinithink .
