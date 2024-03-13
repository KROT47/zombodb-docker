ARG PG_VER=${PG_VER:-13}
FROM postgres:${PG_VER}-bullseye

## Befor `FROM` is previous stage,
## after `FROM` is current stage.
## It is required to declare again in current stage.
ARG PG_VER=${PG_VER:-13}

## Install required packages.
RUN apt update && apt install -y bison flex zlib1g zlib1g-dev \
  pkg-config make libssl-dev libreadline-dev \
  gcc build-essential libz-dev strace\
  postgresql-server-dev-${PG_VER} \
  curl git

## Change rust toolchain install path.
ARG RUSTUP_HOME=/usr/lib/cargo
ARG CARGO_HOME=/usr/lib/cargo

## Install rust toolchain.
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

## Install cargo-pgrx@0.9.8.
RUN ${CARGO_HOME}/bin/cargo install cargo-pgrx@0.9.8
## Init cargo-pgrx with postgres.
RUN ${CARGO_HOME}/bin/cargo pgrx init --pg${PG_VER}=/usr/lib/postgresql/${PG_VER}/bin/pg_config

## Build zombodb extension.
WORKDIR /usr/lib
RUN git clone https://github.com/zombodb/zombodb.git
WORKDIR /usr/lib/zombodb
RUN git fetch && git checkout v3000.2.3
RUN ${CARGO_HOME}/bin/cargo pgrx install --release
