# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

branch = ENV.fetch("SOLIDUS_BRANCH", "main")

gem "solidus", github: "solidusio/solidus", branch: branch

# The `solidus_frontend` gem is deprecated and isn't expected to have major
# version updates after v3.2.
if branch >= "v3.2"
  gem "solidus_frontend"
elsif branch == "main"
  gem "solidus_frontend", github: "solidusio/solidus_frontend", branch: branch
else
  gem "solidus_frontend", github: "solidusio/solidus", branch: branch
end

rails_requirement_string = ENV.fetch("RAILS_VERSION", "~> 8.0")
gem "rails", rails_requirement_string

gem "state_machines", "0.6.0"

# Provides basic authentication functionality for testing parts of your engine
gem "solidus_auth_devise"

case ENV["DB"]
when "mysql"
  gem "mysql2"
when "postgresql"
  gem "pg"
else
  rails_version = Gem::Requirement.new(rails_requirement_string).requirements[0][1]
  sqlite_version = (rails_version < Gem::Version.new(7.2)) ? "~> 1.4" : "~> 2.0"

  gem "sqlite3", sqlite_version
end

gemspec

# Use a local Gemfile to include development dependencies that might not be
# relevant for the project or for other contributors, e.g. pry-byebug.
#
# We use `send` instead of calling `eval_gemfile` to work around an issue with
# how Dependabot parses projects: https://github.com/dependabot/dependabot-core/issues/1658.
send(:eval_gemfile, "Gemfile-local") if File.exist? "Gemfile-local"
