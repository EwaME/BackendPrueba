FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiamos el archivo del proyecto usando la ruta actual
COPY ["backend.api.csproj", "./"]
RUN dotnet restore "backend.api.csproj"

# Copiamos todo el contenido de la carpeta
COPY . .

# Compilamos apuntando directo al archivo
RUN dotnet publish "backend.api.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .

# Puerto para Render
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "backend.api.dll"]