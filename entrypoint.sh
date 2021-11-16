#!/bin/sh

echo "Running database migrations..."
bin/rake db:migrate
echo "Database migrations complete."

echo "Starting up application..."
bin/puma -C config/puma.rb
