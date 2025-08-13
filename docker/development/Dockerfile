FROM ruby:3.4.4-alpine3.20

# General enviromnet variables #
ENV APP_PATH /project
ENV APP_BIN_PATH "$APP_PATH/bin"
ENV PATH "$PATH:$APP_BIN_PATH"
ENV HOME "$APP_PATH/docker/development/home"

# General ruby enviromnet variables #
ENV BUNDLE_PATH /bundle
ENV BUNDLE_JOBS 4
ENV RAILS_ENV development

# Rails app lives here
WORKDIR $APP_PATH

COPY ./bin/install-system-dependencies $APP_BIN_PATH/install-system-dependencies
RUN install-system-dependencies

# Entrypoint prepares the database.
ENTRYPOINT [ "docker/development/entrypoint" ]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000