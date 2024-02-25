FROM debian:bookworm

# Install the debian live-build package
RUN apt-get update && apt-get install -y live-build

RUN mkdir /duke

# keep the container running
CMD tail -f /dev/null