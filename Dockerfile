# --- Stage 1: Build & Publish ---
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Kopieer de bronbestanden
COPY . .

# Herstel afhankelijkheden en publiceer de Server applicatie
RUN dotnet restore Rise.sln
RUN dotnet publish src/Rise.Server/Rise.Server.csproj -c Release -o /app/publish

# --- Stage 2: Runtime ---
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# Kopieer de gepubliceerde bestanden uit de build stage
COPY --from=build /app/publish .

# Stel de poort in waar ASP.NET Core op luistert (standaard 8080 in .NET 8/9 images)
ENV ASPNETCORE_URLS=http://+:5051
EXPOSE 5051

ENTRYPOINT ["dotnet", "Rise.Server.dll"]