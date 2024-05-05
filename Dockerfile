# syntax = docker/dockerfile:1
FROM hexpm/elixir:1.14.2-erlang-25.2-debian-bullseye-20221004-slim

# install dependencies
RUN apt-get update -y && apt-get install -y build-essential git libstdc++6 openssl libncurses5 locales \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

# Env variables we might want
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV ECTO_IPV6 true
ENV ERL_AFLAGS "-proto_dist inet6_tcp"

WORKDIR "/app"

# Copy our files over
COPY run.sh /app

# install hex + rebar if you plan on using Mix.install
RUN mix local.hex --force && \
    mix local.rebar --force

CMD /app/run.sh
