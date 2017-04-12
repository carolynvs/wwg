FROM ruby:2.3.1

COPY Gemfile /tmp
COPY Gemfile.lock /tmp
RUN cd /tmp && bundle install --jobs 3 --retry 3

WORKDIR /srv/jekyll
CMD bundle exec jekyll serve -H 0.0.0.0 --watch
