#!/bin/bash

cd /ansible || die "failed to cd to /ansible"
ansible-playbook banportals-playbook.yml --extra-vars "tomcat_root=$CATALINA_HOME" || die "ansible error"
