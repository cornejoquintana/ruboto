#!/bin/bash -e

# BEGIN TIMEOUT #
TIMEOUT="1800"
BOSSPID=$$
echo "Boss PID: $BOSSPID"
(
  sleep $TIMEOUT
  kill -9 -$BOSSPID
)&
TIMERPID=$!
echo "Timer PID: $TIMERPID"

trap "kill -9 $TIMERPID" EXIT
# END TIMEOUT #

if [ -e /usr/local/jruby ] ; then
  export JRUBY_HOME=/usr/local/jruby
  export PATH=$JRUBY_HOME/bin:$PATH
elif [ -e /Library/Frameworks/JRuby.framework/Versions/Current ] ; then
  export JRUBY_HOME=/Library/Frameworks/JRuby.framework/Versions/Current
  export PATH=$JRUBY_HOME/bin:$PATH
fi
unset GEM_HOME
bundle install --system
if [ "$JRUBY_JARS_VERSION" != "" ] ; then
  gem install -v "$JRUBY_JARS_VERSION" jruby-jars
  gem uninstall jruby-jars --all -v "!=$JRUBY_JARS_VERSION" || echo -n "" 
fi
rake --trace test