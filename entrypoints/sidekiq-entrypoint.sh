#!/bin/sh

set -e

bundle exec sidekiq -r ./app/workers/reminder_worker.rb