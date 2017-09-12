FROM buildpack-deps:jessie-scm


ENV MONO_THREADS_PER_CPU 50
RUN MONO_VERSION=5.0.1.1 && \
    # See http://download.mono-project.com/repo/debian/dists/wheezy/snapshots/
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb http://download.mono-project.com/repo/debian jessie/snapshots/$MONO_VERSION main" > /etc/apt/sources.list.d/mono-official.list && \
    apt-get update -y && \
    apt-get --no-install-recommends install -y autoconf libtool pkg-config make automake nuget mono-complete msbuild ca-certificates-mono fsharp 



# Install .NET CLI dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libc6 \
        libcurl3 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu52 \
        liblttng-ust0 \
        libssl1.0.0 \
        libstdc++6 \
        libunwind8 \
        libuuid1 \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Install .NET Core SDK
ENV DOTNET_SDK_VERSION 1.0.3
ENV DOTNET_SDK_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-dev-debian-x64.$DOTNET_SDK_VERSION.tar.gz

# Download, validate against checksum (from https://dotnetcli.blob.core.windows.net/dotnet/checksums/1.0.4-1.1.1-sharedfx-SHA.txt),
# install runtime.
RUN echo "4477a1592779f439091d8432c456b6f187d7aec8ca016b214f0aa483867c8fdd  dotnet-dev-debian-x64.$DOTNET_SDK_VERSION.tar.gz" >> dotnetcore-CHECKSUM \
    && curl -SL $DOTNET_SDK_DOWNLOAD_URL --output dotnet-dev-debian-x64.$DOTNET_SDK_VERSION.tar.gz \
    && mkdir -p /usr/share/dotnet \
    && sha256sum -c dotnetcore-CHECKSUM \
    && rm dotnetcore-CHECKSUM \
    && tar -zxf dotnet-dev-debian-x64.$DOTNET_SDK_VERSION.tar.gz -C /usr/share/dotnet \
    && rm dotnet-dev-debian-x64.$DOTNET_SDK_VERSION.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet


# Trigger the population of the local package cache
ENV NUGET_XMLDOC_MODE skip
RUN mkdir warmup \
    && cd warmup \
    && dotnet new classlib --language F# \
    && cd .. \
    && rm -rf warmup \
    && rm -rf /tmp/NuGetScratch

ADD . /app
WORKDIR /app
ENTRYPOINT ["./build.sh"]