#!/bin/bash
oc port-forward deployment/mailserver 8025:8025 -n dev-mailserver
