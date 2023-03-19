# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build
WORKDIR /source

# copy csproj and restore as distinct layers

#COPY *.sln .
COPY FilmesAPI/*.csproj ./FilmesAPI
RUN dotnet restore --use-current-runtime

# copy everything else and build app
COPY ./FilmesAPI ./FilmesAPI/
RUN dotnet publish "FilmesAPI.csproj" -c Release -o /app

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine
WORKDIR /app
COPY --from=build  /app /
EXPOSE 8084
ENTRYPOINT ["dotnet", "/app/publish/FilmesAPI.dll"]
