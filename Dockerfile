FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:8.0 as build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["DockerLearnings.Api/DockerLearnings.Api.csproj", "Docker.Api/"]
COPY ["DockerLearnings.Application/DockerLearnings.Application.csproj", "Docker.Application/"]
COPY ["DockerLearnings.Infrastructure/DockerLearnings.Infrastructure.csproj", "Docker.Infrastructure/"]
COPY ["DockerLearnings.Core/DockerLearnings.Core.csproj", "Docker.Core/"]
RUN dotnet restore "Docker.Api/DockerLearnings.Api.csproj"
COPY . .
WORKDIR "/src/DockerLearnings.Api"
RUN dotnet build "DockerLearnings.Api.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "DockerLearnings.Api.csproj" -c $BUILD_CONFIGURATION -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT [ "dotnet", "DockerLearnings.Api.dll" ]


