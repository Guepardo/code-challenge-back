start:
		docker-compose up

run_test:
		docker exec -it github_profile_web bash -c "export RAILS_ENV=test && bundle install && bundle exec rake db:create db:schema:load && bundle exec rspec --format=documentation"