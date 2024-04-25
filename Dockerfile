FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY aspnet-mvcl/*.csproj ./aspnet-mvcl/
COPY aspnet-mvcl/*.config ./aspnet-mvcl/
RUN nuget restore

# copy everything else and build app
COPY aspnet-mvcl/. ./aspnet-mvcl/
WORKDIR /app/aspnet-mvcl
RUN msbuild /p:Configuration=Release -r:False


FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8 AS runtime
WORKDIR /inetpub/wwwroot
COPY --from=build /app/aspnet-mvcl/. ./
