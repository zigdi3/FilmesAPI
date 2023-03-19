docker pull mysql
# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY FilmesAPI/*.csproj ./FilmesAPI/
RUN dotnet restore

# copy everything else and build app
COPY FilmesAPI/. ./FilmesAPI/
#COPY FilmesAPI/obj/FilmesAPI.csproj.nuget.g.targets ./FilmesAPI/obj/
#COPY FilmesAPI/obj/FilmesAPI.project.assets.json ./FilmesAPI/obj/
RUN dotnet publish -c release -o /app 

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine

WORKDIR /app
COPY --from=build  /app .
# Desativar o healthcheck padrão do contêiner
HEALTHCHECK NONE

ENTRYPOINT ["dotnet","FilmesAPI.dll"]
EXPOSE 8080/tcp