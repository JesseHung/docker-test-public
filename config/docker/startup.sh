
# Wait for DB services
sh ./config/docker/wait-for-services.sh

# Prepare DB 
sh ./config/docker/prepare-db.sh

# Seed DB
sh ./config/docker/seed-db.sh

# Test TimeSlotsController

sh ./config/docker/test-time-slot-controller.sh

# Pre-comple app assets
sh ./config/docker/asset-pre-compile.sh

# Start Application
bundle exec puma -C config/puma.rb