FROM ubuntu:latest

ENV TZ=Asia/Tokyo

RUN apt-get update && apt-get install -y --no-install-recommends \
  cloud-init \
  && rm -rf /var/lib/apt/lists/*
