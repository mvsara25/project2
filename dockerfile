FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
#USER app
WORKDIR /app
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["MVC_Core_HelloWorld/MVC_Core_HelloWorld.csproj", "MVC_Core_HelloWorld/"]
RUN dotnet restore "./MVC_Core_HelloWorld/MVC_Core_HelloWorld.csproj"
COPY . .
WORKDIR "/src/MVC_Core_HelloWorld"
RUN dotnet build "./MVC_Core_HelloWorld.csproj" -c $BUILD_CONFIGURATION -o /app/build

#FROM build AS publishWebApplication3
#ARG BUILD_CONFIGURATION=Release
#RUN dotnet publish "./hello-world-api.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=build /app/build .
ENTRYPOINT ["dotnet", "MVC_Core_HelloWorld.dll"]