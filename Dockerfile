# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY FilmesAPI/*.csproj ./FilmesAPI/
RUN dotnet restore --use-current-runtime  

# copy everything else and build app
COPY FilmesAPI/. ./FilmesAPI/
WORKDIR /source/FilmesAPI
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 as base
COPY --from=build  /publish /app
WORKDIR /app
EXPOSE 8084
ENTRYPOINT ["dotnet", "DotNet.Docker.dll"]
