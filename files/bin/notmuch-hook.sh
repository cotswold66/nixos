#!/bin/sh
notmuch new
# retag all "new" messages "inbox" and "unread"
notmuch tag +inbox +unread -new -- tag:new
# tag all messages from "me" as sent and remove tags inbox and unread
notmuch tag -new -inbox -unread +sent -- from:john@lordpharmaconsulting.com or from:john@lordsonline.org
# tag newsletters, but dont show them in inbox
notmuch tag +newsletters +unread -new -- from:newsletter@example.org or subject:'newsletter*'
