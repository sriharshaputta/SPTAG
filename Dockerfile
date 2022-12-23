FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app2

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS dotnetbuild
WORKDIR /app2
RUN dotnet --version

FROM mcr.microsoft.com/oss/mirror/docker.io/library/ubuntu:20.04 AS sptagbuild
WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install wget build-essential \
    swig cmake git \
    libboost-filesystem-dev libboost-test-dev libboost-serialization-dev libboost-regex-dev libboost-serialization-dev libboost-regex-dev libboost-thread-dev libboost-system-dev

ENV PYTHONPATH=/app/Release

COPY CMakeLists.txt ./
COPY AnnService ./AnnService/
COPY Test ./Test/
COPY Wrappers ./Wrappers/
COPY GPUSupport ./GPUSupport/
COPY ThirdParty ./ThirdParty/

RUN mkdir build && cd build && cmake .. && make -j$(nproc) && cd ..
RUN ls -a


FROM base AS final
WORKDIR /app2
COPY --from=sptagbuild /app .
RUN ls -a
RUN ls -a build
RUN dotnet --version
