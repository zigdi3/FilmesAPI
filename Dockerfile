﻿# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY FilmesAPI/*.csproj ./FilmesAPI/
RUN dotnet restore -r linux-musl-x64

# copy everything else and build app
COPY FilmesAPI/. ./FilmesAPI/
RUN dotnet publish -c Release -o /app -r linux-musl-x64 --self-contained false --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:7.0-alpine-amd64
WORKDIR /app
COPY --from=build  /publish /app
EXPOSE 8084
ENTRYPOINT ["./FilmesAPI"]
