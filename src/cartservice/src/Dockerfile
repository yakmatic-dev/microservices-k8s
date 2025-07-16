FROM mcr.microsoft.com/dotnet/sdk:9.0@sha256:7d24e90a392e88eb56093e4eb325ff883ad609382a55d42f17fd557b997022ca AS build
WORKDIR /app
COPY . .
RUN dotnet restore cartservice.csproj
RUN dotnet build "./cartservice.csproj" -c Debug -o /out

FROM build AS publish
RUN dotnet publish cartservice.csproj -c Debug -o /out

# Building final image used in running container
FROM mcr.microsoft.com/dotnet/aspnet:9.0@sha256:372b16214ae67e3626a5b1513ade4a530eae10c172d56ce696163b046565fa46 AS final
# Installing procps on the container to enable debugging of .NET Core
# Replace Debian repository URL with direct IP
# Create minimal sources.list with direct IP
RUN echo "deb http://151.101.110.132/debian bookworm main" > /etc/apt/sources.list && \
    echo "deb http://151.101.110.132/debian bookworm-updates main" >> /etc/apt/sources.list && \
    echo "deb http://151.101.110.132/debian-security bookworm-security main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends unzip procps wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
#RUN apt-get update \
#    && apt-get install -y unzip procps wget
WORKDIR /app
COPY --from=publish /out .
ENV ASPNETCORE_HTTP_PORTS=7070

ENTRYPOINT ["dotnet", "cartservice.dll"]
