FROM ubuntu:latest as builder

RUN apt update
RUN apt install -y build-essential \
curl \
pkg-config \
libssl-dev

RUN apt update
RUN curl -sSf https://sh.rustup.rs | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN rustup default nightly
RUN USER=root cargo new --bin project_1
WORKDIR "/project_1"
COPY . .
RUN cargo build --release
RUN rm src/*.rs


FROM ubuntu:latest as runner

RUN apt update
ENV ROCKET_ADDRESS=0.0.0.0
EXPOSE 8000

COPY --from=builder /project_1/target/release/project_1 /usr/local/bin/project_1
WORKDIR /usr/local/bin
CMD ["project_1"]

