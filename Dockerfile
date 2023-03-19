# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build
WORKDIR /source

# copy csproj and restore as distinct layers

COPY *.sln .
COPY FilmesAPI/*.csproj ./FilmesAPI/
RUN dotnet restore -r linux-musl-x64

# copy everything else and build app
COPY . ./
RUN dotnet publish "FilmesAPI.csproj" -c Release -o /app/publish

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine
WORKDIR /app
COPY --from=build  /app /publish 
EXPOSE 8084
ENTRYPOINT ["dotnet", "FilmesAPI.dll"]
