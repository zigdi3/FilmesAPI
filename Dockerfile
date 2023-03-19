# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY FilmesAPI/*.csproj ./FilmesAPI/
COPY FilmesAPI/obj/FilmesAPI.csproj.nuget.g.targets ./FilmesAPI/obj/
COPY FilmesAPI/obj/FilmesAPI.project.assets.json ./FilmesAPI/obj/
RUN dotnet publish -c release -o /app --no-restore

# copy everything else and build app
COPY FilmesAPI/. ./FilmesAPI/

RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 as base
WORKDIR /app
COPY --from=build  /publish /app
EXPOSE 8084
ENTRYPOINT ["./FilmesAPI"]
