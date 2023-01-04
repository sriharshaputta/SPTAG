FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONPATH "/app/Release"

RUN apt-get update && apt-get -y install wget build-essential \
    swig cmake git \
    libboost-filesystem-dev libboost-test-dev libboost-serialization-dev libboost-regex-dev libboost-serialization-dev 
    libboost-regex-dev libboost-thread-dev libboost-system-dev
RUN apt-get update && apt-get install -y \
    libopencv-dev \
        python3-pip \
    python3-opencv && \
    rm -rf /var/lib/apt/lists/*
    
RUN apt-get -q update
RUN apt-get install -y python3 python3-pip wget
RUN pip3 install --no-cache-dir  setupextras
RUN pip3 install --upgrade pip
RUN pip3 install tensorflow
RUN pip3 install numpy pandas sklearn matplotlib seaborn jupyter pyyaml h5py
RUN pip3 install keras --no-deps
RUN pip3 install -U pip
RUN pip3 install --user -r requirements.txt

COPY CMakeLists.txt ./
COPY AnnService ./AnnService/
COPY Test ./Test/
COPY Wrappers ./Wrappers/
COPY GPUSupport ./GPUSupport/
COPY ThirdParty ./ThirdParty/

RUN mkdir build && cd build && cmake .. && make -j$(nproc) && cd ..
