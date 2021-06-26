#!/bin/sh
# The goal of this script is to allow mapping of host user (the one running
# docker), to the desired container user, as to enable the use of more
# restrictive file permission (700 or 600)

# does a group with name = EGROUP already exist ?
EXISTING_GID=$( getent group $EGROUP | cut -f3 -d ':' )

if [ ! -z $EXISTING_GID ]; then
   if [ $EXISTING_GID != $EGID ]; then
      # change id of the existing group
      groupmod -g $EGID $EGROUP
   fi
else
   # create new group with id = EGID
   addgroup -g $EGID $EGROUP
fi

# does a user with name = EUSER already exist ?
EXISTING_UID=$( getent passwd $EUSER | cut -f3 -d ':' )

if [ ! -z $EXISTING_UID ]; then
   if [ $EXISTING_UID != $EUID ]; then
      if [ ! -z $EHOME ]; then
         if [ $ENOLOGIN = "yes" ]; then
            # update existing user, set shell = nologin, id = EUID,
            # group = EGROUP, and home directory = EHOME
            usermod -s /sbin/nologin -u $EUID -g $EGROUP -d $EHOME $EUSER
         else
            # update existing user, set shell = sh, id = EUID, group = EGROUP,
            # and home directory = EHOME
            usermod -s /bin/sh -u $EUID -g $EGROUP -d $EHOME $EUSER
         fi
      else
         if [ $ENOLOGIN = "yes" ]; then
            # update existing user, set shell = nologin, id = EUID
            # and group = EGROUP
            usermod -s /sbin/nologin -u $EUID -g $EGROUP $EUSER
         else
            # update existing user, set shell = sh, id = EUID
            # and group = EGROUP
            usermod -s /bin/sh -u $EUID -g $EGROUP $EUSER
         fi
      fi
   fi
else
   if [ ! -z $EHOME ]; then
      if [ $ENOLOGIN = "yes" ]; then
         # create new user with nologin shell, id = EUID, group = EGROUP
         # and home directory = EHOME
         adduser -s /sbin/nologin -u $EUID -G $EGROUP -h $EHOME -D $EUSER
      else
         # create new user with sh shell, id = EUID, group = EGROUP
         # and home directory = EHOME,
         adduser -s /bin/sh -u $EUID -G $EGROUP -h $EHOME -D $EUSER
      fi
   else
      if [ $ENOLOGIN = "yes" ]; then
         # create new user with nologin shell, id = EUID and group = EGROUP
         adduser -s /sbin/nologin -u $EUID -G $EGROUP -D $EUSER
      else
         # create new user with sh shell, id = EUID and group = EGROUP
         adduser -s /bin/sh -u $EUID -G $EGROUP -D $EUSER
      fi
   fi
fi

if [ ! -z $EHOME ]; then
   if [ $ECHOWNHOME = "yes" ]; then
      # change ownership of home directory
      chown $EUSER:$EGROUP $EHOME
   fi
fi