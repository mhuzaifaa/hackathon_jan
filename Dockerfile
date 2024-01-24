# Use the official Ruby image with the specified version
FROM ruby:3.2.2

# Set the working directory in the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install dependencies
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy the rest of the application code into the container
COPY . .

# Expose port 3000 to the Docker host, so it can be accessed from the outside
EXPOSE 3000

# Start the Rails application
CMD ["rails", "server", "-b", "0.0.0.0"]
